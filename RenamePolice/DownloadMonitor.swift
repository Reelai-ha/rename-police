//
//  DownloadMonitor.swift
//  Rename Police
//

import Foundation

@MainActor
final class DownloadMonitor {
    var onNewDownload: ((URL) -> Void)?

    private let watchedDirectories: [URL]
    private var timer: Timer?
    private var knownFiles = Set<URL>()

    init(watchedDirectories: [URL] = DownloadMonitor.defaultDirectories()) {
        self.watchedDirectories = watchedDirectories
    }

    func start() {
        guard timer == nil else { return }
        knownFiles = currentFiles()

        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.poll()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func poll() {
        let files = currentFiles()
        let newFiles = files.subtracting(knownFiles)
        knownFiles = files

        for file in newFiles {
            onNewDownload?(file)
        }
    }

    private func currentFiles() -> Set<URL> {
        Set(watchedDirectories.flatMap(files(in:)))
    }

    func snapshotFiles() -> [URL] {
        Array(currentFiles()).sorted { $0.lastPathComponent.localizedCaseInsensitiveCompare($1.lastPathComponent) == .orderedAscending }
    }

    func watchedLocationNames() -> String {
        watchedDirectories.map(\.lastPathComponent).joined(separator: ", ")
    }

    private func files(in directory: URL) -> [URL] {
        let urls = (try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey],
            options: [.skipsHiddenFiles]
        )) ?? []

        return urls.filter { url in
            guard (try? url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true else { return false }
            return !isNoise(url)
        }
    }

    private func isNoise(_ url: URL) -> Bool {
        let name = url.lastPathComponent.lowercased()
        let blockedSuffixes = [".app", ".download", ".part", ".crdownload", ".tmp"]
        if blockedSuffixes.contains(where: name.hasSuffix) {
            return true
        }

        let blockedNames = ["desktop.ini", ".ds_store"]
        return blockedNames.contains(name)
    }

    nonisolated static func defaultDirectories() -> [URL] {
        let manager = FileManager.default
        let candidates = [
            manager.urls(for: .downloadsDirectory, in: .userDomainMask).first,
            manager.urls(for: .desktopDirectory, in: .userDomainMask).first,
            manager.urls(for: .documentDirectory, in: .userDomainMask).first
        ]

        return candidates.compactMap { $0 }
    }
}
