# Speaking Ashlee — App Store Submission Guide

## App Store Connect setup

1. Go to https://appstoreconnect.apple.com → My Apps → "+" → New App
2. Platform: iOS | Name: **Speaking Ashlee** | Bundle ID: `com.benjaminmolyneux.speakingashlee`
3. SKU: `speaking-ashlee-1` (any unique string)

---

## Metadata to paste in

### Name
Speaking Ashlee

### Subtitle (30 chars max)
Translate anything to Gen Z

### Description
Ever get a text from someone under 30 and have absolutely no idea what they're on about?

Speaking Ashlee is a real-time Gen Z translator. Type any normal sentence and get back an authentic Gen Z version — the kind of language people in their mid-to-late 20s actually use, not a stale list of slang from 2019.

Whether you're a parent trying to vibe with your kids, a manager writing a Slack message that doesn't sound like a press release, or just someone who has no idea what "it's giving" means — Speaking Ashlee has you covered.

Powered by AI that understands context, tone, and the ever-evolving vocabulary of a generation that texts at the speed of thought.

Features:
• Instant AI translation with authentic Gen Z phrasing
• Tap-to-try example phrases to get started
• One-tap copy to paste translations anywhere
• Clean dark UI — easy on the eyes

No cap.

### Keywords (100 chars max — comma separated)
gen z,slang,translator,language,text,youth,millennial,dictionary,converter,speak

### Category
Primary: Utilities
Secondary: Education

### Age Rating
4+ (no objectionable content)

### Privacy Policy URL
You need a URL — quickest option: paste the policy below into a free site like
https://www.privacypolicygenerator.info or https://app.termsofservice.co and host it.

**Privacy Policy boilerplate:**

Speaking Ashlee does not collect, store, or share any personal data.
Text you type is sent to our translation server solely to generate a response
and is not logged, stored, or used for any other purpose.
The app does not use analytics, advertising SDKs, or third-party tracking.

---

## Screenshots required

You need screenshots for **6.9" (iPhone 16 Pro Max)** and optionally **6.5"**.
Minimum: 3 screenshots, maximum: 10.

Suggested shots:
1. Home screen with empty state (just the header + example chips visible)
2. Home screen with input filled in ("I'm very tired and don't want to go out tonight")
3. Home screen showing translated output
4. Example: funny/relatable input → output
5. Copy confirmation state (optional)

How to capture: run on a real device or simulator → Screenshots in Xcode → Device → Take Screenshot

Size: 1290 × 2796 px for 6.9"

---

## GitHub Actions secrets to add

Go to your repo → Settings → Secrets and variables → Actions → New repository secret

| Secret name | Where to get it |
|---|---|
| `DISTRIBUTION_CERTIFICATE_BASE64` | `base64 -i Certificates.p12` (export from Keychain Access) |
| `DISTRIBUTION_CERTIFICATE_PASSWORD` | Password you set when exporting |
| `PROVISION_PROFILE_BASE64` | `base64 -i YourProfile.mobileprovision` (download from developer.apple.com) |
| `PROVISION_PROFILE_NAME` | The profile name shown in Xcode Signing settings |
| `KEYCHAIN_PASSWORD` | Any strong random string |
| `APPLE_TEAM_ID` | 10-char string from developer.apple.com/account |
| `ASC_KEY_ID` | App Store Connect → Users → Keys → Key ID |
| `ASC_ISSUER_ID` | Same page, Issuer ID at top |
| `ASC_PRIVATE_KEY_BASE64` | `base64 -i AuthKey_XXXX.p8` (download once from ASC) |

---

## Deploy the proxy to Render (free tier)

1. Push this repo to GitHub (including the `proxy/` folder)
2. Go to https://render.com → New → Web Service → connect repo
3. Root directory: `proxy`
4. Build command: `npm install`
5. Start command: `node server.js`
6. Add environment variable: `ANTHROPIC_API_KEY` = your key
7. Deploy → copy the URL (e.g. `https://speaking-ashlee-proxy.onrender.com`)
8. Paste that URL into `SpeakingAshlee/APIConfig.swift` in the `#else` branch

The `proxy/render.yaml` already encodes all of this — Render will auto-detect it
if you use "Blueprint" deployment.

---

## iPhone to iPhone (no App Store)

Use **AirDrop via TestFlight** or **direct install via Xcode**:

### Via Xcode (fastest for 1 device)
1. Plug in the other iPhone
2. Xcode → Window → Devices and Simulators → + Add device
3. Product → Run (Cmd+R) selecting that device

### Via TestFlight (share link to any iOS user)
1. Archive in Xcode: Product → Archive → Distribute → TestFlight
2. In App Store Connect → TestFlight → add tester emails
3. They get an email → install TestFlight → install app
4. You can share the public TestFlight link to anyone without Apple review
