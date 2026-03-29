# Rename Police

Rename Police is a macOS menu bar app that watches common user folders, flags messy file and folder names, and suggests cleaner replacements with a little attitude.

## What it does

- Detects new files in `~/Downloads`, `~/Desktop`, and `~/Documents`
- Classifies files like screenshots, installers, memes, documents, and archives
- Scores ugly names and suggests better replacements
- Lets you rename files one by one, batch-rename flagged items, or manually override a name from the menu bar
- Supports auto-rename for people who want a cleaner Downloads folder without thinking about it
- Keeps the app lightweight and local-only

## Why this exists

Finder cleanup is still more manual than it should be. Rename Police makes naming cleanup fast enough that people might actually keep their folders sane.

## Current feature set

- Live Downloads monitoring
- Desktop and Documents monitoring
- Smart screenshot naming with timestamps
- Installer cleanup
- Meme-mode naming for internet junk
- Native macOS notifications
- Undo last rename
- Batch rename for files and folders
- Custom rename from the menu bar
- Open-source, no paywall

## Project structure

- `ragebait/ragebaitApp.swift`: App entry and menu bar setup
- `ragebait/ContentView.swift`: Main interface
- `ragebait/RenamePoliceManager.swift`: App state and rename actions
- `ragebait/NamingJudge.swift`: Filename scoring and suggestion logic
- `ragebait/RenamePoliceModels.swift`: Shared models
- `ragebait/DownloadMonitor.swift`: watched-folder polling
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
