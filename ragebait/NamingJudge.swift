//
//  NamingJudge.swift
//  ragebait
//

import Foundation

struct NamingJudge {
    func judge(url: URL) -> FilenameJudgment {
        let ext = url.pathExtension
        let base = url.deletingPathExtension().lastPathComponent
        let normalized = base.lowercased()
        let category = classify(base: base, ext: ext.lowercased())

        var score = 0
        var reasons: [String] = []

        let badWords = ["untitled", "final", "copy", "new folder", "temp", "document", "image", "img", "scan", "download", "edited", "edit", "version", "draft"]
        for word in badWords where normalized.contains(word) {
            score += 20
            reasons.append("contains '\(word)'")
        }

        if normalized.range(of: #"\b\d{3,}\b"#, options: .regularExpression) != nil {
            score += 10
            reasons.append("has random numbers")
        }

        if normalized.contains("  ") || normalized.contains("__") || normalized.contains("--") {
            score += 8
            reasons.append("spacing chaos")
        }

        if base.count > 38 {
            score += 8
            reasons.append("too long")
        }

        if base == base.uppercased(), base.count > 5 {
            score += 10
            reasons.append("all caps meltdown")
        }

        if normalized.range(of: #"(final)+.*(final)+"#, options: .regularExpression) != nil {
            score += 25
            reasons.append("double-final behavior")
        }

        if normalized.range(of: #"(img|dsc|pxl|mvimg)[\-_ ]?\d{3,}"#, options: .regularExpression) != nil {
            score += 16
            reasons.append("camera-default name")
        }

        if normalized.range(of: #"(screenshot|screen shot)"#, options: .regularExpression) != nil {
            score += 18
            reasons.append("default screenshot name")
        }

        if normalized.range(of: #"\b(v|ver|version)[\-_ ]?\d+\b"#, options: .regularExpression) != nil {
            score += 6
            reasons.append("version clutter")
        }

        if normalized.range(of: #"[\(\[]\d+[\)\]]"#, options: .regularExpression) != nil {
            score += 8
            reasons.append("duplicate suffix")
        }

        if normalized.contains("discord") || normalized.contains("reddit") || normalized.contains("meme") || normalized.contains("shitpost") {
            score += 12
            reasons.append("internet goblin energy")
        }

        switch category {
        case .screenshot:
            score += 10
            reasons.append("could use a timestamped screenshot name")
        case .installer:
            score += 8
            reasons.append("installer should name the app clearly")
        case .meme:
            score += 8
            reasons.append("meme deserves an actual label")
        default:
            break
        }

        let severity: NamingSeverity =
            score >= 35 ? .criminal :
            score >= 15 ? .warning :
                          .clean

        let reason = reasons.isEmpty ? "surprisingly acceptable" : reasons.joined(separator: ", ")
        let suggested = suggestName(base: base, ext: ext, category: category, url: url)
        let roast = roastLine(for: severity, current: base, suggested: suggested, category: category)
        let confidence = min(98, max(42, 55 + score))

        return FilenameJudgment(
            score: score,
            severity: severity,
            category: category,
            reason: reason,
            suggestedName: suggested,
            roast: roast,
            confidence: confidence
        )
    }

    private func suggestName(base: String, ext: String, category: FileCategory, url: URL) -> String {
        switch category {
        case .screenshot:
            let stamp = screenshotStamp(for: url)
            return ext.isEmpty ? "screenshot-\(stamp)" : "screenshot-\(stamp).\(ext.lowercased())"
        case .installer:
            let appName = installerWords(from: base)
                .prefix(2)
                .joined(separator: "-")
            let stem = appName.isEmpty ? "app-installer" : "\(appName)-installer"
            return ext.isEmpty ? stem : "\(stem).\(ext.lowercased())"
        case .meme:
            let topic = cleanWords(from: base, banned: commonBannedWords + ["discord", "reddit", "shitpost", "meme"])
                .prefix(3)
                .joined(separator: "-")
            let stem = topic.isEmpty ? "meme-drop" : "meme-\(topic)"
            return ext.isEmpty ? stem : "\(stem).\(ext.lowercased())"
        default:
            break
        }

        let words = cleanWords(from: base, banned: commonBannedWords)
        let fallback = fallbackStem(forExtension: ext, category: category)
        let stem = words.prefix(4).joined(separator: "-")
        let finalStem = stem.isEmpty ? fallback : stem
        return ext.isEmpty ? finalStem : "\(finalStem).\(ext.lowercased())"
    }

