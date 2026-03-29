//
//  RenamePoliceManager.swift
//  ragebait
//

import Foundation
import AppKit
import Combine

@MainActor
final class RenamePoliceManager: ObservableObject {
    @Published var records: [DownloadRecord] = []
    @Published var lastJudgment: String = "Watching Downloads for crimes."
    @Published var statusLine: String = "Live in Downloads"
    @Published var filesScanned = 0
    @Published var filesRenamed = 0
    @Published var notificationsEnabled = true
    @Published var autoRenameEnabled = false
    @Published var smartScreenshotsEnabled = true
    @Published var memeModeEnabled = true
    @Published var ignoredSuggestions = 0
    @Published var lastReceipt: RenameReceipt?
    @Published var stagedBatchCount = 0
    @Published var stagedBatchSummary = "No batch staged"

    private let judge = NamingJudge()
    private let monitor = DownloadMonitor()
    private let notifications = NotificationEngine()
    private let processedDefaultsKey = "renamePolice.processedResourceIDs"
    private var processedResourceIDs: Set<String> = []
    private var stagedBatchURLs: [URL] = []

    init() {
        processedResourceIDs = Set(UserDefaults.standard.stringArray(forKey: processedDefaultsKey) ?? [])
        monitor.onNewDownload = { [weak self] url in
            self?.handleDownload(url)
        }
    }

    func start() {
        notifications.requestPermission()
        rescanDownloads()
        monitor.start()
        statusLine = "Monitoring \(monitor.watchedLocationNames())"
    }

    func rescanDownloads() {
        let snapshot = monitor.snapshotFiles()
        let refreshed = snapshot.compactMap { makeRecord($0) }
            .filter { $0.judgment.severity != .clean }
            .sorted { $0.detectedAt > $1.detectedAt }

        records = Array(refreshed.prefix(20))
        filesScanned = snapshot.count
        if let first = records.first {
            lastJudgment = first.judgment.roast
        } else {
            lastJudgment = "The watched folders are surprisingly civilized."
        }
        statusLine = "Rescanned \(snapshot.count) files in \(monitor.watchedLocationNames())"
    }

    func clearFeed() {
        records.removeAll()
        lastJudgment = "Feed cleared. Standing by for new naming crimes."
        statusLine = "Feed cleared"
    }

    func renameAllFlagged() {
        let flagged = records.filter { !$0.renamed && $0.judgment.severity != .clean }
        guard !flagged.isEmpty else {
            statusLine = "Nothing messy enough to batch rename"
            return
        }

        for record in flagged {
            rename(record, silently: true)
        }

        lastJudgment = "Batch rename complete. Downloads look employable again."
        statusLine = "Renamed \(flagged.count) files"
    }

    func stageBatchItems() {
        let panel = NSOpenPanel()
        panel.title = "Choose files or folders to batch rename"
        panel.prompt = "Stage Items"
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        panel.resolvesAliases = true

        guard panel.runModal() == .OK else { return }

        stagedBatchURLs = panel.urls.filter { !$0.lastPathComponent.hasPrefix(".") }
        stagedBatchCount = stagedBatchURLs.count
        stagedBatchSummary = stagedBatchURLs.isEmpty
            ? "No batch staged"
            : "\(stagedBatchURLs.count) item\(stagedBatchURLs.count == 1 ? "" : "s") ready"
        statusLine = stagedBatchSummary
    }

    func runStagedBatchRename() {
        guard !stagedBatchURLs.isEmpty else {
            statusLine = "Pick some files or folders first"
            return
        }

        var renamedCount = 0
        var skippedCount = 0

        for url in stagedBatchURLs {
            guard let record = makeRecord(url, allowProcessed: true) else {
                skippedCount += 1
                continue
            }

            if record.judgment.severity == .clean {
                skippedCount += 1
                continue
            }

            if !records.contains(where: { $0.resourceID == record.resourceID }) {
                records.insert(record, at: 0)
            }

            rename(record, silently: true)
            renamedCount += 1
        }

        records = Array(records.prefix(16))
        stagedBatchURLs.removeAll()
        stagedBatchCount = 0
        stagedBatchSummary = "No batch staged"
        lastJudgment = renamedCount > 0
            ? "Batch rename cleaned up \(renamedCount) item\(renamedCount == 1 ? "" : "s")."
            : "Batch rename found nothing worth fixing."
        statusLine = skippedCount > 0
            ? "Batch renamed \(renamedCount), skipped \(skippedCount)"
            : "Batch renamed \(renamedCount)"
    }

