# AGENTS.md

Operating manual for AI agents working in this repository. Read this once
before making changes — it captures conventions and pitfalls that aren't
obvious from the code alone. The full feature/architecture overview lives
in `README.md`; this file is the agent-facing complement.

## What this app is

Literki is a Flutter app for Polish-speaking preschool kids. They trace
**letters** (full Polish alphabet, including diacritics) or **digits** on
a canvas, get a 1–5 star score from a pixel-overlap algorithm, and a
cartoon mascot reacts. A hidden parental "Raport" view aggregates raw
attempt data from a CSV log.

Target audience implications you should keep front of mind:

- **Polish-only UI.** Never introduce English-language strings into user-
  facing widgets. All copy is Polish, often using inflected forms
  (`literę` accusative, `litery` genitive) — the `Module` enum exposes
  these via `singularLabel`, `accusativeSingular`, `genitiveSingular`;
  use them rather than hardcoding.
- **Positive reinforcement only.** Even a 1-star score gets an
  encouraging Polish message. Do not introduce "fail" / negative copy.
- **Tablet + phone.** Layouts gate on `c.maxWidth >= 700`. When you add
  a screen, check both branches.

## Tech stack

- Flutter 3.x, Dart SDK `^3.11.3`.
- No state-management package — `ChangeNotifier` + a hand-rolled
  singleton (`ProgressStore.instance`) accessed via `ListenableBuilder`.
- Persistence is just a CSV file via `path_provider`. No database, no
  shared_preferences.
- Drawings render with `CustomPainter`; scoring renders off-screen via
  `PictureRecorder` + `TextPainter` and compares raw RGBA bytes.
- Mascot, stars, paper background, and the splash sparkle are all
  drawn programmatically with `CustomPainter`. The only vector assets are
  the **level-2 tracing guides** under `assets/letters_svg/`, rendered with
  `flutter_svg` (the launcher icon and native splash remain PNGs).

Key dependencies (`pubspec.yaml`):
- `path_provider` — runtime, used by `DataLogger` for the CSV path.
- `audioplayers` — runtime, used by `LetterSound` to play per-letter
  Polish pronunciations from `assets/literki_dzwieki/`.
- `flutter_svg` — runtime, renders the per-glyph level-2 tracing guides
  in `assets/letters_svg/` and the reading-module word pictures in
  `assets/reading_svg/` via `SvgPicture.asset`.
- `flutter_tts` — runtime, Polish text-to-speech (`pl-PL`) for the reading
  module, wrapped by `SpeechService`.
- `speech_to_text` — runtime, Polish speech recognition (`pl_PL`) for the
  reading module's listen-and-repeat checks, wrapped by `SpeechService`.
  Needs mic/speech permissions (iOS `Info.plist`, Android manifest) and
  iOS 13+.
- `flutter_launcher_icons`, `flutter_native_splash` — dev-time codegen.

## Build, run, test

```bash
flutter pub get        # after touching pubspec.yaml
flutter run            # default device
flutter test           # widget tests under test/
flutter analyze        # uses analysis_options.yaml + flutter_lints
```

After editing `assets/literki-icon-1024.png` or
`assets/literki-splash-1080x1920.png`:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Heads up: `test/widget_test.dart` is the unmodified Flutter counter
template — it currently tests an app that no longer exists. If you touch
tests, replace this rather than extending it.

## Code map

