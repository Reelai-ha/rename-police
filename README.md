# Rename Police

Rename Police is a macOS menu bar app that catches ugly filenames and fixes them before your Downloads folder turns into a crime scene.

## What it does

- Watches `~/Downloads`, `~/Desktop`, and `~/Documents`
- Suggests cleaner names for screenshots, installers, exports, folders, and AI-generated assets
- Supports one-click rename, custom rename, batch rename, and `Clean My Mess`
- Runs locally with no accounts, trackers, or cloud dependency

## Landing page

The repo includes a Next.js landing page ready for Vercel.

- `app/page.tsx`: marketing homepage
- `app/layout.tsx`: root layout and Vercel Analytics
- `app/globals.css`: site styling
- `package.json`: Next.js and analytics dependencies

The landing page includes:

- `Download for Mac`
- `View Source`
- `Chat with Kiaan`
- `Support Me` via Dodo Payments

## Download flow

You do not need a `.dmg` for v1.

The smoothest setup is:

1. Build the macOS app in Xcode.
2. Zip the generated `.app` bundle.
3. Upload that `.zip` to a GitHub Release.
4. Point the landing page download button to `releases/latest`.

This is faster to ship, easy to update, and works well with Vercel + GitHub.

For local packaging, run `./scripts/package-mac.sh` to create a release zip, or `./scripts/package-mac.sh --dmg` if you want a DMG too.

## macOS app structure

- `RenamePolice/RenamePoliceApp.swift`: app entry and menu bar setup
- `RenamePolice/ContentView.swift`: main interface
- `RenamePolice/RenamePoliceManager.swift`: app state and rename actions
- `RenamePolice/NamingJudge.swift`: filename scoring and suggestion logic
- `RenamePolice/RenamePoliceModels.swift`: shared models
- `RenamePolice/DownloadMonitor.swift`: watched-folder polling
- `RenamePolice/NotificationEngine.swift`: native notification wrapper
- `docs/PRD.md`: product requirements and v1 scope

## Features in v1

- Menu bar first UI
- Smart screenshot naming
- Better installer cleanup
- AI-export aware suggestions
- Batch rename for files and folders
- Custom rename from the menu bar
- `Clean My Mess` one-click Downloads cleanup
- Undo last rename
- Open source, local-first