    func rename(_ record: DownloadRecord) {
        rename(record, silently: false)
    }

    func rename(_ record: DownloadRecord, to customName: String) {
        let cleanedName = sanitizedName(customName, originalURL: record.url)
        guard !cleanedName.isEmpty else {
            statusLine = "Custom name was empty"
            return
        }

        let target = record.url.deletingLastPathComponent().appendingPathComponent(cleanedName)
        rename(record, targetOverride: target, silently: false)
    }

    func dismiss(_ record: DownloadRecord) {
        records.removeAll { $0.id == record.id }
        ignoredSuggestions += 1
        persistProcessedID(record.resourceID)
        statusLine = "Dismissed \(record.currentName)"
        lastJudgment = "Fine. We'll pretend '\(record.currentName)' is a conscious choice."
    }

    func undoLastRename() {
        guard let receipt = lastReceipt else {
            statusLine = "No recent rename to undo"
            return
        }

        do {
            try FileManager.default.moveItem(at: receipt.to, to: receipt.from)
            if let index = records.firstIndex(where: { $0.currentName == receipt.to.lastPathComponent || $0.originalName == receipt.from.lastPathComponent }) {
                records[index].currentName = receipt.from.lastPathComponent
                records[index].renamed = false
            }
            filesRenamed = max(0, filesRenamed - 1)
            lastJudgment = "Undo complete. Chaos restored."
            statusLine = "Undid last rename"
            lastReceipt = nil
        } catch {
            lastJudgment = "Undo failed: \(error.localizedDescription)"
            statusLine = "Undo failed"
        }
    }

    func revealDownloads() {
        DownloadMonitor.defaultDirectories().forEach { NSWorkspace.shared.open($0) }
    }

    var openCases: Int {
        records.filter { !$0.renamed && $0.judgment.severity != .clean }.count
    }

    var criticalCases: Int {
        records.filter { !$0.renamed && $0.judgment.severity == .criminal }.count
    }

    var categoryBreakdown: [(FileCategory, Int)] {
        let grouped = Dictionary(grouping: records) { $0.judgment.category }
        return FileCategory.allCases.compactMap { category in
            guard let count = grouped[category]?.count, count > 0 else { return nil }
            return (category, count)
        }
    }

    private func rename(_ record: DownloadRecord, silently: Bool) {
        let target = record.url.deletingLastPathComponent().appendingPathComponent(record.judgment.suggestedName)
        rename(record, targetOverride: target, silently: silently)
    }

    private func rename(_ record: DownloadRecord, targetOverride: URL, silently: Bool) {
        let destination = preferredDestination(for: record, target: targetOverride)

        do {
            try FileManager.default.moveItem(at: record.url, to: destination)
            if let index = records.firstIndex(where: { $0.id == record.id }) {
                records[index].url = destination
                records[index].currentName = destination.lastPathComponent
                records[index].renamed = true
                records[index].judgment = judge.judge(url: destination)
            }
            filesRenamed += 1
            lastReceipt = RenameReceipt(from: record.url, to: destination, date: Date())
            persistProcessedID(record.resourceID)
            lastJudgment = "Renamed to \(destination.lastPathComponent). Order restored."
            statusLine = silently ? "Auto-renamed \(destination.lastPathComponent)" : "Renamed \(destination.lastPathComponent)"
        } catch {
            lastJudgment = "Rename failed: \(error.localizedDescription)"
            statusLine = "Rename failed"
        }
    }

    func reveal(_ record: DownloadRecord) {
        let finalURL = record.url.deletingLastPathComponent().appendingPathComponent(record.currentName)
        NSWorkspace.shared.activateFileViewerSelecting([finalURL])
    }