```
lib/
  main.dart                    # MaterialApp + WelcomeScreen as home
  theme.dart                   # AppColors palette + cardShadow tokens
  data/
    alphabet.dart              # polishAlphabet list, polishDiacritics set
    numbers.dart               # digits 0..9
    reading.dart               # readingSyllables (generated) + readingWords (12 ReadingWord)
    module.dart                # Module enum (training | reading | letters | numbers) + Polish labels
  state/
    progress_store.dart        # Singleton in-memory stars, keyed by (module,item,level)
    letter_sound.dart          # Singleton AudioPlayer wrapper for letter pronunciations
    speech_service.dart        # Singleton flutter_tts + speech_to_text wrapper (reading module)
  services/
    data_logger.dart           # CSV append/read/clear at app docs dir
  widgets/
    big_button.dart            # 3D press-down button, sm/md/lg
    letter_svg.dart            # Hand-rolled SVG path parser + LetterAssets loader (inert scoring path — see below)
    mascot.dart                # MascotMood enum + custom-painted mascot
    paper_background.dart      # Lined / dotted paper textures
    star.dart                  # StarIcon, StarRow
    reading_widgets.dart       # Shared reading UI: ReadingTopBar, MicButton, ReadingCelebration
  views/
    welcome_screen.dart        # 1. Powitanie
    home_screen.dart           # 2. Module switch + grid (long-press stars → Raport)
    level_select_screen.dart   # 3. Wybór poziomu
    draw_screen.dart           # 4. Pisanie (canvas + scoring + DataLogger.logAttempt)
    success_dialog.dart        # 5. Sukces overlay
    report_screen.dart         # 6. Raport pedagogiczny (parental, gated by long-press)
    painter.dart               # DrawingPainter for live user strokes
    reading_menu.dart          # Reading module home (3 level cards), shown inside home_screen
    reading_syllables_screen.dart  # Reading P1 — syllable grid (9 + Następne)
    reading_words_screen.dart      # Reading P2 — 6 word pictures (2×3) + Następne
    reading_match_screen.dart      # Reading P3 — read & point to one of 3 pictures
    repeat_practice_dialog.dart    # Listen-and-repeat dialog used by reading P1 & P2
test/
  widget_test.dart             # ⚠ stale Flutter counter template, not real coverage
```

## Conventions to preserve

### Modules, not just letters
Anything user-facing that mentions a "letter" must also work for a digit.
The `Module` enum on `lib/data/module.dart` exposes the right Polish noun
form for each context (`titleLabel`, `singularLabel`, `accusativeSingular`,
`genitiveSingular`). When you add a screen or copy:

```dart
Text('Wybierz ${module.accusativeSingular}'); // "Wybierz literę" / "Wybierz cyfrę"
```

Diacritic colouring (`AppColors.diacritic`) only applies to letters —
guard with `module == Module.letters && polishDiacritics.contains(item)`.

### Stars/progress
Always go through `ProgressStore.instance` and pass `module:` explicitly
when the item could be a digit. `record()` only ever raises the score for
a `(module, item, level)` triple — it never lowers it. Don't bypass that
contract.

### CSV log invariants
- Schema is fixed:
  `timestamp,module,item,level,attempt,duration_sec,score`. Adding a
  column will break parsing of older rows (`tryParse` checks
  `parts.length != 7`). If you must extend it, version the file or write
  a migration.
- Items are written verbatim, including commas? Currently items are
  single characters so this is safe. If you ever store multi-char items
  (e.g. syllables), switch to a proper CSV escape.
- Treat the file as best-effort: `DataLogger` swallows errors and just
  `debugPrint`s. Don't surface those failures to kids.

### Letter sounds
- Use `LetterSound.instance.play(letter)` for letters/digits or
  `LetterSound.instance.playClip(filename)` for fixed clips like
  `zaczynamy.wav` (singleton, fire-and-forget) — don't instantiate
  `AudioPlayer` ad-hoc. The singleton stops any in-flight playback so
  rapid taps cut off cleanly.
- Recordings live in `assets/literki_dzwieki/` — uppercase letter WAVs
  (`A.wav`…`Ż.wav`) plus digit WAVs (`0.wav`…`9.wav`). Lowercase taps
  reuse the uppercase file via `toUpperCase()`; digits pass through
  unchanged.
- Filenames must be Unicode **NFC** (e.g. `Ą` = `U+0104`, single
  codepoint). macOS may hand back NFD when listing dirs — verify with
  `ls assets/literki_dzwieki | xxd` after adding files, otherwise the
  asset bundle won't resolve them at runtime.
- Playback errors are silently swallowed — sound is a nice-to-have, not
  a blocker. Don't wire it into navigation flow control.
- Both modules play: `home_screen._LetterTile.onTap` and
  `draw_screen._goToLetter` call `LetterSound` unconditionally for
  letters and digits. If a recording goes missing, the call silently
  no-ops rather than crashing.
