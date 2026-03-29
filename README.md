# Rename Police

Rename Police is a macOS menu bar app for cleaning up filenames and folder names without opening Finder rename flows all day.

## What it does

- Detects new files in `~/Downloads`, `~/Desktop`, and `~/Documents`
- Classifies files like screenshots, installers, memes, documents, and archives
- Scores ugly names and suggests better replacements
- Lets you rename files one by one, batch-rename flagged items, or manually override a name from the menu bar
- Supports auto-rename for people who want a cleaner Downloads folder without thinking about it
- Keeps the app lightweight and local-only

## Why this exists

Finder cleanup is still more manual than it should be. Rename Police is meant to be a fast v1 utility that catches messy names early and makes fixing them feel immediate.

## Current feature set

- Downloads, Desktop, and Documents monitoring
- Smart screenshot naming with timestamps
- Installer cleanup
- Meme-mode naming for internet junk
- Native macOS notifications
- Undo last rename
- Batch rename for files and folders
- Custom rename from the menu bar
- Open-source, no paywall

## Project structure

- `RenamePolice/RenamePoliceApp.swift`: App entry and menu bar setup
- `RenamePolice/ContentView.swift`: Main interface
- `RenamePolice/RenamePoliceManager.swift`: App state and rename actions
- `RenamePolice/NamingJudge.swift`: Filename scoring and suggestion logic
- `RenamePolice/RenamePoliceModels.swift`: Shared models
- `RenamePolice/DownloadMonitor.swift`: watched-folder polling
- `RenamePolice/NotificationEngine.swift`: Native notification wrapper
- `docs/PRD.md`: product requirements and v1 scope

## Dev notes

- Built with SwiftUI for macOS
- No network dependency
- No cookies, trackers, or accounts

## V1 notes

- The app is intentionally menu-bar first
- Suggestions are heuristic, not AI-generated
- Batch rename currently runs from a staged picker inside the app

## Good files to test with

- `Screenshot 2026-03-29 at 4.40.15 PM.png`
- `final-final-copy.pdf`
- `Discord Download 4921.png`
- `CoolApp-2.1.4-macOS.dmg`
- `IMG_9021.JPG`
