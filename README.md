# Literki

A Flutter app that helps Polish-speaking kids learn how to write **letters and
digits** by tracing them on screen. Children pick an item from the alphabet
or the numbers grid, choose a difficulty level, and draw on top of a guide.
Tapping a letter on the grid plays its Polish pronunciation so kids learn
the sound at the same time as the shape. When they tap **Sprawdź**
("Check") they get a 1–5 star rating with a mascot reaction and an
encouraging Polish message.

The full Polish alphabet is supported, including diacritics:
`Ą Ć Ę Ł Ń Ó Ś Ź Ż` (and their lowercase forms). These Polish-specific
diacritic letters are highlighted in red on the home screen so kids can
spot them at a glance; all other letters are dark ink. Digits `0–9` live
in a parallel **Cyfry** (Numbers) module that uses the same drawing,
scoring, and progress flow.

## Getting started

```bash
flutter pub get
flutter run
```

The custom handwriting font (`PlaywritePL-VariableFont_wght.ttf`) is bundled
under `assets/fonts/` and registered in `pubspec.yaml` as the `Handwriting`
family. UI text uses the system default font.

### Native icon and splash

- App icon is generated from `assets/literki-icon-1024.png` via
  `flutter_launcher_icons` (Android adaptive + iOS).
- Native splash is generated from `assets/literki-splash-1080x1920.png` via
  `flutter_native_splash` (cream `#F6F1E4` background, Android-only — iOS
  splash is handled in the storyboard).

To regenerate after changing the source images:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## App flow

The app has six screens:

1. **Powitanie (Welcome)** — animated title "Lite**r**k**i**" with the *r*
   in red and *i* in blue, soft pastel circles in the corners, ten
   handwriting letters drifting gently in the background, an elastic-pop
   mascot wave, three feature chips (`Cały alfabet`, `Zbieraj gwiazdki`,
   `3 poziomy`), and a "Zaczynamy!" button. Sub-elements fade and slide
   in on a staggered intro timeline.