- Encouragement clips also live in `assets/literki_dzwieki/`:
  `zaczynamy.wav` (intro), `sprobuj_jeszcze_raz.wav`,
  `prawie_sie_udalo.wav`, `swietnie.wav`, `brawo.wav`, `super.wav`,
  `brawo_swietnie.wav`. The intro fires from `DrawScreen.initState`
  only when `widget.playIntro == true`; `_goToLetter` flips that to
  `false` so prev/next navigation doesn't replay it. Score-keyed
  feedback clips fire from `_check` via `_feedbackClipFor(score)` —
  keep that mapping in sync if you add a new score band or clip.

### SVG tracing guides (level 2)
Level 2 (`Średni`) draws a hand-authored vector guide per glyph instead of
the handwriting font. The files live in `assets/letters_svg/` and bundle a
faint reference glyph, green start dots, and green directional arrows that
teach stroke order — `flutter_svg`'s `SvgPicture.asset` renders them as-is.

- Naming is positional: `upper_A.svg`, `lower_a.svg`, `number_0.svg`.
  Lowercase diacritics keep their precomposed **NFC** char in the filename
  (`lower_ą.svg`). `DrawScreen` builds the name from `widget.letter` +
  case + the `^[0-9]$` digit check; keep that mapping intact if you add
  glyphs.
- Vertical placement is corrected per-letter via the `svgOffsetY` ladder in
  `draw_screen.dart` (`Transform.translate`). Most glyphs sit at `-80`;
  ascenders/descenders and accented capitals have their own values. If a new
  guide sits too high/low, add it to that ladder rather than re-exporting the
  SVG.
- Both `assets/letters_svg/` and `flutter_svg` are already declared in
  `pubspec.yaml` (the asset is listed twice — harmless, but don't add a
  third). After adding files, re-run `flutter pub get` if the bundle
  doesn't pick them up.

### Reading module (Czytanie)
A separate `Module.reading` whose home is `ReadingMenu` (three level cards),
rendered inside `home_screen`'s grid the same way training gets
`_TrainingGrid` — it does **not** use the per-item grid → level-select →
draw flow. The `Module` inflected-noun getters return placeholder values for
reading; `home_screen._TopBar` special-cases the title to `Czytanie` rather
than emitting `Wybierz czytanie`.

- **Speech goes through `SpeechService.instance`** (`speak`, `startListening`,
  `matches`), never raw `FlutterTts`/`SpeechToText`. Like `LetterSound` it
  swallows errors — TTS/recognition is a teaching aid, never a hard gate.
- **Matching is intentionally lenient** (`SpeechService.matches`: strip
  diacritics, substring + small edit-distance tolerance). Don't tighten it to
  "fix" false positives — children's short utterances recognise poorly and a
  false *negative* is the worse failure for a 5–7 year-old. Every flow keeps an
  unlimited retry and an "Umiem!" escape hatch when recognition is unavailable.
- **Stars are collectible, not 1–5 ratings.** Reading records `score: 1` per
  syllable/word/match via `ProgressStore.record(..., module: Module.reading)`;
  `record` only ever raises, so an item can't be farmed. Menu cards show a
  running per-level total via `ProgressStore.starsForModuleLevel`.
- **Word pictures** live in `assets/reading_svg/` with **ASCII** file names
  (`samochod.svg`, `dlon.svg`, `olowek.svg`) deliberately — unlike the WAV
  sounds, this sidesteps the NFC/NFD asset-resolution trap. The display label
  and TTS text keep their diacritics (`ReadingWord.text`).
- **Level-1 syllables are generated** in `reading.dart` (consonants × vowels,
  open syllables only). If you extend the inventory, keep them phonotactically
  real — digraphs and "j" don't take "…i".
- **Permissions** are already declared (iOS `NSMicrophoneUsageDescription` +
  `NSSpeechRecognitionUsageDescription`; Android `RECORD_AUDIO` + speech/TTS
  `<queries>`). `speech_to_text` needs iOS 13+ — the project is at 13.0.

### Layout gating
`c.maxWidth >= 700` is the agreed phone/tablet breakpoint. If you add a
new screen, mirror the wide/compact pattern from `level_select_screen`
or `draw_screen` rather than inventing a new threshold.

### Polish copy
- Use existing inflected forms from `Module` instead of hardcoding.
- Diacritics in source files are fine — the editor and Dart handle UTF-8
  cleanly. Don't escape them.
- Never replace Polish copy with English "TODO" placeholders, even
  temporarily.

### Visual tokens
- All elevated surfaces use the shared `cardShadow` from `theme.dart`
  (a hard offset shadow + a soft blur). Don't invent ad-hoc shadows.
