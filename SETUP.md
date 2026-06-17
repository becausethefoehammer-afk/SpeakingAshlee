# Gen Z Translator — Setup

## Files created

- `GenZTranslatorApp.swift` — app entry point
- `ContentView.swift` — all UI
- `TranslatorViewModel.swift` — API logic
- `APIConfig.swift` — put your API key here
- `SamplePhrases.swift` — example buttons

## Xcode setup (5 minutes)

1. Open Xcode → File → New → Project → iOS → App
2. Name it `GenZTranslator`, set interface to SwiftUI, language to Swift
3. Delete the default `ContentView.swift` Xcode creates
4. Drag all 5 `.swift` files from this folder into the Xcode project navigator
5. Open `APIConfig.swift` and replace `YOUR_ANTHROPIC_API_KEY_HERE` with your key
   - Get one at: https://console.anthropic.com
6. Hit Run (Cmd+R) on simulator or device

## API key security note

The key is hardcoded for prototyping only. Before sharing the app, move it
to a lightweight backend proxy so the key isn't bundled in the binary.

## Cost

Uses `claude-haiku-4-5` — the fastest and cheapest model (~$0.001 per translation).
