# Rename Police

Rename Police is a macOS menu bar app that watches your Downloads folder, flags messy filenames, and suggests cleaner names with a little attitude.

## What it does

- Detects new files in `~/Downloads`
- Classifies files like screenshots, installers, memes, documents, and archives
- Scores ugly names and suggests better replacements
- Lets you rename files one by one or batch-rename flagged files
- Supports auto-rename for people who want a cleaner Downloads folder without thinking about it
- Keeps the app lightweight and local-only

## Why this exists

Downloads folders are where file names go to die. This app makes cleanup fast enough that people might actually do it.

## Current feature set

- Live Downloads monitoring
- Smart screenshot naming with timestamps
- Installer cleanup
- Meme-mode naming for internet junk
- Native macOS notifications
- Undo last rename
- Open-source, no paywall

## Project structure

- `ragebait/ragebaitApp.swift`: App entry and menu bar setup
- `ragebait/ContentView.swift`: Main interface
- `ragebait/RenamePoliceManager.swift`: App state and rename actions
- `ragebait/NamingJudge.swift`: Filename scoring and suggestion logic
- `ragebait/RenamePoliceModels.swift`: Shared models
- `ragebait/DownloadMonitor.swift`: Downloads polling
- `ragebait/NotificationEngine.swift`: Native notification wrapper

## Dev notes

- Built with SwiftUI for macOS
- No network dependency
- No cookies, trackers, or accounts

## Good files to test with

- `Screenshot 2026-03-29 at 4.40.15 PM.png`
- `final-final-copy.pdf`
- `Discord Download 4921.png`
- `CoolApp-2.1.4-macOS.dmg`
- `IMG_9021.JPG`
