# Rename Police

Rename Police is a macOS menu bar app that catches ugly filenames and fixes them before your Downloads folder turns into a crime scene.

## What it does

- Watches `~/Downloads`, `~/Desktop`, and `~/Documents`
- Suggests cleaner names for screenshots, installers, exports, folders, and AI-generated assets
- Supports one-click rename, custom rename, batch rename, and `Clean My Mess`
- Runs locally with no accounts, trackers, or cloud dependency

## Web site

The marketing site now lives in `site/` so it stays separate from the macOS app and out of the Xcode project flow.

- `site/app/page.tsx`: landing page
- `site/app/layout.tsx`: root layout and Vercel Analytics
- `site/app/globals.css`: site styling
- `site/package.json`: Next.js dependencies
- `vercel.json`: Vercel build config for the `site/` app

The landing page includes:

- `Download for Mac`
- `View Source`
- `Chat with Kiaan`
- `Support Me` via Dodo Payments

## Vercel setup

This repo is configured so Vercel builds the Next.js app from `site/`.

If your Vercel project still has an old Output Directory like `public`, clear that in the dashboard or redeploy after pulling the new `vercel.json`.

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