- Border radii cluster around 14/16/18/20/22/24/28; reuse the local
  scale rather than introducing new values.
- The handwriting font (`fontFamily: 'Handwriting'`) is reserved for the
  letter/digit itself and the title — never for body UI.

### Animations
Most screens hand-roll staggered intros with `AnimationController` +
`Curves.easeOut` over a 0..1 timeline (see `welcome_screen._slideUp`,
`level_select_screen._LevelCard`, `home_screen._LetterTile`). Keep
that idiom rather than reaching for `flutter_animate` or similar.

## Hidden / non-obvious behaviour

- **Parental Raport gate.** The `Raport` screen has no visible entry
  point — it's reached by **long-pressing** the total-stars badge in the
  home top bar. This is by design (kids shouldn't open it). Don't expose
  it via a regular button without checking with the maintainer.
- **Empty-canvas Sprawdź.** Tapping `Sprawdź` with no strokes yields a
  score of `0`, *no* `ProgressStore.record` call (since `score > 0` gates
  it), but a 0-score row still gets appended to the CSV — that's
  intentional so time-on-task counts even when the child fumbles.
- **`_scoringStrokeWidth = 25`.** The pixel-overlap scorer thickens the
  drawing for matching only. The on-canvas stroke (12 px) is unchanged.
  Tune the scorer there, not in `DrawingPainter`.
- **`letter_svg.dart` is wired but inert.** `LetterAssets` /
  `SvgPathParser` / `paintLetterStrokes` / `_SvgLetterPainter` form a
  prototype that would let scoring (`_renderTarget`) compare against the SVG
  strokes. It never fires: `LetterAssets.load(widget.letter)` looks up bare
  `A.svg` / `a.svg` names that don't exist (the real files are
  `upper_`/`lower_`/`number_` prefixed), so `_letterSvg` stays `null` and the
  scorer always falls back to the **handwriting font** glyph — even on level 2
  where the child is tracing an SVG. The on-screen level-2 guide comes from
  `flutter_svg`, a completely separate path. If you want SVG-based scoring,
  fix the filename resolution in `LetterAssets.load` first; don't assume the
  parser is live today.
- **`pubspec.yaml` `name:` is `untitled`.** This leaks into
  `import 'package:untitled/...'` (see `test/widget_test.dart`). Renaming
  the package is a sweeping change — don't do it as a side quest.
- **iOS splash is opt-out** in `pubspec.yaml` (`flutter_native_splash:
  ios: false`). iOS uses the storyboard. Don't flip it without
  regenerating the iOS splash assets.

## What to leave alone unless asked

- **The mascot painter.** `lib/widgets/mascot.dart` is a single hand-
  tuned `CustomPainter` with magic offsets. Cosmetic tweaks tend to
  cascade — change one ellipse and ears stop lining up. Only edit if the
  user asks for a mascot change.
- **The F1 thresholds.** `0.65 / 0.50 / 0.35 / 0.20` are dialed in for
  the current `_scoringStrokeWidth`. Changing them changes the felt
  difficulty for every child currently using the app — flag, don't fix.
- **Star palette.** `starGold` / `starGoldEdge` are referenced both by
  the static row and by the pop-in burst — recolour them together.

## Doing tasks well here

- Prefer editing existing widgets over inventing new ones — there's
  already a `_RoundButton`, `_PillButton`, `BigButton`, `StarRow`,
  `Mascot` for most needs. They're often duplicated as private classes
  per screen on purpose (different paddings/shadows); don't unify them
  into a shared widget unless explicitly asked.
- When you add a screen that should appear in the kids' flow, route to
  it via `Navigator.push` from the relevant view; don't add it to a
  global `routes:` map (the app doesn't use one).
- Do the wide/compact layout work as you go — adding a screen that
  only looks right on phones is a regression on iPad.
- Running `flutter analyze` before declaring a change done catches the
  most common issues (unused imports, missing `const`, `withOpacity`
  deprecation — note that this codebase already migrated to
  `.withValues(alpha: ...)`).

## When in doubt

Read the section of `README.md` corresponding to the screen you're
touching — the user-facing flow doc and this agent-facing doc are kept
in sync deliberately. If you change behaviour visible to a child or a
parent, update both.
