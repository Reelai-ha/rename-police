# Rename Police

Rename Police is a macOS menu bar app that catches ugly filenames and fixes them before your Downloads folder turns into a crime scene.

## Repo layout

This repo now has two clearly separate parts:

- `RenamePolice/`: the macOS SwiftUI app for Xcode
- `site/`: the Next.js marketing site for Vercel

Important:

- Xcode should use only `RenamePolice.xcodeproj`
- Vercel should deploy the repo root, which delegates to `site/`
- The web files are intentionally outside the Xcode source folder

## What the app does

- Watches `~/Downloads`, `~/Desktop`, and `~/Documents`
- Suggests cleaner names for screenshots, installers, exports, folders, and AI-generated assets
- Supports one-click rename, custom rename, batch rename, and `Clean My Mess`
- Runs locally with no accounts, trackers, or cloud dependency

## Web site

The landing page lives in `site/`.

- `site/app/page.tsx`: landing page
- `site/app/layout.tsx`: root layout and Vercel Analytics
- `site/app/globals.css`: site styling
- `site/package.json`: site-specific package metadata
- `package.json`: root workspace package so Vercel detects Next.js reliably

The landing page includes:

- `Download for Mac`
- `View Source`
- `Chat with Kiaan`
- `Support Me` via Dodo Payments

## Vercel

If Vercel was previously configured with a custom Root Directory or Output Directory, reset those to defaults and redeploy.

This repo now works best with:

- Root Directory: repo root
- Framework Preset: Next.js
- Build settings: auto-detected

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