    private var commonBannedWords: [String] {
        let banned = ["untitled", "final", "copy", "new", "folder", "temp", "document", "image", "img", "download"]
        return banned
    }

    private func cleanWords(from base: String, banned: [String]) -> [String] {
        base
            .replacingOccurrences(of: #"([a-z])([A-Z])"#, with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: #"[^\p{L}\p{N}]+"#, with: " ", options: .regularExpression)
            .lowercased()
            .split(separator: " ")
            .map(String.init)
            .filter { !$0.isEmpty && !banned.contains($0) && !$0.allSatisfy(\.isNumber) }
    }

    private func installerWords(from base: String) -> [String] {
        let banned = commonBannedWords + [
            "mac",
            "macos",
            "osx",
            "desktop",
            "installer",
            "setup",
            "update",
            "universal",
            "intel",
            "apple",
            "silicon",
            "arm64",
            "x64",
            "x86",
            "latest",
            "stable",
            "beta",
            "release",
            "app"
        ]

        return cleanWords(from: base, banned: banned).filter { token in
            token.range(of: #"^\d+(\.\d+)+$"#, options: .regularExpression) == nil
        }
    }

    private func fallbackStem(forExtension ext: String, category: FileCategory) -> String {
        switch category {
        case .screenshot: return "screenshot"
        case .installer: return "app-installer"
        case .meme: return "meme-drop"
        case .document: return "document"
        case .archive: return "archive"
        case .media: return "media-file"
        case .generic: break
        }

        switch ext.lowercased() {
        case "png", "jpg", "jpeg", "gif", "webp": return "image-asset"
        case "pdf": return "document"
        case "zip": return "archive"
        case "dmg", "pkg": return "installer"
        case "mov", "mp4": return "video-clip"
        case "csv", "xlsx": return "spreadsheet"
        default: return "renamed-file"
        }
    }

    private func roastLine(for severity: NamingSeverity, current: String, suggested: String, category: FileCategory) -> String {
        switch severity {
        case .clean:
            return "'\(current)' is acceptable. We love a low-drama file."
        case .warning:
            return "'\(current)' needs adult supervision. Try '\(suggested)' before it multiplies."
        case .criminal:
            switch category {
            case .screenshot:
                return "'\(current)' looks like a hostage screenshot. Rename it to '\(suggested)'."
            case .installer:
                return "'\(current)' is installer sludge. '\(suggested)' is far less cursed."
            case .meme:
                return "'\(current)' is chaotic meme contraband. Call it '\(suggested)'."
            default:
                return "'\(current)' is a naming felony. Rename it to '\(suggested)'."
            }
        }
    }

    private func classify(base: String, ext: String) -> FileCategory {
        let normalized = base.lowercased()

        if normalized.contains("screenshot") || normalized.contains("screen shot") {
            return .screenshot
        }

        if ["dmg", "pkg"].contains(ext) {
            return .installer
        }

        if ["zip"].contains(ext) {
            return normalized.contains("installer") || normalized.contains("setup") ? .installer : .archive
        }

        if normalized.contains("meme")
            || normalized.contains("shitpost")
            || normalized.contains("discord")
            || normalized.contains("reddit")
            || normalized.contains("reaction")
        {
            return .meme
        }

        if ["png", "jpg", "jpeg", "gif", "webp", "mp4", "mov"].contains(ext) {
            return .media
        }

        if ["pdf", "doc", "docx", "txt", "rtf", "md", "pages"].contains(ext) {
            return .document
        }

        return .generic
    }

    private func screenshotStamp(for url: URL) -> String {
        let date =
            (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ??
            Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd-HHmm"
        return formatter.string(from: date)
    }
}
