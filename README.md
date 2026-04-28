# Literki

A Flutter app that helps Polish-speaking kids learn how to write letters by
tracing them on screen. Children pick a letter from the alphabet grid, choose
a difficulty level, and draw on top of a guide. When they tap **Sprawdź**
("Check") they get a 1–5 star rating with a mascot reaction and an
encouraging Polish message.

The full Polish alphabet is supported, including diacritics:
`Ą Ć Ę Ł Ń Ó Ś Ź Ż` (and their lowercase forms). These Polish-specific
diacritic letters are highlighted in red on the home screen so kids can
spot them at a glance; all other letters are dark ink.

## Getting started

```bash
flutter pub get
flutter run
```

The custom handwriting font (`PlaywritePL-VariableFont_wght.ttf`) is bundled
under `assets/fonts/` and registered in `pubspec.yaml` as the `Handwriting`
family. UI text uses the system default font.

## App flow

The app has five screens, navigated in this order:

1. **Powitanie (Welcome)** — animated title with the *r* in red and *i* in
   blue, the mascot waving, three feature chips, and a "Zaczynamy!" button.
   Floating background letters drift gently behind the content.
2. **Alfabet (Alphabet)** — full Polish alphabet laid out as 16 paired
   columns (uppercase row over lowercase row). Each tile shows the letter
   and a row of mini-stars representing the child's best score for that
   letter across all levels. The top bar shows total stars earned.
3. **Wybór poziomu (Level select)** — once a letter is picked, kids choose
   between three difficulties:
   - **Łatwy (Easy, L1)** — the full grey letter shows under the canvas;
     trace along it.
   - **Średni (Medium, L2)** — only the letter outline is shown; trace
     inside the lines.
   - **Trudny (Hard, L3)** — just a small dot in the center; write the
     letter from memory.
4. **Pisanie (Drawing)** — the heart of the app. Lined paper background,
   level-aware guide, side mascot that switches from idle to cheering as
   soon as the child starts drawing, "Pokaż" demo that sweeps a sparkle
   across the letter to reveal it, "Wyczyść" to clear, "Sprawdź" to score,
   and prev/next arrows that keep the chosen level.
5. **Sukces (Success dialog)** — overlay with the mascot reacting in a mood
   matching the score (think → idle → cheer → wow), a star burst on scores
   3 and above, and "Jeszcze raz" / "Następna" buttons.

Stars are tracked per letter per level by an in-memory `ProgressStore`
(`lib/state/progress_store.dart`) and survive within a single app session.
Persistence across launches is not yet wired up.

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
6. **Shows the success dialog** with stars, a Polish message, mascot
   reaction, and (for 3★+) a star burst. Even the lowest score gets
   *"Spróbuj jeszcze raz!"* — the app is built around positive reinforcement,
   never negative feedback.

If the canvas is empty when the button is pressed, the dialog says
*"Najpierw narysuj literę!"* with no stars instead of penalising.

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
background, ink-blue primary accent, brick-red diacritics, sage green for
success, and notebook-blue ruled lines on the drawing canvas. All colours
live as constants on `AppColors` in `lib/theme.dart` — change them there to
re-skin the app.

The original design bundle defined three themes (Pastel, Wesoły, Zeszyt);
only Zeszyt is shipped. To switch, copy the values from the design bundle's
`theme.jsx` into `AppColors`.

## Project layout

```
lib/
  main.dart                        # App entry, theme, routes to WelcomeScreen
  theme.dart                       # Zeszyt palette + card-shadow tokens
  data/
    alphabet.dart                  # POLISH_ALPHABET list + DIACRITICS set
  state/
    progress_store.dart            # In-memory star tracking (ChangeNotifier)
  widgets/
    big_button.dart                # 3D pressed-down button
    mascot.dart                    # "Lulu" mascot with mood + bob/blink
    paper_background.dart          # Lined / dotted paper textures
    star.dart                      # StarIcon + StarRow
  views/
    welcome_screen.dart            # 1. Powitanie
    home_screen.dart               # 2. Alfabet (alphabet picker)
    level_select_screen.dart       # 3. Wybór poziomu
    draw_screen.dart               # 4. Pisanie (tracing canvas + scoring)
    success_dialog.dart            # 5. Sukces (overlay)
    painter.dart                   # CustomPainter for live user strokes
assets/fonts/                      # PlaywritePL handwriting font
```
