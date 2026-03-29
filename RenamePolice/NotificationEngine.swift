//
//  NotificationEngine.swift
//  Rename Police
//
//  Thin wrapper around native macOS notifications.
//

import UserNotifications
import Foundation

class NotificationEngine {

    private let center = UNUserNotificationCenter.current()
    private var lastNotifTime: Date = .distantPast
    private let minNotifInterval: TimeInterval = 2.5

    // MARK: - Setup

    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error { print("[NotificationEngine] Permission error: \(error)") }
            if !granted  { print("[NotificationEngine] ⚠️  Notifications denied — go to System Settings → Notifications → Rename Police → Allow") }
        }
    }

    func send(title: String, body: String) {
        let now = Date()
        guard now.timeIntervalSince(lastNotifTime) >= minNotifInterval else { return }
        lastNotifTime = now
        fire(id: UUID().uuidString, title: title, body: body)
    }
    private func fire(id: String, title: String, body: String) {
        let content       = UNMutableNotificationContent()
        content.title     = title
        content.body      = body
        content.sound     = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request) { err in
            if let err { print("[NotificationEngine] Send failed: \(err)") }
        }
    }
}
