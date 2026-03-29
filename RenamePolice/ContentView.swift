//
//  ContentView.swift
//  Rename Police
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: RenamePoliceManager
    @AppStorage("renamePolice.hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var customRenameRecord: DownloadRecord?
    @State private var customRenameInput = ""
    @State private var displayedRecordLimit = 6

    var body: some View {
        ZStack {
            Color(red: 0.12, green: 0.10, blue: 0.11)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    if !hasSeenOnboarding {
                        onboardingCard
                    }
                    heroCard
                    dashboardGrid
                    labCard
                    feedCard
                    footerCard
                }
                .padding(16)
            }
        }
        .frame(width: 420, height: 610)
        .sheet(item: $customRenameRecord) { record in
            customRenameSheet(record)
        }
    }

    var onboardingCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("WELCOME TO THE PRECINCT")
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundColor(Color(red: 0.98, green: 0.78, blue: 0.54))

            Text("Watches your key folders. Flags messy names. Lets you fix them fast.")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            HStack(spacing: 10) {
                onboardingTag("1", "Scan key folders")
                onboardingTag("2", "Review suggestions")
                onboardingTag("3", "Rename or batch-fix")
            }

            Button("Start Patrolling") {
                hasSeenOnboarding = true
            }
            .buttonStyle(ActionButtonStyle(fill: Color(red: 0.98, green: 0.54, blue: 0.12), text: .white))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    var heroCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("RENAME POLICE")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Batch rename and clean up filenames.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.72))
                }
                Spacer()
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(Color(red: 0.97, green: 0.80, blue: 0.52))
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Text(manager.lastJudgment)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Text(manager.statusLine.uppercased())
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.white.opacity(0.66))

            HStack(spacing: 8) {
                statPill("Scanned", "\(manager.filesScanned)")
                statPill("Renamed", "\(manager.filesRenamed)")
                statPill("Cleaned", "\(manager.cleanedMessCount)")
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(red: 0.24, green: 0.15, blue: 0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    var dashboardGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                summaryCard(
                    title: "Critical",
                    value: "\(manager.criticalCases)",
                    caption: "Felonies waiting",
                    color: Color(red: 1.0, green: 0.44, blue: 0.30)
                )
                summaryCard(
                    title: "Ignored",
                    value: "\(manager.ignoredSuggestions)",
                    caption: "You overruled us",
                    color: Color(red: 0.34, green: 0.78, blue: 0.72)
                )
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("TRAFFIC")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(.white.opacity(0.70))
                    Spacer()
                    Text("\(manager.records.count) items")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.white.opacity(0.54))
                }

                if manager.categoryBreakdown.isEmpty {
                    Text("No recent activity yet.")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.74))
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(manager.categoryBreakdown, id: \.0.rawValue) { item in
                                categoryPill(category: item.0, count: item.1)
                            }
                        }
                    }
                }
            }
            .padding(14)
            .panelBackground()
        }
    }

    var labCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CONTROL LAB")
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundColor(.white.opacity(0.70))

            VStack(spacing: 8) {
                HStack {
                    Text("Alerts")
                    Spacer()
                    Toggle("", isOn: $manager.notificationsEnabled)
                }
                HStack {
                    Text("Auto rename")
                    Spacer()
                    Toggle("", isOn: $manager.autoRenameEnabled)
                }
                HStack {
                    Text("Smart screenshots")
                    Spacer()
                    Toggle("", isOn: $manager.smartScreenshotsEnabled)
                }
                HStack {
                    Text("Meme mode")
                    Spacer()
                    Toggle("", isOn: $manager.memeModeEnabled)
                }
            }
            .toggleStyle(.switch)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 6) {
                Text("Batch")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(.white.opacity(0.70))
                Text(manager.stagedBatchSummary)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.58))
            }

            HStack(spacing: 8) {
                Button("Clean My Mess") { manager.cleanMyMess() }
                    .buttonStyle(ActionButtonStyle(fill: Color(red: 0.97, green: 0.74, blue: 0.24), text: Color.black.opacity(0.82)))
                Button("Scan Now") { manager.rescanDownloads() }
                    .buttonStyle(ActionButtonStyle(fill: Color(red: 0.88, green: 0.48, blue: 0.18), text: .white))
                Button("Rename All") { manager.renameAllFlagged() }
                    .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.14), text: .white))
            }

            HStack(spacing: 8) {
                Button("Undo") { manager.undoLastRename() }
                    .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.12), text: .white))
                Button("Pick Batch") { manager.stageBatchItems() }
                    .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.12), text: .white))
                Button("Run Batch") { manager.runStagedBatchRename() }
                    .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.12), text: .white))
                Button("Open Folders") { manager.revealDownloads() }
                    .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.12), text: .white))
            }

            Button("Clear Feed") { manager.clearFeed() }
                .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.08), text: .white))
        }
        .padding(14)
        .panelBackground()
    }

    var feedCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("RECENT CASES")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundColor(.white.opacity(0.70))
                Spacer()
                Text("\(manager.records.count) tracked")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.54))
            }

            if manager.records.isEmpty {
                VStack(spacing: 10) {
                    Text("Nothing suspicious yet.")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("New messy items will show up here.")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.64))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                ForEach(visibleRecords) { record in
                    caseRow(record)
                    if record.id != visibleRecords.last?.id {
                        Divider().overlay(Color.black.opacity(0.08))
                    }
                }

                if manager.records.count > displayedRecordLimit {
                    Button("Load More") {
                        displayedRecordLimit += 6
                    }
                    .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.10), text: .white))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
                }
            }
        }
        .padding(16)
        .panelBackground()
    }

    var visibleRecords: [DownloadRecord] {
        Array(manager.records.prefix(displayedRecordLimit))
    }

    var footerCard: some View {
        HStack(spacing: 10) {
            Button("View Source") {
                openLink("https://github.com/Reelai-ha/rename-police")
            }
            .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.08), text: .white))

            Spacer()

            Button("Made by Kiaan") {
                openLink("https://x.com/kiaan_mittal")
            }
            .buttonStyle(ActionButtonStyle(fill: Color.clear, text: Color.white.opacity(0.72)))
        }
        .padding(.horizontal, 4)
    }

    func caseRow(_ record: DownloadRecord) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.currentName)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    HStack(spacing: 6) {
                        Label(record.isDirectory ? "Folder" : record.judgment.category.label, systemImage: record.isDirectory ? "folder.fill" : record.judgment.category.symbol)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                        Text("\(record.judgment.confidence)% confidence")
                            .font(.system(size: 10, design: .monospaced))
                    }
                    .foregroundColor(.white.opacity(0.58))
                }
                Spacer()
                severityBadge(record.judgment.severity)
            }

            Text(record.judgment.reason)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.white.opacity(0.54))

            HStack {
                Text("Suggested: \(record.judgment.suggestedName)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.60))
                    .lineLimit(1)
                Spacer()
                Button("Skip") {
                    manager.dismiss(record)
                }
                .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.10), text: .white))
                Button("Custom") {
                    customRenameInput = record.currentName
                    customRenameRecord = record
                }
                .buttonStyle(ActionButtonStyle(fill: Color.white.opacity(0.10), text: .white))
                Button(record.renamed ? "Reveal" : "Rename") {
                    if record.renamed {
                        manager.reveal(record)
                    } else {
                        manager.rename(record)
                    }
                }
                .buttonStyle(ActionButtonStyle(
                    fill: record.renamed ? Color.white.opacity(0.14) : Color(red: 0.98, green: 0.54, blue: 0.12),
                    text: .white
                ))
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func customRenameSheet(_ record: DownloadRecord) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Rename")
                .font(.system(size: 22, weight: .black, design: .rounded))
            Text(record.currentName)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.secondary)
                .lineLimit(2)

            TextField("Enter a new filename", text: $customRenameInput)
                .textFieldStyle(.roundedBorder)

            Text("Tip: keep the extension or we’ll carry the current one forward for you.")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)

            HStack {
                Button("Cancel") {
                    customRenameRecord = nil
                }
                .buttonStyle(.bordered)

                Spacer()

                Button("Rename") {
                    manager.rename(record, to: customRenameInput)
                    customRenameRecord = nil
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.92, green: 0.44, blue: 0.12))
            }
        }
        .padding(24)
        .frame(width: 420)
    }

    func openLink(_ string: String) {
        guard let url = URL(string: string) else { return }
        NSWorkspace.shared.open(url)
    }

    func statPill(_ title: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 15, weight: .black, design: .rounded))
            Text(title.uppercased())
                .font(.system(size: 9, weight: .bold, design: .monospaced))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    func severityBadge(_ severity: NamingSeverity) -> some View {
        Text(severity.label.uppercased())
            .font(.system(size: 9, weight: .black, design: .monospaced))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .foregroundColor(.white)
            .background(severity == .criminal ? Color.red.opacity(0.85) : Color.orange.opacity(0.48))
            .clipShape(Capsule())
    }

    func summaryCard(title: String, value: String, caption: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundColor(.white.opacity(0.62))
            Text(value)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundColor(.white)
            Text(caption)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.70))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(color.opacity(0.28))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    func categoryPill(category: FileCategory, count: Int) -> some View {
        HStack(spacing: 8) {
            Image(systemName: category.symbol)
            Text(category.label)
            Text("\(count)")
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.white.opacity(0.10))
                .clipShape(Capsule())
        }
        .font(.system(size: 12, weight: .semibold, design: .rounded))
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(Color.white.opacity(0.08))
        .clipShape(Capsule())
    }

    func onboardingTag(_ step: String, _ label: String) -> some View {
        HStack(spacing: 8) {
            Text(step)
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundColor(Color.black.opacity(0.72))
                .frame(width: 20, height: 20)
                .background(Color(red: 1.0, green: 0.82, blue: 0.54))
                .clipShape(Circle())
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.08))
        .clipShape(Capsule())
    }
}

private struct ActionButtonStyle: ButtonStyle {
    let fill: Color
    let text: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(fill.opacity(configuration.isPressed ? 0.78 : 1))
            .foregroundColor(text)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

private extension View {
    func panelBackground() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )
    }
}
