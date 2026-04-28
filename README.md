# Literki

A Flutter app that helps kids learn how to write Polish letters by tracing them
on screen. The child picks a letter from the alphabet grid, sees a large grey
letter as a guide, and draws on top of it with their finger. When they're done
they can tap **Sprawdź** ("Check") to get a 1–5 star rating with an
encouraging, kid-friendly message.

The full Polish alphabet is supported, including diacritics:
`Ą Ć Ę Ł Ń Ó Ś Ź Ż` (and their lowercase forms). Vowels are highlighted in red
on the home screen.

## Getting started

```bash
flutter pub get
flutter run
```

The custom handwriting font (`PlaywritePL-VariableFont_wght.ttf`) is bundled
under `assets/fonts/` and registered in `pubspec.yaml` as the `Handwriting`
family.

## How it works

### Drawing
The drawing screen (`lib/views/draw_screen.dart`) stacks two layers:

1. A large grey `Text` widget showing the target letter as a tracing guide.
2. A `GestureDetector` + `CustomPaint` (`lib/views/painter.dart`) that records
   pan points into a `List<Offset?>` and draws them as connected line
   segments. `null` entries mark the end of a stroke.

### Letter checking
When the user taps **Sprawdź**, `_scoreDrawing` in `draw_screen.dart` does the
following:

1. **Renders the target** off-screen with a `PictureRecorder` + `TextPainter`,
   using the same font, size, weight and letter-spacing as the on-screen grey
   letter (`_renderTarget`).
2. **Renders the drawing** off-screen by replaying the recorded stroke points
   through a `Canvas`, using a thicker stroke width (`_scoringStrokeWidth`)
   so a tracing line down the middle of a letter still covers most of its
   area (`_renderDrawing`).
3. **Compares pixel alpha** between the two images and counts:
   - `targetPixels` — pixels belonging to the letter shape
   - `drawnPixels` — pixels belonging to the (thickened) drawing
   - `intersection` — pixels active in both
4. **Computes an F1-style score** that balances two things:
   - `coverage = intersection / targetPixels` — how much of the letter was
     filled in
   - `accuracy = intersection / drawnPixels` — how much of the drawing stayed
     inside the letter
   - `f1 = 2 * coverage * accuracy / (coverage + accuracy)`
5. **Maps F1 to 1–5 stars** using generous thresholds (`>=0.65` → 5★, then
   0.50, 0.35, 0.20, otherwise 1★).
6. **Shows a positive dialog** with amber stars and a Polish message. Even the
   lowest score gets *"Spróbuj jeszcze raz!"* — the app is designed for
   positive reinforcement, never negative feedback.

If the canvas is empty when the button is pressed, the dialog says
*"Najpierw narysuj literę!"* with no stars, instead of penalizing.

## Tuning letter-checking strictness

The single most useful knob is `_scoringStrokeWidth` near the top of
`lib/views/draw_screen.dart`:

```dart
static const double _scoringStrokeWidth = 25;
```

This is the stroke width used **only when scoring** — the on-screen drawing
itself is unaffected. A wider scoring stroke means a thin tracing line covers
more of the letter, which raises `coverage` and therefore the score. So:

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

## Project layout

```
lib/
  main.dart                 # App entry, theme (uses Handwriting font)
  views/
    home_screen.dart        # Alphabet grid, vowels in red
    draw_screen.dart        # Tracing canvas + Sprawdź / scoring logic
    painter.dart            # CustomPainter that draws the user's strokes
assets/fonts/               # PlaywritePL handwriting font
```