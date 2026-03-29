//
//  RenamePoliceApp.swift
//  Rename Police
//

import SwiftUI

@main
struct RenamePoliceApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra {
            ContentView(manager: appDelegate.manager)
        } label: {
            MenuBarIcon(manager: appDelegate.manager)
        }
        .menuBarExtraStyle(.window)
    }
}

struct MenuBarIcon: View {
    @ObservedObject var manager: RenamePoliceManager

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: manager.criticalCases > 0 ? "shield.lefthalf.filled.badge.checkmark" : "folder.badge.questionmark")
                .foregroundStyle(manager.criticalCases > 0 ? .orange : .primary)

            if manager.openCases > 0 {
                Text("\(min(manager.openCases, 9))")
                    .font(.system(size: 8, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(3)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 6, y: -5)
            }
        }
        .imageScale(.medium)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let manager = RenamePoliceManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        manager.start()
    }
}