2. **Wybór modułu / Alfabet (Module + grid)** — the home screen's top bar
   greets with `Wybierz literę` or `Wybierz cyfrę` depending on the active
   module, and a pill switch toggles between **Trening**, **Czytanie**,
   **Litery**, and **Cyfry** (the switch scrolls horizontally on narrow
   phones). Selecting **Czytanie** swaps the letter grid for the reading
   menu (see [Reading module](#reading-module-czytanie)). The
   grid auto-sizes (4–16 columns) based on viewport width, so phones get
   tight tiles and tablets/iPad get larger ones. Each tile shows the item
   and a row of mini-stars representing the child's best score across all
   levels for that item. The total-stars badge top-right doubles as the
   parental gate — **long-press it** to open the pedagogical report.
3. **Wybór poziomu (Level select)** — once an item is picked, kids choose
   between three difficulties, each with an emoji avatar:
   - **Łatwy 🐣 (Easy, P1)** — the full grey letter/digit shows under the
     canvas; trace along it.
   - **Średni 🐰 (Medium, P2)** — a vector **tracing guide** is shown: a
     faint reference glyph overlaid with green start dots and directional
     arrows that teach the correct stroke order and direction (see
     [SVG tracing guides](#svg-tracing-guides)).
   - **Trudny 🦁 (Hard, P3)** — just a small dot in the center; write from
     memory.
   On tablets (≥ 700 px wide) the big letter preview sits beside the level
   list; on phones it stacks vertically. Each level card shows the stars
   already earned at that specific level.
4. **Pisanie (Drawing)** — the heart of the app. Lined paper background,
   level-aware guide (full glyph on level 1, an SVG stroke-order guide with
   arrows on level 2, a dot on level 3), side mascot that switches from idle to cheering as
   soon as the child starts drawing, "Pokaż" demo that sweeps a glowing
   sparkle across the letter to reveal it, "Wyczyść" to clear, "Sprawdź"
   to score, and prev/next arrows that cycle within the active module
   while preserving the chosen level. A `P1/P2/P3` pill near the title
   shows the current difficulty; on level 1 a small `① zacznij tutaj` hint
   appears in the canvas corner. The wide layout puts the mascot/hint
   bubble on the right of the canvas; the compact layout stacks them
   below.
5. **Sukces (Success dialog)** — overlay with the mascot reacting in a mood
   matching the score (think → idle → cheer → wow), elastic pop-in, a
   16-particle star burst on scores 3 and above, animated stars that
   stagger in with a back-ease wobble, a "Litera X ukończona!" caption,
   and "Jeszcze raz" / "Następna" buttons.
6. **Raport pedagogiczny (Pedagogical report)** — *parental view*, opened by
   **long-pressing** the total-stars badge on the home screen. Shows a
   summary card (total attempts, unique elements, average score) and a
   per-element breakdown sorted by average score (weakest first), each
   with attempt count, average time, and average stars. A "Wyczyść" button
   wipes the underlying CSV log after a confirmation dialog.

## Reading module (Czytanie)

Alongside writing, the **Czytanie** module teaches early reading in three
levels, reached from the home pill switch. It uses the device's own speech
engines: **text-to-speech** (`flutter_tts`, `pl-PL`) reads syllables and
words aloud, and **speech recognition** (`speech_to_text`, `pl_PL`) checks
that the child repeats them. Both live behind the `SpeechService` singleton
(`lib/state/speech_service.dart`), the reading-side counterpart to
`LetterSound`.

- **Poziom 1 — Czytam sylaby.** A 3×3 grid of open syllables (sylaby
  otwarte, e.g. `MA MO MU`) with a **Następne** button that pages through
  the full set generated in `lib/data/reading.dart`. Tapping a syllable
  opens a listen-and-repeat dialog: the child hears it, repeats into the
  mic, and a star is collected on a good-enough match.
- **Poziom 2 — Czytam wyrazy.** Six picture tiles (two rows of three), each
  an SVG drawing with its word, paging through the 12 words. Tapping a tile
  opens the same listen-and-repeat dialog, now with the picture shown.
- **Poziom 3 — Przeczytaj i wskaż.** A word is shown and read aloud; the
  child may repeat it (optional mic practice) and then taps the matching
  picture among **three**. A correct pick celebrates and collects a star; a
  wrong pick only nudges "spróbuj jeszcze raz" and lets them retry.

The 12 words — `kot, pies, las, samochód, mama, tata, dłoń, nos, oko,
ołówek, telefon, szklanka` — are simple flat **SVG** drawings under
`assets/reading_svg/` (ASCII file names, e.g. `samochod.svg`, so asset
resolution never hits the NFC/NFD pitfall the WAV files have).

**Positive reinforcement, never a gate.** Recognition matching is
deliberately lenient (diacritics stripped, substring and small-edit-distance
tolerance) because recognizers mangle short utterances and children's
speech. A miss is always met with encouragement and an unlimited retry, and
if speech recognition is unavailable the child can still mark a prompt as
read ("Umiem!") to collect the star. Stars feed the same `ProgressStore` /
total-stars economy as writing, keyed by `Module.reading`; the menu cards
show a running count of stars collected per level via
`starsForModuleLevel`.

**Permissions.** The mic flow needs `NSMicrophoneUsageDescription` +
`NSSpeechRecognitionUsageDescription` (iOS `Info.plist`) and
`RECORD_AUDIO` plus speech/TTS service `<queries>` (Android manifest) —
all already declared. `speech_to_text` requires iOS 13+ (the project is
already at 13.0).

## Letter sounds

Every letter **and** digit has a recorded pronunciation under
`assets/literki_dzwieki/` (e.g. `Ą.wav`, `Ł.wav`, `Ż.wav`, `0.wav`…`9.wav`
— uppercase WAV per letter, plain digits for numbers; lowercase taps
reuse the same file via `toUpperCase()`). Tapping a tile on the home
grid plays the corresponding WAV via
[`audioplayers`](https://pub.dev/packages/audioplayers), routed through
the `LetterSound` singleton in `lib/state/letter_sound.dart`. The same
sound also plays when the child cycles letters/digits with
**Poprzednia** / **Następna** in the drawing screen.

Beyond per-item names, a small set of **encouragement clips** also live
in the same folder and play through `LetterSound.playClip(name)`:

- `zaczynamy.wav` — fires once when the drawing screen first opens for
  a chosen letter/digit. Suppressed on prev/next navigation between
  items (controlled by `DrawScreen(playIntro: false)`).
- After **Sprawdź**, a clip plays based on the score:
  - 1★ → `sprobuj_jeszcze_raz.wav`
  - 2★, 3★ → `prawie_sie_udalo.wav`
  - 4★ → random from `swietnie.wav` / `brawo.wav` / `super.wav`
  - 5★ → `brawo_swietnie.wav`
  - 0★ (empty canvas) → silent

Calls are fire-and-forget — playback errors are swallowed so a missing
recording never blocks navigation.

Filenames must be in Unicode **NFC** (precomposed) form: `Ą` = `U+0104`,
not `A` + combining ogonek. macOS sometimes returns NFD when listing
filenames; if you add new recordings on a Mac, double-check with
`ls literki_dzwieki | xxd` (the diacritic should be a single 2-byte UTF-8
sequence) before committing, otherwise the asset bundle won't resolve them.

## SVG tracing guides

Level 2 (**Średni**) no longer traces the handwriting font outline — it shows
a hand-authored **vector tracing guide** per letter and digit, stored under
`assets/letters_svg/` and rendered with
[`flutter_svg`](https://pub.dev/packages/flutter_svg). Each SVG bundles three
layers in one file:

- a **faint reference glyph** (the letter shape at low opacity) so the child
  can see where to write,
- green **start dots** marking where each stroke begins, and
- green **directional arrows** that teach the correct stroke order and
  direction.

Files are named by case and kind: `upper_A.svg`, `lower_a.svg`,
`number_0.svg` (lowercase diacritics like `lower_ą.svg` keep their precomposed
NFC character in the filename). `DrawScreen` picks the right file from
`widget.letter` and `widget.level == 2`, then renders it with
`SvgPicture.asset(..., fit: BoxFit.contain)`.

The font's line box doesn't centre every glyph the same way, so a handful of
letters get a per-letter vertical nudge (`svgOffsetY` in
`draw_screen.dart`) — most sit at `-80`, while ascenders/descenders and
accented capitals have their own values. If you add or re-export a guide and
it sits too high or low, adjust its entry there rather than editing the SVG.

> **Note:** scoring still compares the drawing against the **handwriting
> font** glyph, not the SVG. `lib/widgets/letter_svg.dart` (a hand-rolled
> `SvgPathParser` + `LetterAssets` loader) is wired into `_renderTarget` and
> `_SvgLetterPainter` but currently inert — `LetterAssets.load` looks for
> bare `A.svg` / `a.svg` names that don't match the `upper_`/`lower_`/`number_`
> files, so it always falls back to the font path. The visible level-2 guide
> comes entirely from `flutter_svg`. See `AGENTS.md` before relying on it.

## Progress and logging

Two layers of state run side-by-side:

- **`ProgressStore`** (`lib/state/progress_store.dart`) — in-memory star
  tracking, keyed by `(module, item, level)`. Used by the home grid and
  level cards to render stars. Resets when the app is killed.
- **`DataLogger`** (`lib/services/data_logger.dart`) — persistent CSV log
  of every **Sprawdź** attempt, written to
  `<applicationDocumentsDirectory>/literki_raport.csv`. Each row records
  `timestamp,module,item,level,attempt,duration_sec,score`. The Raport
  screen reads back this file and aggregates per-element stats. The log
  survives across launches; clearing it from Raport deletes the file.

Per-letter stars do not yet persist between launches — that's
intentional for now, but the CSV log gives parents/teachers durable
session history without bloating the in-app star economy.

## How letter checking works

When the user taps **Sprawdź**, `_scoreDrawing` in `lib/views/draw_screen.dart`:

1. **Renders the target** off-screen with `PictureRecorder` + `TextPainter`,
   using the same font, size, weight and letter-spacing as the on-screen
   guide letter (`_renderTarget`).
2. **Renders the drawing** off-screen by replaying the recorded stroke
   points with a thicker stroke (`_scoringStrokeWidth`), so a tracing line
   down the middle of a letter still covers most of its area
   (`_renderDrawing`).
3. **Compares pixel alpha** between the two images and counts:
   - `targetPixels` — pixels belonging to the letter shape
   - `drawnPixels` — pixels belonging to the (thickened) drawing
   - `intersection` — pixels active in both
4. **Computes an F1-style score** balancing two things:
   - `coverage = intersection / targetPixels` — how much of the letter was
     filled in
   - `accuracy = intersection / drawnPixels` — how much of the drawing
     stayed inside the letter
   - `f1 = 2 * coverage * accuracy / (coverage + accuracy)`
5. **Maps F1 to 1–5 stars** with generous thresholds (`>=0.65` → 5★, then
   0.50, 0.35, 0.20, otherwise 1★).
6. **Logs the attempt** (module, item, level, attempt #, duration, score)
   to the CSV via `DataLogger.logAttempt`, regardless of score.
7. **Shows the success dialog** with stars, a Polish message, mascot
   reaction, and (for 3★+) a star burst. Even the lowest score gets
   *"Spróbuj jeszcze raz!"* — the app is built around positive reinforcement,
   never negative feedback.

If the canvas is empty when the button is pressed, the dialog says
*"Najpierw narysuj literę!"* with no stars and no progress is recorded
(a 0-score row is still appended to the log so the duration counts toward
time-on-task).

## Tuning letter-checking strictness

The single most useful knob is `_scoringStrokeWidth` near the top of
`lib/views/draw_screen.dart`:

```dart
static const double _scoringStrokeWidth = 25;
```

This is the stroke width used **only when scoring** — the on-screen drawing
itself is unaffected. A wider scoring stroke means a thin tracing line
covers more of the letter, which raises `coverage` and therefore the score:

| Value (px) | Effect                                                    |
|------------|-----------------------------------------------------------|
| ~15        | Strict — child must trace closely down the spine          |
| ~25        | Default — forgiving, suits younger kids                   |
| ~40–50     | Very forgiving — almost any line through the letter wins  |

Tune it to the age group: smaller numbers for older children who can trace
precisely, larger numbers for preschoolers still developing motor control.

If you also want to adjust the cutoffs themselves (e.g. make 5★ easier to
earn), edit the F1 thresholds in `_scoreDrawing`:

```dart
if (f1 >= 0.65) return 5;
if (f1 >= 0.50) return 4;
if (f1 >= 0.35) return 3;
if (f1 >= 0.20) return 2;
return 1;
```

Lower numbers = easier to earn that many stars.

## Theme

The app uses the **Zeszyt** ("notebook") palette: warm cream paper
background, ink-blue primary accent, terracotta and sage secondary
accents, brick-red diacritics, sage green for success, gold stars, and
notebook-blue ruled lines on the drawing canvas. All colours live as
constants on `AppColors` in `lib/theme.dart`, alongside a shared
`cardShadow` token used by every elevated surface — change them there
to re-skin the app.

## Project layout

```
lib/
  main.dart                        # App entry, theme, routes to WelcomeScreen
  theme.dart                       # Zeszyt palette + cardShadow tokens
  data/
    alphabet.dart                  # polishAlphabet list + polishDiacritics set
    numbers.dart                   # digits 0..9
    module.dart                    # Module enum (letters | numbers) + labels
  state/
    progress_store.dart            # In-memory stars per (module, item, level)
    letter_sound.dart              # AudioPlayer singleton for letter pronunciations
  services/
    data_logger.dart               # CSV attempt log in app documents dir
  widgets/
    big_button.dart                # 3D pressed-down button (sm/md/lg)
    letter_svg.dart                # SVG path parser + LetterAssets loader (prototype scoring path)
    mascot.dart                    # "Lulu" mascot with mood + bob/blink/wave
    paper_background.dart          # Lined / dotted paper textures
    star.dart                      # StarIcon + StarRow
  views/
    welcome_screen.dart            # 1. Powitanie (animated intro)
    home_screen.dart               # 2. Module switch + alphabet/numbers grid
    level_select_screen.dart       # 3. Wybór poziomu (emoji level cards)
    draw_screen.dart               # 4. Pisanie (canvas + scoring + logging)
    success_dialog.dart            # 5. Sukces (overlay + star burst)
    report_screen.dart             # 6. Raport pedagogiczny (long-press gated)
    painter.dart                   # CustomPainter for live user strokes
assets/
  fonts/                           # PlaywritePL handwriting font
  letters_svg/                     # Per-glyph level-2 tracing guides (upper_A.svg, lower_a.svg, number_0.svg)
  literki_dzwieki/                 # Per-letter Polish pronunciation WAVs (A.wav, Ą.wav, …)
  literki-icon-1024.png            # Source for flutter_launcher_icons
  literki-splash-1080x1920.png     # Source for flutter_native_splash
```
