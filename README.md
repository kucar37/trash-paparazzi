# Trash Paparazzi

Fontys ICT Semester 4 Mobile Apps individual project: festival sustainability
without reducing convenience. **Current implementation: Phase 1 — UI and navigation.**

## Run

```sh
flutter pub get
flutter run
```

The app opens with **You Got Spotted**. **Watch My Moment** opens **Your Moment**;
**Claim Reward** on either screen opens **Festival Perks**. Android Back and the
on-screen arrows return to the previous screen. The selected edit style remains
selected when returning from rewards.

## What works in Phase 1

- Three screens based on the supplied Figma references, with a shared dark theme,
  green/cyan accents, bundled typography, rounded cards and glow effects.
- Responsive media sizing, safe areas and scrolling for smaller windows or large text.
- Cinematic, Hype and Funny selection with a visible border/glow and accessibility
  selection state. Hype is the initial selection.
- A **consent preview** before public display. Confirming changes the preview state;
  cancelling, tapping outside or pressing Back does not. No media is transmitted.
  Choosing another style resets the preview confirmation.
- Copying the demonstration reward code to the device clipboard, with feedback.
- Playback/audio controls and Save Reward open explanatory dialogs, so their
  Phase 1 behavior is explicit.

## Preview boundaries

Detection and eco-credits are demonstration content. The moment is a still-image
preview, not a playing or AI-generated video. Changing style updates the selection
only. The reward uses a decorative QR icon labeled **not scannable**, with the
identifier `TP-DEMO-8849-X`; it cannot be redeemed. Save Reward explains that local
saving will come in Phase 2 and does not claim anything was saved.

Video playback, generated demo QR data and persistent local reward saving belong
to Phase 2. Generative AI APIs and two meaningful sensors belong to Phase 3.
There are no API keys, API calls, sensor permissions, uploads, redemption services
or external transmission in this implementation.

## Provide these assets

1. **Original festival photograph:** put a licensed portrait image showing a
   cup return or other positive action at `assets/images/festival_photo.jpg`.
   Both cards use this file automatically, cropped with `BoxFit.cover`.
   Run `flutter pub get` and restart after adding it. An illustrated, labeled
   placeholder keeps the app usable if the file is absent or unreadable.
2. **Portrait video for Phase 2:** provide a local MP4, ideally approximately
   15 seconds long. Video asset registration and a player will be added then.

The attached Figma screenshots were used as design references, not extracted
as individual photography or video assets. Exact photo composition will depend
on the original image supplied.

## Code map

- `lib/main.dart`: app entry point, theme and system-bar appearance.
- `lib/theme/app_theme.dart`: palette, text styles and Material theme.
- `lib/screens/spotted_screen.dart`: branding, detected-action preview and routes.
- `lib/screens/moment_screen.dart`: edit selection and submission consent preview.
- `lib/screens/reward_screen.dart`: reward introduction and save-preview feedback.
- `lib/widgets/festival_page.dart`: safe-area/scroll shell and back header.
- `lib/widgets/action_button.dart`: shared primary and secondary actions.
- `lib/widgets/festival_media.dart`: optional photo, labels and illustrated fallback.
- `lib/widgets/preview_dialog.dart`: shared explanatory dialog.
- `lib/widgets/reward_ticket.dart`: reward details, decorative QR and code copy.
- `test/widget_test.dart`: interaction, consent, startup and layout regression tests.

State is deliberately small: `MomentScreen` owns its selected style and consent
preview using `StatefulWidget`/`setState`. Navigation uses `Navigator` with
`MaterialPageRoute`. Later AI and sensor services can supply real action data
and captions without changing the navigation or reusable UI components.

## Dependencies and fonts

No Flutter packages were added. The project keeps its existing Flutter,
`cupertino_icons`, `flutter_test` and `flutter_lints` dependencies.
Syne, Outfit and Space Mono are bundled locally under `assets/fonts/`, so the UI
requires no network font loading. Each font's SIL Open Font License is included
beside it. Source: the Google Fonts repository (`google/fonts` on GitHub).

## Verification — 14 October 2026

Executed on the real project checkout:

- `flutter pub get`: completed.
- `flutter analyze`: no issues found.
- `flutter test`: 11 tests passed. Covers routing, selection retention, consent
  confirm/cancel/Back/outside dismissal, clipboard code, missing-video feedback,
  save feedback, initially empty Android viewport, and layouts at 235×640, 320×640,
  998×448 and 448×998 with 150% text.
- `flutter build apk --debug`: succeeded. APK: `build/app/outputs/flutter-apk/app-debug.apk`.

The available emulator is **Pixel_10_Pro**, Android 16/API 36, 1280×2856 at 480 dpi
(approximately 427×952 logical pixels). It is not the requested Pixel 10 Pro XL.
The app was installed and exercised on that device. The larger 448×998 logical
viewport was checked in widget tests; exact XL emulator verification remains.
The emulator walkthrough checked Watch My Moment, Funny selection, explicit
submission confirmation, Claim Reward, scrolling to Save Reward and its honest
Phase 1 dialog. Screen captures are in `docs/screenshots/`. The moment/reward
pages may scroll on shorter devices to preserve the large media and ticket layouts.

The Gradle build emitted a Java native-access warning from its existing tooling;
it did not prevent the debug build. User testing and further refinement remain
for later phases.
