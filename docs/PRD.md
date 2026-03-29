# Rename Police PRD

## Product

Rename Police is a macOS menu bar app that watches common user folders, detects messy file and folder names, suggests better names instantly, and lets users rename one item or many items with almost no effort.

## Problem

People dump screenshots, downloads, installers, memes, exports, and random folders into their Mac with terrible names. Finder makes cleanup annoying, and batch renaming is still more manual than it should be.

## Vision

Make naming cleanup feel fast, funny, and lightweight enough that people actually keep it running.

## Goals

- Reduce filename cleanup effort for everyday Mac users
- Make smart rename suggestions feel automatic and trustworthy
- Support both one-click rename and manual override
- Support batch rename for multiple files and folders at once
- Stay lightweight enough for a menu bar utility

## Non-goals

- Full cloud sync
- Deep AI document understanding
- Enterprise file governance
- Finder extension complexity in the first version

## Target users

- Designers drowning in screenshots and exports
- Indie hackers and developers with messy Downloads folders
- Content creators with installer files, assets, and meme folders
- General Mac users who want a cleaner Desktop and Documents setup

## Core use cases

1. User downloads a badly named file and Rename Police suggests a better name.
2. User accepts the suggested rename with one click.
3. User wants a custom name and edits it directly from the menu bar.
4. User stages multiple files and folders from anywhere and batch renames them.
5. User turns on auto rename and lets the app silently clean up common junk.

## MVP features

- Menu bar app shell
- Watch Downloads, Desktop, and Documents
- Filename scoring and category detection
- Smart rename suggestions for screenshots, installers, memes, documents, and archives
- One-click rename
- Custom rename sheet from the menu bar
- Batch picker for files and folders
- Batch rename action
- Undo last rename
- Notifications for flagged names

## UX principles

- Suggest first, never overwhelm
- Keep the menu compact and obvious
- Default actions should feel safe
- Custom rename should always be one click away
- Batch rename should feel like a real tool, not a hidden gimmick

## Functional requirements

### Detection

- Monitor Downloads, Desktop, and Documents
- Ignore hidden files, temp files, partial downloads, and app bundles
- Avoid resurfacing already-processed items

### Rename suggestions

- Generate suggestions based on category and filename patterns
- Preserve extensions where appropriate
- Avoid unnecessary `-2` suffixes when renaming the same underlying item

### Manual rename

- User can open a custom rename flow from the menu bar
- User can confirm a custom filename without leaving the app

### Batch rename

- User can select multiple files and folders from an open panel
- App stages the selection, shows a summary, and runs batch rename on command
- Clean items can be skipped automatically

### Undo

- App stores the most recent rename operation and can undo it

## Success metrics

- Percentage of flagged files renamed
- Percentage of users who use batch rename
- Ratio of accepted suggested names vs custom names
- Time to rename from detection

## Risks

- Suggestions feel too aggressive or too silly
- Menu bar UI becomes crowded
- Watching too many folders creates noise
- Users may want Finder-native interactions later

## Next phase ideas

- Finder Quick Action or context menu integration
- Rename presets like date-first, kebab-case, client-safe, and screenshot-clean
- Smarter folder naming heuristics
- Rule-based automation per folder
- Launch-ready onboarding and demo mode
