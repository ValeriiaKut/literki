# Literki

A Flutter app that helps Polish-speaking kids learn how to write **letters and
digits** by tracing them on screen. Children pick an item from the alphabet
or the numbers grid, choose a difficulty level, and draw on top of a guide.
When they tap **Sprawdź** ("Check") they get a 1–5 star rating with a mascot
reaction and an encouraging Polish message.

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
   module, and a pill switch toggles between **Litery** and **Cyfry**. The
   grid auto-sizes (4–16 columns) based on viewport width, so phones get
   tight tiles and tablets/iPad get larger ones. Each tile shows the item
   and a row of mini-stars representing the child's best score across all
   levels for that item. The total-stars badge top-right doubles as the
   parental gate — **long-press it** to open the pedagogical report.
3. **Wybór poziomu (Level select)** — once an item is picked, kids choose
   between three difficulties, each with an emoji avatar:
   - **Łatwy 🐣 (Easy, P1)** — the full grey letter/digit shows under the
     canvas; trace along it.
   - **Średni 🐰 (Medium, P2)** — only the outline is shown; trace inside
     the lines.
   - **Trudny 🦁 (Hard, P3)** — just a small dot in the center; write from
     memory.
   On tablets (≥ 700 px wide) the big letter preview sits beside the level
   list; on phones it stacks vertically. Each level card shows the stars
   already earned at that specific level.
4. **Pisanie (Drawing)** — the heart of the app. Lined paper background,
   level-aware guide, side mascot that switches from idle to cheering as
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
  services/
    data_logger.dart               # CSV attempt log in app documents dir
  widgets/
    big_button.dart                # 3D pressed-down button (sm/md/lg)
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
  literki-icon-1024.png            # Source for flutter_launcher_icons
  literki-splash-1080x1920.png     # Source for flutter_native_splash
```