    private func handleDownload(_ url: URL) {
        filesScanned += 1
        guard let record = makeRecord(url) else { return }
        guard record.judgment.severity != .clean else {
            persistProcessedID(record.resourceID)
            return
        }
        guard !records.contains(where: { $0.resourceID == record.resourceID }) else { return }

        records.insert(record, at: 0)
        records = Array(records.prefix(16))
        lastJudgment = record.judgment.roast
        statusLine = "New \(record.judgment.category.label.lowercased()) spotted"

        if shouldAutoRename(record) {
            rename(record, silently: true)
        }

        if notificationsEnabled && record.judgment.severity != .clean {
            notifications.send(title: "Rename Police", body: "\(record.currentName) -> \(record.judgment.suggestedName)")
        }
    }

    private func makeRecord(_ url: URL, allowProcessed: Bool = false) -> DownloadRecord? {
        let resourceID = resourceID(for: url)
        if !allowProcessed && processedResourceIDs.contains(resourceID) {
            return nil
        }

        let judgment = judge.judge(url: url)
        let values = try? url.resourceValues(forKeys: [.contentModificationDateKey, .isDirectoryKey])
        let detectedAt =
            values?.contentModificationDate ??
            Date()

        return DownloadRecord(
            id: UUID(),
            url: url,
            resourceID: resourceID,
            isDirectory: values?.isDirectory == true,
            originalName: url.lastPathComponent,
            currentName: url.lastPathComponent,
            detectedAt: detectedAt,
            judgment: judgment
        )
    }

    private func shouldAutoRename(_ record: DownloadRecord) -> Bool {
        guard autoRenameEnabled else { return false }
        guard record.judgment.severity != .clean else { return false }

        switch record.judgment.category {
        case .screenshot:
            return smartScreenshotsEnabled
        case .meme:
            return memeModeEnabled
        default:
            return true
        }
    }

    private func uniqueDestination(for url: URL) -> URL {
        guard FileManager.default.fileExists(atPath: url.path) else { return url }

        let ext = url.pathExtension
        let stem = url.deletingPathExtension().lastPathComponent

        for i in 2...99 {
            let candidateName = ext.isEmpty ? "\(stem)-\(i)" : "\(stem)-\(i).\(ext)"
            let candidate = url.deletingLastPathComponent().appendingPathComponent(candidateName)
            if !FileManager.default.fileExists(atPath: candidate.path) {
                return candidate
            }
        }

        return url
    }

    private func preferredDestination(for record: DownloadRecord, target: URL) -> URL {
        if record.currentName == target.lastPathComponent || record.originalName == target.lastPathComponent {
            return record.url
        }

        return uniqueDestination(for: target)
    }

    private func resourceID(for url: URL) -> String {
        let values = try? url.resourceValues(forKeys: [.fileResourceIdentifierKey, .fileSizeKey, .contentModificationDateKey])
        if let identifier = values?.fileResourceIdentifier {
            return String(describing: identifier)
        }

        let size = values?.fileSize ?? 0
        let timestamp = values?.contentModificationDate?.timeIntervalSince1970 ?? 0
        return "\(url.path)|\(size)|\(timestamp)"
    }

    private func persistProcessedID(_ id: String) {
        processedResourceIDs.insert(id)
        let trimmed = Array(processedResourceIDs).suffix(800)
        processedResourceIDs = Set(trimmed)
        UserDefaults.standard.set(Array(processedResourceIDs), forKey: processedDefaultsKey)
    }

    private func sanitizedName(_ proposed: String, originalURL: URL) -> String {
        let trimmed = proposed.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }

        let invalid = CharacterSet(charactersIn: "/:")
        let cleaned = trimmed.components(separatedBy: invalid).joined(separator: "-")
        let hasExtension = URL(fileURLWithPath: cleaned).pathExtension.isEmpty == false

        if hasExtension || originalURL.pathExtension.isEmpty {
            return cleaned
        }

        return "\(cleaned).\(originalURL.pathExtension)"
    }
}
