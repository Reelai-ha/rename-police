//
//  RenamePoliceModels.swift
//  Rename Police
//

import Foundation

enum NamingSeverity: String {
    case clean
    case warning
    case criminal

    var label: String {
        switch self {
        case .clean: return "Clean"
        case .warning: return "Messy"
        case .criminal: return "Criminal"
        }
    }
}

enum FileCategory: String, CaseIterable {
    case screenshot
    case installer
    case meme
    case aiAsset
    case document
    case archive
    case media
    case generic

    var label: String {
        switch self {
        case .screenshot: return "Screenshot"
        case .installer: return "Installer"
        case .meme: return "Meme"
        case .aiAsset: return "AI Asset"
        case .document: return "Document"
        case .archive: return "Archive"
        case .media: return "Media"
        case .generic: return "Generic"
        }
    }

    var symbol: String {
        switch self {
        case .screenshot: return "camera.viewfinder"
        case .installer: return "shippingbox.fill"
        case .meme: return "sparkles.tv.fill"
        case .aiAsset: return "wand.and.stars"
        case .document: return "doc.text.fill"
        case .archive: return "archivebox.fill"
        case .media: return "photo.on.rectangle.angled"
        case .generic: return "tag.fill"
        }
    }
}

struct FilenameJudgment: Equatable {
    let score: Int
    let severity: NamingSeverity
    let category: FileCategory
    let reason: String
    let suggestedName: String
    let roast: String
    let confidence: Int
}

struct DownloadRecord: Identifiable, Equatable {
    let id: UUID
    var url: URL
    let resourceID: String
    let isDirectory: Bool
    let originalName: String
    var currentName: String
    let detectedAt: Date
    var judgment: FilenameJudgment
    var renamed: Bool = false
}

struct RenameReceipt: Equatable {
    let from: URL
    let to: URL
    let date: Date
}
