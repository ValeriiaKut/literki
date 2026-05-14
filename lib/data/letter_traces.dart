import 'package:flutter/material.dart';

import '../models/letter_trace.dart';

const Map<String, LetterTrace> letterTraces = {
  'A': LetterTrace(
    letter: 'A',
    strokes: [
      // Lewa część litery A — od dołu do góry
      [
        Offset(0.32, 0.79),
        Offset(0.36, 0.79),
        Offset(0.38, 0.77),
        Offset(0.40, 0.73),
        Offset(0.42, 0.67),
        Offset(0.43, 0.61),
        Offset(0.44, 0.56),
        Offset(0.45, 0.51),
        Offset(0.46, 0.46),
        Offset(0.47, 0.40),
        Offset(0.48, 0.34),
        Offset(0.49, 0.28),
        Offset(0.50, 0.23),
        Offset(0.51, 0.19),
      ],

      // Prawa część litery A — z góry w dół
      [
        Offset(0.51, 0.19),
        Offset(0.52, 0.24),
        Offset(0.53, 0.30),
        Offset(0.54, 0.36),
        Offset(0.55, 0.43),
        Offset(0.56, 0.50),
        Offset(0.57, 0.58),
        Offset(0.58, 0.64),
        Offset(0.59, 0.69),
        Offset(0.60, 0.73),
        Offset(0.61, 0.76),
        Offset(0.62, 0.79),
        Offset(0.64, 0.81),
        Offset(0.66, 0.80),
      ],

      // Ogonek po prawej stronie (lekko w górę)
      [
        Offset(0.66, 0.80),
        Offset(0.67, 0.76),
        Offset(0.68, 0.72),
        Offset(0.69, 0.68),
        Offset(0.69, 0.65),
      ],

      // Poprzeczka litery A
      [
        Offset(0.44, 0.58),
        Offset(0.47, 0.58),
        Offset(0.50, 0.58),
        Offset(0.53, 0.58),
        Offset(0.57, 0.58),
      ],
    ],

    arrows: [
      // lewa linia do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 2,
        toIndex: 8,
      ),

      // prawa linia w dół
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 2,
        toIndex: 9,
      ),

      // poprzeczka w prawo
      TraceArrow(
        strokeIndex: 3,
        fromIndex: 0,
        toIndex: 4,
      ),
    ],
  ),

  'a': LetterTrace(
    letter: 'a',
    strokes: [
      // Okrągła część litery „a”
      [
        Offset(0.55, 0.52),
        Offset(0.53, 0.50),
        Offset(0.50, 0.50),
        Offset(0.47, 0.50),
        Offset(0.45, 0.52),
        Offset(0.44, 0.55),
        Offset(0.43, 0.59),
        Offset(0.43, 0.64),
        Offset(0.43, 0.69),
        Offset(0.44, 0.73),
        Offset(0.46, 0.77),
        Offset(0.50, 0.78),
        Offset(0.53, 0.75),
        Offset(0.55, 0.69),
        Offset(0.55, 0.62),
        Offset(0.56, 0.55),
        Offset(0.56, 0.48),
      ],

      // Pionowa kreska po prawej stronie
      [
        Offset(0.56, 0.48),
        Offset(0.56, 0.53),
        Offset(0.56, 0.58),
        Offset(0.56, 0.63),
        Offset(0.55, 0.68),
        Offset(0.55, 0.72),
        Offset(0.56, 0.76),
        Offset(0.58, 0.79),
        Offset(0.60, 0.77),
      ],
    ],

    arrows: [
      // верхня частина кола
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 4,
      ),

      // нижня частина кола
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 7,
        toIndex: 10,
      ),

      // права палочка вниз
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 1,
        toIndex: 6,
      ),
    ],
  ),
  'Ą': LetterTrace(
    letter: 'Ą',
    strokes: [
      [
        Offset(0.32, 0.79),
        Offset(0.36, 0.79),
        Offset(0.38, 0.77),
        Offset(0.40, 0.73),
        Offset(0.42, 0.67),
        Offset(0.43, 0.61),
        Offset(0.44, 0.56),
        Offset(0.45, 0.51),
        Offset(0.46, 0.46),
        Offset(0.47, 0.40),
        Offset(0.48, 0.34),
        Offset(0.49, 0.28),
        Offset(0.50, 0.23),
        Offset(0.51, 0.19),
      ],
      [
        Offset(0.51, 0.19),
        Offset(0.52, 0.24),
        Offset(0.53, 0.30),
        Offset(0.54, 0.36),
        Offset(0.55, 0.43),
        Offset(0.56, 0.50),
        Offset(0.57, 0.58),
        Offset(0.58, 0.64),
        Offset(0.59, 0.69),
        Offset(0.60, 0.73),
        Offset(0.61, 0.76),
        Offset(0.62, 0.79),
        Offset(0.64, 0.81),
        Offset(0.66, 0.80),
      ],
      [
        Offset(0.66, 0.80),
        Offset(0.67, 0.76),
        Offset(0.68, 0.72),
        Offset(0.69, 0.68),
        Offset(0.69, 0.65),
      ],
      [
        Offset(0.44, 0.58),
        Offset(0.47, 0.58),
        Offset(0.50, 0.58),
        Offset(0.53, 0.58),
        Offset(0.57, 0.58),
      ],
      [
        Offset(0.65, 0.82),
        Offset(0.64, 0.86),
        Offset(0.62, 0.91),
        Offset(0.63, 0.96),
        Offset(0.66, 0.96),
        Offset(0.67, 0.94),
      ],
    ],
    arrows: [
      // lewa linia do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 2,
        toIndex: 8,
      ),

      // prawa linia w dół
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 2,
        toIndex: 9,
      ),

      // poprzeczka w prawo
      TraceArrow(
        strokeIndex: 3,
        fromIndex: 0,
        toIndex: 4,
      ),

      TraceArrow(
        strokeIndex: 4,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),

  'ą': LetterTrace(
    letter: 'ą',

    strokes: [
      // Okrągła część litery „ą”
      [
        Offset(0.55, 0.52),
        Offset(0.53, 0.50),
        Offset(0.50, 0.50),
        Offset(0.47, 0.50),
        Offset(0.45, 0.52),
        Offset(0.44, 0.55),
        Offset(0.43, 0.59),
        Offset(0.43, 0.64),
        Offset(0.43, 0.69),
        Offset(0.44, 0.73),
        Offset(0.46, 0.77),
        Offset(0.50, 0.78),
        Offset(0.53, 0.75),
        Offset(0.55, 0.69),
        Offset(0.55, 0.62),
        Offset(0.56, 0.55),
        Offset(0.56, 0.48),
      ],

      // Prawa pionowa kreska
      [
        Offset(0.56, 0.48),
        Offset(0.56, 0.53),
        Offset(0.56, 0.58),
        Offset(0.56, 0.63),
        Offset(0.55, 0.68),
        Offset(0.55, 0.72),
        Offset(0.56, 0.76),
        Offset(0.58, 0.79),
        Offset(0.60, 0.77),
      ],

      // Ogonek litery „ą”
      [
        Offset(0.55, 0.51),
        Offset(0.55, 0.56),
        Offset(0.55, 0.60),
        Offset(0.55, 0.66),
        Offset(0.56, 0.71),
        Offset(0.56, 0.76),
        Offset(0.57, 0.80),
        Offset(0.59, 0.79),
        Offset(0.57, 0.84),
        Offset(0.56, 0.89),
        Offset(0.56, 0.94),
        Offset(0.57, 0.96),
        Offset(0.60, 0.96),
      ],
    ],

    arrows: [
      // верхня частина кола
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 4,
      ),

      // нижня частина кола
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 7,
        toIndex: 10,
      ),

      // права палочка вниз
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 1,
        toIndex: 6,
      ),
    ],
  ),
  'B': LetterTrace(
    letter: 'B',

    strokes: [
      // Lewa pionowa część litery B — z góry w dół
      [
        Offset(0.44, 0.28),
        Offset(0.44, 0.35),
        Offset(0.44, 0.40),
        Offset(0.44, 0.45),
        Offset(0.44, 0.50),
        Offset(0.44, 0.55),
        Offset(0.44, 0.60),
        Offset(0.44, 0.70),
        Offset(0.43, 0.76),
        Offset(0.41, 0.80),
        Offset(0.39, 0.80),
        Offset(0.37, 0.79),
        Offset(0.35, 0.76),
      ],

      // Górny brzuszek litery B
      [
        Offset(0.36, 0.27),
        Offset(0.38, 0.22),
        Offset(0.42, 0.19),
        Offset(0.47, 0.17),
        Offset(0.52, 0.16),
        Offset(0.56, 0.18),
        Offset(0.59, 0.21),
        Offset(0.61, 0.25),
        Offset(0.62, 0.30),
        Offset(0.62, 0.36),
        Offset(0.60, 0.40),
        Offset(0.56, 0.43),
        Offset(0.54, 0.45),
        Offset(0.51, 0.46),
      ],

      // Dolny brzuszek litery B
      [
        Offset(0.51, 0.46),
        Offset(0.56, 0.47),
        Offset(0.59, 0.48),
        Offset(0.61, 0.52),
        Offset(0.62, 0.58),
        Offset(0.62, 0.64),
        Offset(0.62, 0.70),
        Offset(0.60, 0.74),
        Offset(0.57, 0.77),
        Offset(0.54, 0.79),
        Offset(0.51, 0.79),
        Offset(0.49, 0.78),
      ],
    ],

    arrows: [
      // Strzałka pionowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 7,
      ),

      // Strzałka górnego brzuszka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 4,
      ),

      // Strzałka dolnego brzuszka
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'b': LetterTrace(
    letter: 'b',

    strokes: [
      // Pionowa część — z góry w dół
      [
        Offset(0.45, 0.17),
        Offset(0.45, 0.23),
        Offset(0.45, 0.29),
        Offset(0.45, 0.35),
        Offset(0.45, 0.41),
        Offset(0.45, 0.47),
        Offset(0.45, 0.53),
        Offset(0.45, 0.59),
        Offset(0.45, 0.65),
        Offset(0.45, 0.71),
        Offset(0.46, 0.76),
        Offset(0.49, 0.80),
      ],

      // Brzuszek litery b
      [
        Offset(0.49, 0.80),
        Offset(0.53, 0.78),
        Offset(0.55, 0.74),
        Offset(0.56, 0.69),
        Offset(0.57, 0.64),
        Offset(0.57, 0.59),
        Offset(0.56, 0.54),
        Offset(0.54, 0.50),
        Offset(0.51, 0.48),
        Offset(0.48, 0.49),
        Offset(0.46, 0.52),
      ],
    ],

    arrows: [
      // Strzałka pionowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 8,
      ),

      // Strzałka brzuszka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'C': LetterTrace(
    letter: 'C',

    strokes: [
      [
        Offset(0.62, 0.23),
        Offset(0.58, 0.19),
        Offset(0.53, 0.16),
        Offset(0.48, 0.18),
        Offset(0.44, 0.23),
        Offset(0.42, 0.28),
        Offset(0.41, 0.34),
        Offset(0.40, 0.41),
        Offset(0.40, 0.48),
        Offset(0.40, 0.55),
        Offset(0.41, 0.62),
        Offset(0.43, 0.69),
        Offset(0.46, 0.77),
        Offset(0.50, 0.80),
        Offset(0.55, 0.79),
        Offset(0.59, 0.77),
        Offset(0.62, 0.73),
        Offset(0.63, 0.70),
      ],
    ],

    arrows: [
      // Strzałka górnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // Strzałka środkowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 7,
        toIndex: 10,
      ),

      // Strzałka dolnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 13,
        toIndex: 16,
      ),
    ],
  ),
  'c': LetterTrace(
    letter: 'c',

    strokes: [
      [
        Offset(0.57, 0.53),
        Offset(0.54, 0.50),
        Offset(0.50, 0.49),
        Offset(0.47, 0.51),
        Offset(0.45, 0.55),
        Offset(0.45, 0.60),
        Offset(0.44, 0.65),
        Offset(0.45, 0.70),
        Offset(0.46, 0.75),
        Offset(0.48, 0.79),
        Offset(0.52, 0.80),
        Offset(0.55, 0.77),
        Offset(0.57, 0.74),
      ],
    ],

    arrows: [
      // Strzałka górnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // Strzałka dolnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 6,
        toIndex: 9,
      ),
    ],
  ),

  'Ć': LetterTrace(
    letter: 'Ć',

    strokes: [
      // Główna litera C
      [
        Offset(0.62, 0.23),
        Offset(0.58, 0.19),
        Offset(0.53, 0.18),
        Offset(0.48, 0.19),
        Offset(0.44, 0.23),
        Offset(0.42, 0.28),
        Offset(0.41, 0.34),
        Offset(0.40, 0.41),
        Offset(0.40, 0.48),
        Offset(0.40, 0.55),
        Offset(0.41, 0.62),
        Offset(0.43, 0.68),
        Offset(0.46, 0.74),
        Offset(0.50, 0.78),
        Offset(0.55, 0.79),
        Offset(0.59, 0.77),
        Offset(0.62, 0.73),
        Offset(0.63, 0.70),
      ],

      // Akcent (kreska)
      [
        Offset(0.55, 0.02),
        Offset(0.53, 0.05),
        Offset(0.51, 0.08),
      ],
    ],

    arrows: [
      // Strzałka górnej części C
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // Strzałka dolnej części C
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 12,
      ),

      // Strzałka akcentu
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'ć': LetterTrace(
    letter: 'ć',

    strokes: [
      // mała litera c
      [
        Offset(0.57, 0.53),
        Offset(0.54, 0.50),
        Offset(0.50, 0.49),
        Offset(0.47, 0.51),
        Offset(0.45, 0.55),
        Offset(0.44, 0.60),
        Offset(0.44, 0.65),
        Offset(0.45, 0.70),
        Offset(0.46, 0.75),
        Offset(0.48, 0.79),
        Offset(0.52, 0.80),
        Offset(0.55, 0.77),
        Offset(0.57, 0.74),
      ],

      // akcent nad literą
      [
        Offset(0.54, 0.27),
        Offset(0.52, 0.31),
        Offset(0.51, 0.34),
        Offset(0.50, 0.38),
      ],
    ],

    arrows: [
      // Strzałka górnej części c
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // Strzałka dolnej części c
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 6,
        toIndex: 9,
      ),

      // Strzałka akcentu
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'D': LetterTrace(
    letter: 'D',

    strokes: [
      // Lewa pionowa część
      [
        Offset(0.42, 0.27),
        Offset(0.42, 0.34),
        Offset(0.42, 0.41),
        Offset(0.42, 0.48),
        Offset(0.42, 0.55),
        Offset(0.42, 0.62),
        Offset(0.42, 0.69),
        Offset(0.40, 0.76),
        Offset(0.38, 0.81),
        Offset(0.35, 0.78),
        Offset(0.34, 0.73),
        Offset(0.37, 0.70),
        Offset(0.41, 0.73),
        Offset(0.44, 0.77),
        Offset(0.48, 0.79),
      ],

      // Prawa zaokrąglona część
      [
        Offset(0.48, 0.79),
        Offset(0.54, 0.79),
        Offset(0.59, 0.75),
        Offset(0.62, 0.70),
        Offset(0.64, 0.63),
        Offset(0.65, 0.56),
        Offset(0.65, 0.49),
        Offset(0.65, 0.42),
        Offset(0.64, 0.35),
        Offset(0.62, 0.29),
        Offset(0.58, 0.24),
        Offset(0.53, 0.20),
        Offset(0.47, 0.18),
        Offset(0.41, 0.18),
        Offset(0.37, 0.22),
        Offset(0.35, 0.27),
        Offset(0.34, 0.30),
      ],
    ],

    arrows: [
      // Strzałka pionowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 6,
      ),

      // Strzałka dolnego łuku
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),

      // Strzałka górnego łuku
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 8,
        toIndex: 11,
      ),
    ],
  ),
  'd': LetterTrace(
    letter: 'd',

    strokes: [
      [
        Offset(0.55, 0.16),
        Offset(0.55, 0.21),
        Offset(0.55, 0.26),
        Offset(0.55, 0.31),
        Offset(0.55, 0.36),
        Offset(0.55, 0.41),

        Offset(0.55, 0.46),
        Offset(0.55, 0.51),
        Offset(0.55, 0.56),
        Offset(0.55, 0.61),
        Offset(0.55, 0.66),
        Offset(0.55, 0.71),

        Offset(0.54, 0.75),
        Offset(0.52, 0.78),
        Offset(0.49, 0.79),
        Offset(0.46, 0.78),
        Offset(0.44, 0.75),
        Offset(0.43, 0.71),

        Offset(0.43, 0.66),
        Offset(0.43, 0.61),
        Offset(0.44, 0.56),
        Offset(0.46, 0.53),
        Offset(0.49, 0.51),
        Offset(0.52, 0.50),

        Offset(0.55, 0.52),
        Offset(0.55, 0.57),
        Offset(0.55, 0.62),
        Offset(0.55, 0.67),
        Offset(0.55, 0.72),
        Offset(0.55, 0.75),

        Offset(0.56, 0.78),
        Offset(0.57, 0.81),
        Offset(0.59, 0.80),
      ],
    ],

    arrows: [
      // Strzałka pionowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 11,
      ),

      // Strzałka okrągłej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 12,
        toIndex: 14,

      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 16,
        toIndex: 19,

      ),
      // Strzałka końcówki
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 30,
        toIndex: 32,
      ),
    ],
  ),
  'E': LetterTrace(
    letter: 'E',

    strokes: [
      [
        Offset(0.60, 0.23),
        Offset(0.57, 0.18),
        Offset(0.52, 0.17),
        Offset(0.47, 0.18),
        Offset(0.44, 0.22),
        Offset(0.42, 0.28),

        Offset(0.42, 0.34),
        Offset(0.44, 0.40),
        Offset(0.47, 0.44),
        Offset(0.52, 0.47),
        Offset(0.56, 0.46),
        Offset(0.52, 0.47),

        Offset(0.49, 0.47),
        Offset(0.45, 0.50),
        Offset(0.43, 0.56),
        Offset(0.42, 0.62),
        Offset(0.42, 0.68),
        Offset(0.44, 0.74),

        Offset(0.47, 0.79),
        Offset(0.52, 0.80),
        Offset(0.56, 0.79),
        Offset(0.58, 0.76),
        Offset(0.60, 0.73),
      ],
    ],

    arrows: [
      // Strzałka górnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // Strzałka środkowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 13,
      ),

      // Strzałka dolnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 18,
        toIndex: 22,
      ),
    ],
  ),
  'e': LetterTrace(
    letter: 'e',

    strokes: [
      [
        Offset(0.40, 0.81),
        Offset(0.44, 0.79),
        Offset(0.48, 0.76),
        Offset(0.51, 0.72),
        Offset(0.53, 0.66),
        Offset(0.54, 0.60),

        Offset(0.54, 0.54),
        Offset(0.52, 0.50),
        Offset(0.48, 0.49),
        Offset(0.45, 0.54),
        Offset(0.45, 0.60),
        Offset(0.46, 0.66),

        Offset(0.47, 0.72),
        Offset(0.49, 0.76),
        Offset(0.52, 0.79),
        Offset(0.56, 0.78),
        Offset(0.58, 0.75),
      ],
    ],

    arrows: [
      // Strzałka pierwszej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 4,
      ),

      // Strzałka środkowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 9,
        toIndex: 13,
      ),

      // Strzałka końcówki
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 16,
      ),
    ],
  ),
  'Ę': LetterTrace(
    letter: 'Ę',

    strokes: [
      [
        Offset(0.60, 0.23),
        Offset(0.57, 0.18),
        Offset(0.52, 0.17),
        Offset(0.47, 0.18),
        Offset(0.44, 0.22),
        Offset(0.42, 0.28),

        Offset(0.42, 0.34),
        Offset(0.44, 0.40),
        Offset(0.47, 0.47),
        Offset(0.52, 0.47),
        Offset(0.56, 0.46),
        Offset(0.52, 0.47),

        Offset(0.48, 0.47),
        Offset(0.45, 0.50),
        Offset(0.43, 0.56),
        Offset(0.42, 0.62),
        Offset(0.42, 0.68),
        Offset(0.44, 0.74),

        Offset(0.47, 0.79),
        Offset(0.52, 0.80),
        Offset(0.56, 0.79),
        Offset(0.59, 0.75),
        Offset(0.60, 0.73),
      ],

      // Ogonek
      [
        Offset(0.54, 0.83),
        Offset(0.53, 0.86),
        Offset(0.51, 0.89),
        Offset(0.51, 0.93),
        Offset(0.52, 0.96),
        Offset(0.55, 0.97),

        Offset(0.56, 0.96),
      ],
    ],

    arrows: [
      // Strzałka górnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 4,
      ),

      // Strzałka środkowo-dolnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 10,
        toIndex: 13,
      ),

      // Strzałka ogonka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'ę': LetterTrace(
    letter: 'ę',

    strokes: [
      [
        Offset(0.40, 0.81),
        Offset(0.44, 0.79),
        Offset(0.48, 0.76),
        Offset(0.51, 0.72),
        Offset(0.53, 0.66),
        Offset(0.54, 0.60),

        Offset(0.54, 0.54),
        Offset(0.52, 0.50),
        Offset(0.48, 0.49),
        Offset(0.45, 0.54),
        Offset(0.45, 0.60),
        Offset(0.46, 0.66),

        Offset(0.47, 0.72),
        Offset(0.49, 0.76),
        Offset(0.52, 0.79),
        Offset(0.56, 0.78),
        Offset(0.58, 0.75),
      ],

      // Ogonek
      [
        Offset(0.54, 0.81),

        Offset(0.52, 0.87),
        Offset(0.51, 0.90),
        Offset(0.51, 0.93),
        Offset(0.52, 0.95),

        Offset(0.54, 0.96),
        Offset(0.57, 0.95),
      ],
    ],

    arrows: [
      // Strzałka pierwszej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 4,
      ),

      // Strzałka środkowo-dolnej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 10,
        toIndex: 13,
      ),

      // Strzałka ogonka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'F': LetterTrace(
    letter: 'F',

    strokes: [
      [
        Offset(0.38, 0.26),
        Offset(0.40, 0.22),
        Offset(0.44, 0.19),
        Offset(0.50, 0.18),
        Offset(0.54, 0.18),
        Offset(0.59, 0.18),

        Offset(0.62, 0.18),
      ],

      [
        Offset(0.48, 0.18),
        Offset(0.48, 0.25),
        Offset(0.48, 0.31),
        Offset(0.48, 0.37),
        Offset(0.48, 0.43),
        Offset(0.48, 0.49),

        Offset(0.48, 0.55),
        Offset(0.48, 0.61),
        Offset(0.48, 0.67),
        Offset(0.48, 0.73),
        Offset(0.46, 0.78),
        Offset(0.42, 0.80),

        Offset(0.38, 0.76),
      ],

      [
        Offset(0.48, 0.48),
        Offset(0.52, 0.48),
        Offset(0.56, 0.48),
        Offset(0.60, 0.48),
      ],
    ],

    arrows: [
      // Strzałka górnej kreski
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 2,
        toIndex: 5,
      ),

      // Strzałka pionowej części
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 1,
        toIndex: 9,
      ),

      // Strzałka środkowej kreski
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'f': LetterTrace( // strzałki
    letter: 'f',

    strokes: [
      [
        Offset(0.40, 0.80),
        Offset(0.44, 0.75),
        Offset(0.47, 0.70),
        Offset(0.49, 0.65),
        Offset(0.51, 0.59),
        Offset(0.52, 0.53),

        Offset(0.53, 0.47),
        Offset(0.53, 0.41),
        Offset(0.54, 0.35),
        Offset(0.54, 0.29),
        Offset(0.54, 0.23),
        Offset(0.53, 0.18),

        Offset(0.50, 0.17),
        Offset(0.48, 0.20),
        Offset(0.48, 0.26),
        Offset(0.48, 0.32),
        Offset(0.48, 0.38),
        Offset(0.48, 0.44),

        Offset(0.48, 0.50),
        Offset(0.48, 0.56),
        Offset(0.48, 0.62),
        Offset(0.48, 0.68),
        Offset(0.48, 0.74),
        Offset(0.47, 0.80),

        Offset(0.48, 0.86),
        Offset(0.48, 0.92),
        Offset(0.48, 0.98),
        Offset(0.48, 1.02),
      ],

      [
        Offset(0.48, 0.79),
        Offset(0.51, 0.78),
        Offset(0.53, 0.76),
        Offset(0.55, 0.73),
        Offset(0.56, 0.69),
      ],
    ],

    arrows: [
      // Strzałka górnego łuku
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // Strzałka pionowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 13,
        toIndex: 26,
      ),

      // Strzałka małej kreski
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 4,
      ),
    ],
  ),
  //'G': LetterTrace( ) /Poprawic leterke (do gory)---------------------------------
  //'g': LetterTrace( ) /Poprawic leterke (do gory)-------------------------
  'H': LetterTrace(
    letter: 'H', // dodane strzałki

    strokes: [
      [
        Offset(0.33, 0.25),
        Offset(0.35, 0.20),
        Offset(0.39, 0.18),
        Offset(0.42, 0.23),
        Offset(0.42, 0.29),
        Offset(0.42, 0.35),

        Offset(0.42, 0.41),
        Offset(0.42, 0.47),
        Offset(0.42, 0.53),
        Offset(0.42, 0.59),
        Offset(0.42, 0.65),
        Offset(0.42, 0.71),

        Offset(0.42, 0.77),
        Offset(0.40, 0.81),
        Offset(0.37, 0.80),
        Offset(0.35, 0.75),
        Offset(0.35, 0.69),
        Offset(0.37, 0.63),

        Offset(0.42, 0.57),
        Offset(0.47, 0.53),
        Offset(0.52, 0.48),
        Offset(0.57, 0.43),
        Offset(0.62, 0.36),
        Offset(0.65, 0.30),

        Offset(0.65, 0.24),
        Offset(0.64, 0.18),
        Offset(0.61, 0.16),
        Offset(0.59, 0.21),
        Offset(0.58, 0.27),
        Offset(0.58, 0.33),

        Offset(0.58, 0.39),
        Offset(0.58, 0.45),
        Offset(0.58, 0.51),
        Offset(0.58, 0.57),
        Offset(0.58, 0.63),
        Offset(0.58, 0.69),

        Offset(0.59, 0.75),
        Offset(0.61, 0.81),
        Offset(0.64, 0.79),
        Offset(0.67, 0.74),
      ],
    ],

    arrows: [
      // Strzałka lewej pionowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 12,
      ),

      // Strzałka środkowego przejścia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 17,
        toIndex: 22,
      ),

      // Strzałka prawej pionowej części
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 28,
        toIndex: 35,
      ),
    ],
  ),
  'h': LetterTrace( // poprawione strzałki
    letter: 'h',

    strokes: [
      [
        Offset(0.44, 0.16),
        Offset(0.44, 0.22),
        Offset(0.44, 0.28),
        Offset(0.44, 0.34),
        Offset(0.44, 0.40),
        Offset(0.44, 0.46),

        Offset(0.44, 0.52),
        Offset(0.44, 0.58),
        Offset(0.44, 0.64),
        Offset(0.44, 0.70),
        Offset(0.44, 0.76),
        Offset(0.44, 0.82),
      ],

      [
        Offset(0.44, 0.57),
        Offset(0.47, 0.53),
        Offset(0.50, 0.50),
        Offset(0.53, 0.49),
        Offset(0.55, 0.53),
        Offset(0.56, 0.59),

        Offset(0.56, 0.65),
        Offset(0.56, 0.71),
        Offset(0.56, 0.77),
        Offset(0.57, 0.80),
        Offset(0.60, 0.78),
      ],
    ],

    arrows: [
      // pionowa kreska w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 11,
      ),

      // przejście do łuku
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),

      // prawa pionowa część
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 5,
        toIndex: 8,
      ),
    ],
  ),
  'I': LetterTrace(
    letter: 'I',

    strokes: [
      [
        Offset(0.43, 0.25),
        Offset(0.45, 0.21),
        Offset(0.48, 0.19),
        Offset(0.51, 0.21),
        Offset(0.54, 0.21),
        Offset(0.55, 0.17),
      ],

      [
        Offset(0.55, 0.17),
        Offset(0.55, 0.23),
        Offset(0.55, 0.29),
        Offset(0.55, 0.35),
        Offset(0.55, 0.41),
        Offset(0.55, 0.47),

        Offset(0.55, 0.53),
        Offset(0.55, 0.59),
        Offset(0.55, 0.65),
        Offset(0.55, 0.70),
        Offset(0.54, 0.75),
        Offset(0.52, 0.78),

        Offset(0.49, 0.79),
        Offset(0.46, 0.78),
        Offset(0.43, 0.75),
      ],
    ],

    arrows: [
      // górny początek
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 5,
      ),

      // pionowa kreska w dół
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 1,
        toIndex: 9,
      ),

      // dolne zaokrąglenie
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 11,
        toIndex: 14,
      ),
    ],
  ),
  'i': LetterTrace(
    letter: 'i',

    strokes: [
      [
        Offset(0.49, 0.49),
        Offset(0.49, 0.55),
        Offset(0.49, 0.61),
        Offset(0.49, 0.67),
        Offset(0.49, 0.73),
        Offset(0.49, 0.78),

        Offset(0.50, 0.81),
        Offset(0.52, 0.81),
        Offset(0.54, 0.79),
      ],

      [
        Offset(0.49, 0.32),
      ],
    ],

    arrows: [
      // pionowa kreska w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 5,
      ),

      // dolne zakończenie
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 6,
        toIndex: 8,
      ),
    ],
  ),
  ///'J', 'j' do zrobienia

  'K': LetterTrace(
    letter: 'K',

    strokes: [
      [
        Offset(0.32, 0.26),
        Offset(0.33, 0.21),
        Offset(0.36, 0.18),
        Offset(0.39, 0.20),
        Offset(0.42, 0.20),
        Offset(0.44, 0.17),

        Offset(0.44, 0.23),
        Offset(0.44, 0.29),
        Offset(0.44, 0.35),
        Offset(0.44, 0.41),
        Offset(0.44, 0.47),
        Offset(0.44, 0.53),

        Offset(0.44, 0.59),
        Offset(0.44, 0.65),
        Offset(0.44, 0.71),
        Offset(0.44, 0.76),
        Offset(0.44, 0.80),
      ],

      [
        Offset(0.45, 0.48),
        Offset(0.49, 0.46),
        Offset(0.52, 0.44),
        Offset(0.55, 0.37),
        Offset(0.57, 0.29),
        Offset(0.59, 0.23),
        Offset(0.61, 0.18),

        Offset(0.64, 0.16),
        Offset(0.66, 0.18),
      ],

      [
        Offset(0.45, 0.48),
        Offset(0.50, 0.48),
        Offset(0.53, 0.50),
        Offset(0.56, 0.56),
        Offset(0.58, 0.65),
        Offset(0.60, 0.73),
        Offset(0.62, 0.79),

        Offset(0.65, 0.80),
        Offset(0.68, 0.78),
      ],
    ],

    arrows: [
      // pionowa kreska w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 15,
      ),

      // górne ramię
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),

      // dolne ramię
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'k': LetterTrace(
    letter: 'k',

    strokes: [
      // pionowa kreska
      [
        Offset(0.45, 0.16),
        Offset(0.45, 0.23),
        Offset(0.45, 0.29),
        Offset(0.45, 0.35),
        Offset(0.45, 0.41),
        Offset(0.45, 0.47),
        Offset(0.45, 0.53),
        Offset(0.45, 0.59),
        Offset(0.45, 0.65),
        Offset(0.45, 0.71),
        Offset(0.45, 0.76),
        Offset(0.45, 0.80),
      ],

      // górna przekątna
      [
        Offset(0.49, 0.60),

        Offset(0.51, 0.58),
        Offset(0.52, 0.56),
        Offset(0.53, 0.54),

        Offset(0.55, 0.52),
        Offset(0.56, 0.51),
      ],

      // dolna przekątna
      [
        Offset(0.48, 0.66),
        Offset(0.48, 0.65),
        Offset(0.49, 0.66),
        Offset(0.50, 0.68),
        Offset(0.51, 0.70),
        Offset(0.52, 0.73),
        Offset(0.53, 0.75),
        Offset(0.55, 0.78),
        Offset(0.57, 0.80),
        Offset(0.59, 0.77),
      ],
    ],

    arrows: [
      // pionowa kreska w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 9,
      ),

      // górna część
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 5,
      ),

      // dolna część
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 2,
        toIndex: 7,
      ),
    ],
  ),
  'L': LetterTrace(
    letter: 'L',

    strokes: [
      [
        Offset(0.59, 0.26),
        Offset(0.56, 0.19),
        Offset(0.52, 0.17),
        Offset(0.47, 0.19),
        Offset(0.45, 0.26),
        Offset(0.45, 0.35),
        Offset(0.45, 0.41),
        Offset(0.45, 0.50),
        Offset(0.45, 0.57),
        Offset(0.45, 0.66),
        Offset(0.44, 0.73),
        Offset(0.41, 0.80),
        Offset(0.37, 0.78),
        Offset(0.38, 0.72),
        Offset(0.41, 0.70),
        Offset(0.48, 0.77),
        Offset(0.52, 0.79),
        Offset(0.56, 0.79),
        Offset(0.58, 0.77),
        Offset(0.61, 0.74),
        Offset(0.63, 0.69),
      ],
    ],

    arrows: [
      // górny łuk
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // pionowa część w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 4,
        toIndex: 10,
      ),

      // dolne wyjście w prawo
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 16,
      ),
    ],
  ),
  'l': LetterTrace(
    letter: 'l',

    strokes: [
      [
        Offset(0.50, 0.16),
        Offset(0.50, 0.23),
        Offset(0.50, 0.30),
        Offset(0.50, 0.38),
        Offset(0.50, 0.46),
        Offset(0.50, 0.55),
        Offset(0.50, 0.64),
        Offset(0.50, 0.71),
        Offset(0.50, 0.78),
        Offset(0.52, 0.80),
        Offset(0.54, 0.78),
      ],
    ],

    arrows: [
      // pionowa kreska w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 8,
      ),

      // dolne zakończenie
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 10,
      ),
    ],
  ),
  'Ł': LetterTrace(
    letter: 'Ł',

    strokes: [
      [
        Offset(0.58, 0.26),
        Offset(0.57, 0.20),
        Offset(0.53, 0.16),
        Offset(0.48, 0.17),
        Offset(0.45, 0.24),
        Offset(0.45, 0.31),
        Offset(0.45, 0.39),
        Offset(0.45, 0.46),
        Offset(0.45, 0.55),
        Offset(0.45, 0.63),
        Offset(0.44, 0.71),
        Offset(0.43, 0.78),
        Offset(0.39, 0.80),
        Offset(0.37, 0.76),
        Offset(0.39, 0.70),
        Offset(0.47, 0.76),
        Offset(0.52, 0.79),
        Offset(0.56, 0.79),
        Offset(0.60, 0.77),
        Offset(0.63, 0.68),
      ],

      [
        Offset(0.40, 0.51),
        Offset(0.43, 0.49),
        Offset(0.48, 0.45),
        Offset(0.51, 0.41),
      ],
    ],

    arrows: [
      // główna pionowa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 4,
        toIndex: 9,
      ),

      // dolne wyjście w prawo
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 16,
      ),

      // przekreślenie Ł
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'ł': LetterTrace(
    letter: 'ł',

    strokes: [
      [
        Offset(0.50, 0.16),
        Offset(0.50, 0.23),
        Offset(0.50, 0.30),
        Offset(0.50, 0.38),
        Offset(0.50, 0.46),
        Offset(0.50, 0.55),
        Offset(0.50, 0.64),
        Offset(0.50, 0.71),
        Offset(0.50, 0.78),
        Offset(0.52, 0.80),
        Offset(0.54, 0.78),
      ],

      [
        Offset(0.46, 0.38),
        Offset(0.48, 0.36),
        Offset(0.50, 0.34),
        Offset(0.52, 0.32),
        Offset(0.54, 0.30),
      ],
    ],

    arrows: [
      // pionowa kreska w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 8,
      ),

      // dolne zakończenie
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 10,
      ),

      // przekreślenie ł
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 4,
      ),
    ],
  ),
  'M': LetterTrace(
    letter: 'M',

    strokes: [
      [
        Offset(0.27, 0.62),
        Offset(0.25, 0.67),
        Offset(0.25, 0.75),
        Offset(0.28, 0.80),
        Offset(0.31, 0.79),
        Offset(0.34, 0.71),
        Offset(0.36, 0.63),
        Offset(0.37, 0.52),
        Offset(0.38, 0.41),
        Offset(0.40, 0.31),
        Offset(0.40, 0.24),
        Offset(0.41, 0.17),
      ],

      [
        Offset(0.41, 0.17),
        Offset(0.43, 0.24),
        Offset(0.43, 0.31),
        Offset(0.44, 0.40),
        Offset(0.45, 0.51),
        Offset(0.46, 0.61),
        Offset(0.47, 0.69),
        Offset(0.50, 0.79),
      ],

      [
        Offset(0.50, 0.79),
        Offset(0.52, 0.70),
        Offset(0.53, 0.61),
        Offset(0.55, 0.51),
        Offset(0.57, 0.40),
        Offset(0.58, 0.31),
        Offset(0.59, 0.25),
        Offset(0.61, 0.18),
      ],

      [
        Offset(0.61, 0.18),
        Offset(0.62, 0.25),
        Offset(0.62, 0.30),
        Offset(0.63, 0.39),
        Offset(0.63, 0.50),
        Offset(0.63, 0.59),
        Offset(0.65, 0.69),
        Offset(0.66, 0.78),
        Offset(0.69, 0.80),
        Offset(0.72, 0.78),
        Offset(0.74, 0.73),
        Offset(0.75, 0.66),
      ],
    ],

    arrows: [
      // lewa część do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 0,
        fromIndex: 6,
        toIndex: 11,
      ),

      // zejście do środka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 7,
      ),



      // wyjście w górę
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 7,
      ),



      // prawa pionowa część
      TraceArrow(
        strokeIndex: 3,
        fromIndex: 0,
        toIndex: 5,
      ),

      TraceArrow(
        strokeIndex: 3,
        fromIndex: 8,
        toIndex: 11,
      ),
    ],
  ),
  'm': LetterTrace(
    letter: 'm',

    strokes: [
      [
        Offset(0.32, 0.56),
        Offset(0.33, 0.50),
        Offset(0.36, 0.49),
        Offset(0.38, 0.54),
        Offset(0.38, 0.61),
        Offset(0.38, 0.68),
        Offset(0.38, 0.74),
        Offset(0.38, 0.80),
      ],

      [
        Offset(0.40, 0.53),
        Offset(0.43, 0.49),
        Offset(0.46, 0.49),
        Offset(0.49, 0.51),
        Offset(0.50, 0.55),
        Offset(0.50, 0.60),
        Offset(0.50, 0.68),
        Offset(0.50, 0.73),
        Offset(0.50, 0.79),
      ],

      [
        Offset(0.52, 0.53),
        Offset(0.54, 0.51),
        Offset(0.56, 0.49),
        Offset(0.60, 0.50),
        Offset(0.62, 0.55),
        Offset(0.62, 0.61),
        Offset(0.62, 0.68),
        Offset(0.62, 0.74),
        Offset(0.62, 0.79),
        Offset(0.64, 0.80),
        Offset(0.66, 0.78),
      ],
    ],

    arrows: [
      // pierwsza część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 7,
      ),

      // środkowa część
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 1,
        fromIndex: 4,
        toIndex: 8,
      ),

      // prawa część
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 2,
        fromIndex: 4,
        toIndex: 8,
      ),
    ],
  ),
  'N': LetterTrace(
    letter: 'N',

    strokes: [
      [
        Offset(0.32, 0.63),
        Offset(0.31, 0.69),
        Offset(0.32, 0.76),
        Offset(0.35, 0.80),
        Offset(0.40, 0.76),
        Offset(0.41, 0.65),
        Offset(0.42, 0.52),
        Offset(0.42, 0.41),
        Offset(0.42, 0.30),
        Offset(0.42, 0.16),
      ],

      [
        Offset(0.42, 0.16),
        Offset(0.46, 0.30),
        Offset(0.49, 0.41),
        Offset(0.51, 0.50),
        Offset(0.55, 0.63),
        Offset(0.58, 0.74),
        Offset(0.60, 0.80),
      ],

      [
        Offset(0.60, 0.80),
        Offset(0.60, 0.63),
        Offset(0.60, 0.50),
        Offset(0.60, 0.38),
        Offset(0.60, 0.29),
        Offset(0.62, 0.19),
        Offset(0.66, 0.16),

        Offset(0.70, 0.19),
      ],
    ],

    arrows: [
      // lewa pionowa część do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 9,
      ),

      // przekątna
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 6,
      ),

      // prawa pionowa część w dół
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 4,
      ),

      TraceArrow(
        strokeIndex: 2,
        fromIndex: 5,
        toIndex: 7,
      ),
    ],
  ),
  'n': LetterTrace(
    letter: 'n',

    strokes: [
      [
        Offset(0.37, 0.57),
        Offset(0.39, 0.51),
        Offset(0.41, 0.50),
        Offset(0.44, 0.54),
        Offset(0.44, 0.61),
        Offset(0.44, 0.66),
        Offset(0.44, 0.73),
        Offset(0.44, 0.79),
      ],

      [
        Offset(0.44, 0.54),
        Offset(0.46, 0.53),
        Offset(0.48, 0.50),
        Offset(0.51, 0.49),
        Offset(0.55, 0.51),
        Offset(0.56, 0.57),
        Offset(0.56, 0.64),
        Offset(0.56, 0.71),
        Offset(0.56, 0.78),
        Offset(0.58, 0.81),
        Offset(0.60, 0.80),
      ],
    ],

    arrows: [
      // lewa pionowa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 7,
      ),

      // prawa część
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),

      TraceArrow(
        strokeIndex: 1,
        fromIndex: 5,
        toIndex: 8,
      ),
    ],
  ),
  'Ń': LetterTrace(
    letter: 'Ń',

    strokes: [
      [
        Offset(0.32, 0.63),
        Offset(0.31, 0.69),
        Offset(0.32, 0.76),
        Offset(0.35, 0.80),
        Offset(0.40, 0.76),
        Offset(0.41, 0.65),
        Offset(0.42, 0.52),
        Offset(0.42, 0.41),
        Offset(0.42, 0.30),
        Offset(0.42, 0.16),
      ],

      [
        Offset(0.46, 0.29),
        Offset(0.49, 0.38),
        Offset(0.51, 0.50),
        Offset(0.55, 0.63),
        Offset(0.58, 0.74),
        Offset(0.60, 0.80),
      ],

      [
        Offset(0.60, 0.72),
        Offset(0.60, 0.63),
        Offset(0.60, 0.50),
        Offset(0.60, 0.38),
        Offset(0.60, 0.29),
        Offset(0.62, 0.19),
        Offset(0.66, 0.16),
        Offset(0.66, 0.17),
        Offset(0.70, 0.19),
      ],

      // kreska
      [
        Offset(0.51, 0.08),
        Offset(0.53, 0.05),
        Offset(0.55, 0.02),
      ],
    ],

    arrows: [
      // lewa pionowa część do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 9,
      ),

      // przekątna
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 6,
      ),

      // prawa pionowa część w dół
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 4,
      ),

      TraceArrow(
        strokeIndex: 2,
        fromIndex: 5,
        toIndex: 7,


      ),
      // kreska nad literą
      TraceArrow(
        strokeIndex: 3,
        fromIndex: 0,
        toIndex: 2,
      ),

    ],
  ),
  'ń': LetterTrace(
    letter: 'ń',

    strokes: [
      [
        Offset(0.37, 0.57),
        Offset(0.39, 0.51),
        Offset(0.41, 0.50),
        Offset(0.44, 0.54),
        Offset(0.44, 0.61),
        Offset(0.44, 0.66),
        Offset(0.44, 0.73),
        Offset(0.44, 0.79),
      ],

      [
        Offset(0.44, 0.54),
        Offset(0.46, 0.53),
        Offset(0.48, 0.50),
        Offset(0.51, 0.49),
        Offset(0.55, 0.51),
        Offset(0.56, 0.57),
        Offset(0.56, 0.64),
        Offset(0.56, 0.71),
        Offset(0.56, 0.78),
        Offset(0.58, 0.81),
        Offset(0.60, 0.80),
      ],

      // kreska
      [
        Offset(0.49, 0.38),
        Offset(0.50, 0.34),
        Offset(0.52, 0.30),
        Offset(0.53, 0.27),
      ],
    ],

    arrows: [
      // lewa pionowa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 7,
      ),

      // prawa część
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),

      TraceArrow(
        strokeIndex: 1,
        fromIndex: 5,
        toIndex: 8,
      ),
      // kreska nad literą
      TraceArrow(
        strokeIndex: 2,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'O': LetterTrace(
    letter: 'O',

    strokes: [
      [
        Offset(0.37, 0.48),
        Offset(0.37, 0.39),
        Offset(0.39, 0.30),
        Offset(0.42, 0.23),
        Offset(0.46, 0.18),
        Offset(0.51, 0.17),
        Offset(0.56, 0.19),
        Offset(0.59, 0.25),

        Offset(0.61, 0.30),
        Offset(0.62, 0.38),
        Offset(0.63, 0.47),
        Offset(0.63, 0.55),
        Offset(0.62, 0.64),
        Offset(0.59, 0.72),
        Offset(0.56, 0.77),
        Offset(0.51, 0.80),

        Offset(0.47, 0.80),
        Offset(0.43, 0.77),
        Offset(0.40, 0.71),
        Offset(0.38, 0.64),
        Offset(0.37, 0.57),
      ],
    ],

    arrows: [
      // lewa górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // prawa górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 6,
        toIndex: 9,
      ),

      // prawa dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 14,
      ),

      // lewa dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 16,
        toIndex: 19,
      ),
    ],
  ),
  'o': LetterTrace(
    letter: 'o',

    strokes: [
      [
        Offset(0.43, 0.65),
        Offset(0.44, 0.58),
        Offset(0.46, 0.52),
        Offset(0.50, 0.49),
        Offset(0.54, 0.51),
        Offset(0.56, 0.59),
        Offset(0.57, 0.65),
        Offset(0.56, 0.73),

        Offset(0.53, 0.78),
        Offset(0.50, 0.80),
        Offset(0.46, 0.78),
        Offset(0.44, 0.74),
      ],
    ],

    arrows: [
      // górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // prawa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 7,
      ),

      // dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 9,
        toIndex: 11,
      ),
    ],
  ),
  'Ó': LetterTrace(
    letter: 'Ó',

    strokes: [
      [
        Offset(0.37, 0.48),
        Offset(0.37, 0.39),
        Offset(0.39, 0.30),
        Offset(0.42, 0.23),
        Offset(0.46, 0.18),
        Offset(0.51, 0.17),
        Offset(0.56, 0.19),
        Offset(0.59, 0.25),

        Offset(0.61, 0.30),
        Offset(0.62, 0.38),
        Offset(0.63, 0.47),
        Offset(0.63, 0.55),
        Offset(0.62, 0.64),
        Offset(0.59, 0.72),
        Offset(0.56, 0.77),
        Offset(0.51, 0.80),

        Offset(0.47, 0.80),
        Offset(0.43, 0.77),
        Offset(0.41, 0.71),
        Offset(0.38, 0.64),
        Offset(0.37, 0.57),
      ],

      [
        Offset(0.48, 0.08),
        Offset(0.50, 0.05),
        Offset(0.52, 0.02),
      ],
    ],

    arrows: [
      // lewa górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // prawa górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 6,
        toIndex: 9,
      ),

      // prawa dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 14,
      ),

      // lewa dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 16,
        toIndex: 19,
      ),
      // akcent
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'ó': LetterTrace(
    letter: 'ó',
    strokes: [
      [
        Offset(0.43, 0.65),
        Offset(0.44, 0.58),
        Offset(0.46, 0.52),
        Offset(0.50, 0.49),
        Offset(0.55, 0.53),
        Offset(0.56, 0.59),
        Offset(0.57, 0.65),
        Offset(0.56, 0.73),

        Offset(0.53, 0.78),
        Offset(0.50, 0.80),
        Offset(0.46, 0.78),
        Offset(0.45, 0.73),
      ],

      [
        Offset(0.49, 0.37),

        Offset(0.51, 0.32),
        Offset(0.53, 0.27),
      ],
    ],
    arrows: [
      // górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // prawa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 7,
      ),

      // dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 9,
        toIndex: 11,
      ),
      // akcent
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'P': LetterTrace(
    letter: 'P',

    strokes: [
      [
        Offset(0.45, 0.28),
        Offset(0.45, 0.34),
        Offset(0.45, 0.41),
        Offset(0.45, 0.49),
        Offset(0.45, 0.55),
        Offset(0.45, 0.63),
        Offset(0.45, 0.71),
        Offset(0.44, 0.78),
        Offset(0.41, 0.80),
        Offset(0.37, 0.76),
      ],

      [
        Offset(0.50, 0.53),
        Offset(0.54, 0.52),
        Offset(0.57, 0.49),
        Offset(0.61, 0.44),
        Offset(0.63, 0.36),
        Offset(0.63, 0.27),
        Offset(0.60, 0.20),
        Offset(0.56, 0.17),
        Offset(0.52, 0.17),
        Offset(0.47, 0.17),
        Offset(0.43, 0.20),
        Offset(0.40, 0.23),
        Offset(0.37, 0.27),
      ],
    ],

    arrows: [
      // pionowa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 6,
      ),

      // górny łuk
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),

      // zamknięcie łuku
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 7,
        toIndex: 10,
      ),
    ],
  ),
  'p': LetterTrace(
    letter: 'p',

    strokes: [
      [
        Offset(0.44, 0.97),
        Offset(0.44, 0.90),
        Offset(0.44, 0.82),
        Offset(0.44, 0.73),
        Offset(0.44, 0.65),
        Offset(0.44, 0.59),
        Offset(0.44, 0.49),
      ],

      [
        Offset(0.46, 0.53),
        Offset(0.49, 0.50),
        Offset(0.53, 0.49),
        Offset(0.56, 0.53),
        Offset(0.56, 0.60),
        Offset(0.56, 0.69),
        Offset(0.55, 0.77),
        Offset(0.58, 0.81),
        Offset(0.61, 0.78),
      ],
    ],

    arrows: [
      // pionowa część od dołu do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 6,
      ),

      // górna część brzuszka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),

      // dolna część brzuszka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 4,
        toIndex: 6,
      ),
    ],
  ),
  'R': LetterTrace(
    letter: 'R',

    strokes: [
      [
        Offset(0.43, 0.29),
        Offset(0.43, 0.34),
        Offset(0.43, 0.41),
        Offset(0.43, 0.49),
        Offset(0.43, 0.57),
        Offset(0.43, 0.66),
        Offset(0.43, 0.76),
        Offset(0.39, 0.80),
        Offset(0.37, 0.79),
        Offset(0.34, 0.75),
      ],

      [
        Offset(0.35, 0.27),
        Offset(0.37, 0.24),
        Offset(0.40, 0.21),
        Offset(0.44, 0.18),
        Offset(0.48, 0.17),
        Offset(0.53, 0.17),
        Offset(0.57, 0.20),
        Offset(0.60, 0.27),
        Offset(0.60, 0.37),
        Offset(0.57, 0.44),
        Offset(0.53, 0.48),
        Offset(0.50, 0.49),
        Offset(0.47, 0.47),

        Offset(0.50, 0.47),
        Offset(0.52, 0.55),
        Offset(0.53, 0.60),
        Offset(0.55, 0.66),
        Offset(0.57, 0.72),
        Offset(0.59, 0.77),
        Offset(0.63, 0.81),
        Offset(0.65, 0.79),
        Offset(0.67, 0.76),
      ],
    ],

    arrows: [
      // pionowa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 6,
      ),

      // górny brzuszek
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 6,
      ),

      // ukośna noga
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 14,
        toIndex: 18,
      ),
    ],
  ),
  'r': LetterTrace(
    letter: 'r',

    strokes: [
      [
        Offset(0.39, 0.56),
        Offset(0.41, 0.51),
        Offset(0.44, 0.49),
        Offset(0.46, 0.52),
        Offset(0.46, 0.59),
        Offset(0.46, 0.65),
        Offset(0.46, 0.72),
        Offset(0.46, 0.78),
      ],

      [
        Offset(0.48, 0.55),
        Offset(0.50, 0.51),
        Offset(0.52, 0.48),
        Offset(0.53, 0.55),
        Offset(0.55, 0.57),
        Offset(0.58, 0.55),
        Offset(0.60, 0.50),
        Offset(0.59, 0.51),
      ],
    ],

    arrows: [
      // pionowa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // górny łuk
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'S': LetterTrace(
    letter: 'S',

    strokes: [
      [
        Offset(0.58, 0.22),
        Offset(0.54, 0.17),
        Offset(0.49, 0.17),
        Offset(0.45, 0.21),
        Offset(0.43, 0.30),
        Offset(0.44, 0.38),
        Offset(0.47, 0.44),
        Offset(0.51, 0.48),
        Offset(0.56, 0.52),
        Offset(0.58, 0.61),
        Offset(0.58, 0.70),
        Offset(0.55, 0.77),
        Offset(0.51, 0.79),
        Offset(0.46, 0.79),
        Offset(0.42, 0.75),
      ],
    ],

    arrows: [
      // górna część litery
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // środkowy skręt
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 8,
      ),

      // dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 14,
      ),
    ],
  ),
  's': LetterTrace(
    letter: 's',

    strokes: [
      [
        Offset(0.38, 0.81),
        Offset(0.41, 0.78),
        Offset(0.43, 0.72),
        Offset(0.45, 0.65),
        Offset(0.46, 0.58),
        Offset(0.47, 0.52),
        Offset(0.48, 0.47),
        Offset(0.47, 0.44),
        Offset(0.46, 0.49),
        Offset(0.47, 0.53),
        Offset(0.49, 0.57),
        Offset(0.52, 0.60),
        Offset(0.54, 0.64),
        Offset(0.56, 0.72),
        Offset(0.55, 0.78),
        Offset(0.51, 0.80),
        Offset(0.47, 0.79),
      ],
    ],

    arrows: [
      // górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 6,
      ),

      // środkowy skręt
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 12,
      ),

      // dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 16,
      ),
    ],
  ),
  'Ś': LetterTrace(
    letter: 'Ś',
    strokes: [
      // S
      [
        Offset(0.58, 0.22),
        Offset(0.54, 0.17),
        Offset(0.49, 0.17),
        Offset(0.45, 0.21),
        Offset(0.43, 0.30),
        Offset(0.44, 0.38),
        Offset(0.47, 0.44),
        Offset(0.51, 0.48),
        Offset(0.56, 0.52),
        Offset(0.58, 0.61),
        Offset(0.58, 0.70),
        Offset(0.55, 0.77),
        Offset(0.51, 0.79),
        Offset(0.46, 0.79),
        Offset(0.42, 0.75),
      ],

      // kreska
      [
        Offset(0.49, 0.08),
        Offset(0.51, 0.05),
        Offset(0.53, 0.02),
      ],
    ],
    arrows: [
      // górna część litery
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // środkowy skręt
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 8,
      ),

      // dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 14,
      ),
      // kreska
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'ś': LetterTrace(
    letter: 'ś',
    strokes: [
      // s
      [
        Offset(0.38, 0.81),
        Offset(0.41, 0.78),
        Offset(0.43, 0.72),
        Offset(0.45, 0.65),
        Offset(0.46, 0.58),
        Offset(0.47, 0.52),
        Offset(0.48, 0.47),
        Offset(0.47, 0.44),
        Offset(0.46, 0.49),
        Offset(0.47, 0.53),
        Offset(0.49, 0.57),
        Offset(0.52, 0.60),
        Offset(0.54, 0.64),
        Offset(0.56, 0.72),
        Offset(0.55, 0.78),
        Offset(0.51, 0.80),
        Offset(0.47, 0.79),
      ],

      // kreska
      [
        Offset(0.46, 0.36),
        Offset(0.48, 0.32),
        Offset(0.50, 0.27),
      ],
    ],
    arrows: [
      // górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 6,
      ),

      // środkowy skręt
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 12,
      ),

      // dolna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 16,
      ),
      // kreska
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),

    ],

  ),
  'T': LetterTrace(
    letter: 'T',

    strokes: [
      // górna linia
      [
        Offset(0.37, 0.26),
        Offset(0.39, 0.22),
        Offset(0.41, 0.19),
        Offset(0.45, 0.18),
        Offset(0.49, 0.18),
        Offset(0.51, 0.17),
        Offset(0.54, 0.18),
        Offset(0.57, 0.18),
        Offset(0.60, 0.18),
        Offset(0.62, 0.17),
      ],

      // pionowa linia
      [
        Offset(0.51, 0.18),
        Offset(0.51, 0.22),
        Offset(0.51, 0.29),
        Offset(0.51, 0.35),
        Offset(0.51, 0.41),
        Offset(0.51, 0.48),
        Offset(0.51, 0.54),
        Offset(0.51, 0.61),
        Offset(0.51, 0.67),
        Offset(0.50, 0.74),
        Offset(0.48, 0.79),
        Offset(0.45, 0.79),
        Offset(0.42, 0.77),
      ],
    ],

    arrows: [
      // górna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 2,
        toIndex: 9,
      ),

      // pionowa część
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 8,
      ),

      // zakończenie na dole
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 10,
        toIndex: 12,
      ),
    ],
  ),
  't': LetterTrace(
    letter: 't',

    strokes: [
      // pionowa linia
      [
        Offset(0.49, 0.34),
        Offset(0.49, 0.40),
        Offset(0.49, 0.44),
        Offset(0.49, 0.49),
        Offset(0.49, 0.53),
        Offset(0.49, 0.57),
        Offset(0.49, 0.63),
        Offset(0.49, 0.70),
        Offset(0.49, 0.77),
        Offset(0.52, 0.80),
        Offset(0.55, 0.78),
      ],

      // poprzeczka
      [
        Offset(0.45, 0.50),
        Offset(0.47, 0.50),

        Offset(0.51, 0.50),
        Offset(0.54, 0.50),
      ],
    ],

    arrows: [
      // pionowa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 8,
      ),

      // zakończenie na dole
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 10,
      ),

      // poprzeczka
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 3,
      ),
    ],
  ),
  'U': LetterTrace(
    letter: 'U',

    strokes: [
      [
        Offset(0.33, 0.23),
        Offset(0.35, 0.18),
        Offset(0.39, 0.16),

        Offset(0.42, 0.23),
        Offset(0.42, 0.33),
        Offset(0.42, 0.42),
        Offset(0.42, 0.52),
        Offset(0.42, 0.64),
        Offset(0.43, 0.74),

        Offset(0.47, 0.80),
        Offset(0.52, 0.79),

        Offset(0.56, 0.75),
        Offset(0.59, 0.70),

        Offset(0.60, 0.62),
        Offset(0.60, 0.53),
        Offset(0.60, 0.43),
        Offset(0.60, 0.35),
        Offset(0.60, 0.27),
        Offset(0.60, 0.18),

        // prawy ogonek
        Offset(0.60, 0.76),
        Offset(0.63, 0.79),
        Offset(0.66, 0.77),
      ],
    ],

    arrows: [
      // lewa część w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),

      // dolne zaokrąglenie
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 7,
      ),

      // prawa część do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 13,
        toIndex: 18,
      ),

      // ogonek
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 12,
        toIndex: 20,
      ),
    ],
  ),
  'u': LetterTrace(
    letter: 'u',

    strokes: [
      [
        Offset(0.43, 0.50),
        Offset(0.43, 0.57),
        Offset(0.43, 0.64),
        Offset(0.43, 0.73),

        Offset(0.45, 0.79),
        Offset(0.49, 0.80),

        Offset(0.53, 0.77),
        Offset(0.55, 0.71),
        Offset(0.56, 0.64),
        Offset(0.56, 0.56),
        Offset(0.56, 0.49),

        // prawy ogonek
        Offset(0.56, 0.77),
        Offset(0.58, 0.81),
        Offset(0.60, 0.78),
      ],
    ],

    arrows: [
      // lewa część w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // dolne zaokrąglenie i prawa część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 7,
        toIndex: 10,
      ),

      // ogonek
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 13,
      ),
    ],
  ),
  'W': LetterTrace(
    letter: 'W',

    strokes: [
      [
        // lewa górna część
        Offset(0.27, 0.25),
        Offset(0.28, 0.19),
        Offset(0.32, 0.16),

        // w dół
        Offset(0.35, 0.21),
        Offset(0.35, 0.30),
        Offset(0.35, 0.39),
        Offset(0.36, 0.50),
        Offset(0.36, 0.59),
        Offset(0.37, 0.69),

        // pierwszy dół
        Offset(0.41, 0.78),
        Offset(0.45, 0.79),

        // środek do góry
        Offset(0.49, 0.72),
        Offset(0.50, 0.62),
        Offset(0.52, 0.52),
        Offset(0.51, 0.41),
        Offset(0.52, 0.33),

        // środek w dół
        Offset(0.53, 0.41),
        Offset(0.53, 0.52),
        Offset(0.54, 0.61),
        Offset(0.55, 0.72),

        // drugi dół
        Offset(0.59, 0.79),
        Offset(0.63, 0.79),

        // prawa strona do góry
        Offset(0.67, 0.70),
        Offset(0.68, 0.60),
        Offset(0.69, 0.50),
        Offset(0.69, 0.40),
        Offset(0.69, 0.30),
        Offset(0.68, 0.21),
        Offset(0.67, 0.14),

        // prawy ogonek
        Offset(0.65, 0.16),
        Offset(0.69, 0.19),
        Offset(0.72, 0.20),
        Offset(0.74, 0.22),
      ],
    ],

    arrows: [
      // lewa część w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 8,
      ),

      // środek do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 14,
      ),

      // środek w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 16,
        toIndex: 19,
      ),

      // prawa część do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 22,
        toIndex: 28,
      ),

      // ogonek
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 29,
        toIndex: 32,
      ),
    ],
  ),
  'w': LetterTrace(
    letter: 'w',

    strokes: [
      [
        // lewa strona w dół
        Offset(0.40, 0.49),
        Offset(0.40, 0.57),
        Offset(0.40, 0.65),
        Offset(0.40, 0.73),

        // pierwszy dół
        Offset(0.42, 0.80),
        Offset(0.46, 0.79),

        // środek do góry
        Offset(0.49, 0.75),
        Offset(0.50, 0.69),
        Offset(0.50, 0.63),
        Offset(0.50, 0.55),
        Offset(0.50, 0.49),

        // środek w dół
        Offset(0.51, 0.76),

        // drugi dół
        Offset(0.54, 0.80),
        Offset(0.58, 0.78),

        // prawa strona do góry
        Offset(0.60, 0.71),
        Offset(0.61, 0.63),
        Offset(0.60, 0.55),
        Offset(0.59, 0.49),
      ],
    ],

    arrows: [
      // lewa część w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // środek do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 10,
      ),

      // środek w dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 10,
        toIndex: 12,
      ),

      // prawa część do góry
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 15,
        toIndex: 17,
      ),
    ],
  ),
  /// Y i y poprawic
  'Z': LetterTrace(
    letter: 'Z',

    strokes: [
      [
        Offset(0.38, 0.22),
        Offset(0.43, 0.17),
        Offset(0.48, 0.17),
        Offset(0.53, 0.19),
        Offset(0.57, 0.20),
        Offset(0.61, 0.17),

        Offset(0.59, 0.24),
        Offset(0.57, 0.29),
        Offset(0.54, 0.35),
        Offset(0.51, 0.43),
        Offset(0.48, 0.51),
        Offset(0.45, 0.58),
        Offset(0.42, 0.66),
        Offset(0.39, 0.73),
        Offset(0.37, 0.79),

        Offset(0.40, 0.78),
        Offset(0.44, 0.77),
        Offset(0.47, 0.78),
        Offset(0.51, 0.79),
        Offset(0.56, 0.80),
        Offset(0.60, 0.78),
        Offset(0.62, 0.75),
        Offset(0.64, 0.68),
      ],
    ],

    arrows: [
      // górna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 5,
      ),

      // ukośna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 14,
      ),

      // dolna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 19,
      ),
    ],
  ),
  'z': LetterTrace(
    letter: 'z',

    strokes: [
      [
        Offset(0.45, 0.50),
        Offset(0.48, 0.50),
        Offset(0.52, 0.50),
        Offset(0.55, 0.50),

        Offset(0.53, 0.56),
        Offset(0.51, 0.62),
        Offset(0.49, 0.67),
        Offset(0.47, 0.73),
        Offset(0.46, 0.78),

        Offset(0.49, 0.78),
        Offset(0.52, 0.78),

        Offset(0.56, 0.78),
      ],
    ],

    arrows: [
      // górna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // ukośna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 8,
      ),

      // dolna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 11,
      ),
    ],
  ),
  'Ź': LetterTrace(
    letter: 'Ź',

    strokes: [
      [
        Offset(0.38, 0.22),
        Offset(0.43, 0.16),
        Offset(0.48, 0.17),
        Offset(0.53, 0.19),
        Offset(0.57, 0.20),
        Offset(0.61, 0.17),

        Offset(0.59, 0.24),
        Offset(0.57, 0.29),
        Offset(0.54, 0.35),
        Offset(0.51, 0.43),
        Offset(0.48, 0.51),
        Offset(0.45, 0.59),
        Offset(0.42, 0.66),
        Offset(0.39, 0.73),
        Offset(0.37, 0.79),

        Offset(0.40, 0.78),
        Offset(0.44, 0.77),
        Offset(0.47, 0.78),
        Offset(0.51, 0.79),
        Offset(0.55, 0.80),
        Offset(0.60, 0.78),
        Offset(0.62, 0.75),
        Offset(0.64, 0.68),
      ],

      // kreska
      [
        Offset(0.48, 0.08),
        Offset(0.50, 0.05),
        Offset(0.52, 0.02),
      ],
    ],

    arrows: [
      // górna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 5,
      ),

      // ukośna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 14,
      ),

      // dolna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 19,
      ),

      // kreska
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'ź': LetterTrace(
    letter: 'ź',

    strokes: [
      [
        Offset(0.45, 0.50),
        Offset(0.48, 0.50),
        Offset(0.52, 0.50),
        Offset(0.55, 0.50),

        Offset(0.53, 0.56),
        Offset(0.51, 0.62),
        Offset(0.49, 0.67),
        Offset(0.47, 0.73),
        Offset(0.46, 0.78),

        Offset(0.49, 0.78),
        Offset(0.52, 0.78),

        Offset(0.56, 0.78),
      ],

      // kreska
      [
        Offset(0.49, 0.37),
        Offset(0.51, 0.33),
        Offset(0.53, 0.29),
      ],
    ],

    arrows: [
      // górna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // ukośna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 8,
      ),

      // dolna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 11,
      ),

      // kreska
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 2,
      ),
    ],
  ),
  'Ż': LetterTrace(
    letter: 'Ż',

    strokes: [
      [
        Offset(0.38, 0.22),
        Offset(0.43, 0.16),
        Offset(0.48, 0.17),
        Offset(0.53, 0.19),
        Offset(0.57, 0.20),
        Offset(0.61, 0.17),

        Offset(0.59, 0.24),
        Offset(0.57, 0.29),
        Offset(0.54, 0.35),
        Offset(0.51, 0.43),
        Offset(0.48, 0.51),
        Offset(0.45, 0.59),
        Offset(0.42, 0.66),
        Offset(0.39, 0.73),
        Offset(0.37, 0.79),

        Offset(0.40, 0.78),
        Offset(0.44, 0.77),
        Offset(0.47, 0.78),
        Offset(0.51, 0.79),
        Offset(0.55, 0.80),
        Offset(0.60, 0.78),
        Offset(0.62, 0.75),
        Offset(0.64, 0.68),
      ],

      // kropka
      [
        Offset(0.50, 0.04),
      ],
    ],

    arrows: [
      // górna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 1,
        toIndex: 5,
      ),

      // ukośna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 14,
      ),

      // dolna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 14,
        toIndex: 19,
      ),
    ],
  ),
  'ż': LetterTrace(
    letter: 'ż',

    strokes: [
      [
        Offset(0.45, 0.50),
        Offset(0.48, 0.50),
        Offset(0.52, 0.50),
        Offset(0.55, 0.50),

        Offset(0.53, 0.56),
        Offset(0.51, 0.62),
        Offset(0.49, 0.67),
        Offset(0.47, 0.73),
        Offset(0.46, 0.78),

        Offset(0.49, 0.78),
        Offset(0.52, 0.78),

        Offset(0.56, 0.78),
      ],

      // kropka
      [
        Offset(0.50, 0.31),
      ],
    ],

    arrows: [
      // górna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),

      // ukośna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 8,
      ),

      // dolna linia
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 8,
        toIndex: 11,
      ),
    ],
  ),
  '0': LetterTrace(
    letter: '0',
    strokes: [
      [
        Offset(0.50, 0.16),

        Offset(0.57, 0.23),
        Offset(0.60, 0.35),
        Offset(0.61, 0.47),
        Offset(0.60, 0.62),
        Offset(0.58, 0.73),
        Offset(0.51, 0.80),
        Offset(0.43, 0.73),
        Offset(0.40, 0.62),
        Offset(0.39, 0.47),
        Offset(0.40, 0.35),
        Offset(0.44, 0.23),
        Offset(0.50, 0.16),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 1,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 6,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 9,
        toIndex: 10,
      ),
    ],
  ),
  '1': LetterTrace(
    letter: '1',
    strokes: [
      [
        Offset(0.43, 0.28),
        Offset(0.46, 0.24),
        Offset(0.50, 0.17),
        Offset(0.50, 0.27),
        Offset(0.50, 0.37),
        Offset(0.50, 0.47),
        Offset(0.50, 0.57),
        Offset(0.50, 0.67),
        Offset(0.50, 0.77),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 7,
      ),
    ],
  ),
  '2': LetterTrace(
    letter: '2',
    strokes: [
      [
        Offset(0.42, 0.23),
        Offset(0.47, 0.17),
        Offset(0.53, 0.17),
        Offset(0.58, 0.24),
        Offset(0.58, 0.34),
        Offset(0.56, 0.46),
        Offset(0.51, 0.57),
        Offset(0.46, 0.68),
        Offset(0.40, 0.79),

        // dolna linia
        Offset(0.46, 0.79),
        Offset(0.53, 0.79),
        Offset(0.60, 0.79),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 1,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 8,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 9,
        toIndex: 11,
      ),
    ],
  ),
  '3': LetterTrace(
    letter: '3',
    strokes: [
      [
        Offset(0.41, 0.23),
        Offset(0.46, 0.18),
        Offset(0.52, 0.17),
        Offset(0.57, 0.24),
        Offset(0.58, 0.34),
        Offset(0.55, 0.42),
        Offset(0.48, 0.46),

        Offset(0.55, 0.50),
        Offset(0.59, 0.60),
        Offset(0.58, 0.70),
        Offset(0.54, 0.77),
        Offset(0.49, 0.80),
        Offset(0.44, 0.77),
        Offset(0.39, 0.70),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 6,
        toIndex: 7,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 11,
        toIndex: 13,
      ),
    ],
  ),
  '4': LetterTrace(
    letter: '4',
    strokes: [
      [
        Offset(0.50, 0.17),
        Offset(0.48, 0.27),
        Offset(0.46, 0.36),
        Offset(0.44, 0.45),
        Offset(0.41, 0.54),
        Offset(0.39, 0.61),
        Offset(0.46, 0.61),
        Offset(0.53, 0.61),
        Offset(0.60, 0.61),
      ],
      [
        Offset(0.56, 0.38),
        Offset(0.56, 0.47),
        Offset(0.56, 0.56),
        Offset(0.56, 0.66),
        Offset(0.56, 0.76),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 3,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 5,
        toIndex: 8,
      ),
      TraceArrow(
        strokeIndex: 1,
        fromIndex: 0,
        toIndex: 4,
      ),
    ],
  ),
  '5': LetterTrace(
    letter: '5',
    strokes: [
      [
        // górna linia
        Offset(0.58, 0.18),
        Offset(0.53, 0.18),
        Offset(0.48, 0.18),
        Offset(0.43, 0.18),

        // lewa strona w dół
        Offset(0.43, 0.26),
        Offset(0.43, 0.34),
        Offset(0.43, 0.42),

        // środek
        Offset(0.43, 0.48),
        Offset(0.47, 0.42),
        Offset(0.52, 0.42),
        Offset(0.57, 0.47),

        // dół
        Offset(0.59, 0.56),
        Offset(0.59, 0.67),
        Offset(0.57, 0.76),
        Offset(0.52, 0.79),
        Offset(0.47, 0.79),
        Offset(0.43, 0.74),
        Offset(0.40, 0.71),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 7,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 9,
        toIndex: 10,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 15,
        toIndex: 17,
      ),
    ],
  ),
  '6': LetterTrace(
    letter: '6',
    strokes: [
      [
        Offset(0.56, 0.16),
        Offset(0.50, 0.20),
        Offset(0.46, 0.25),
        Offset(0.42, 0.36),
        Offset(0.41, 0.49),
        Offset(0.41, 0.63),
        Offset(0.44, 0.75),
        Offset(0.50, 0.80),
        Offset(0.57, 0.76),
        Offset(0.60, 0.66),
        Offset(0.60, 0.54),
        Offset(0.55, 0.44),
        Offset(0.50, 0.43),
        Offset(0.46, 0.45),
        Offset(0.43, 0.50),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 2,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 7,
        toIndex: 8,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 12,
        toIndex: 14,
      ),
    ],
  ),
  '7': LetterTrace(
    letter: '7',
    strokes: [
      [
        // górna linia
        Offset(0.41, 0.17),
        Offset(0.47, 0.17),
        Offset(0.53, 0.17),
        Offset(0.58, 0.17),

        // linia w dół
        Offset(0.56, 0.30),
        Offset(0.54, 0.40),
        Offset(0.52, 0.50),
        Offset(0.50, 0.60),
        Offset(0.48, 0.70),
        Offset(0.46, 0.80),
      ],
    ],
    arrows: [
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 1,
      ),
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 3,
        toIndex: 5,
      ),
    ],
  ),
  '8': LetterTrace(
    letter: '8',
    strokes: [
      [
        // środek
        Offset(0.50, 0.45),

        // górne koło
        Offset(0.56, 0.40),
        Offset(0.58, 0.30),
        Offset(0.56, 0.19),
        Offset(0.50, 0.15),
        Offset(0.44, 0.19),
        Offset(0.42, 0.30),
        Offset(0.45, 0.40),

        // przejście
        Offset(0.56, 0.51),

        // dolne koło
        Offset(0.60, 0.62),
        Offset(0.57, 0.76),
        Offset(0.50, 0.79),
        Offset(0.44, 0.76),
        Offset(0.40, 0.66),
        Offset(0.42, 0.54),
        Offset(0.50, 0.45),
      ],
    ],
    arrows: [
      // górna część
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 1,
      ),



      // przejście do dołu
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 7,
        toIndex: 8,
      ),




      TraceArrow(
        strokeIndex: 0,
        fromIndex: 13,
        toIndex: 14,
      ),
    ],
  ),
  '9': LetterTrace(
    letter: '9',
    strokes: [
      [
        // górne koło
        Offset(0.59, 0.34),
        Offset(0.57, 0.23),
        Offset(0.52, 0.17),
        Offset(0.45, 0.18),
        Offset(0.40, 0.30),
        Offset(0.40, 0.42),
        Offset(0.44, 0.53),
        Offset(0.50, 0.54),
        Offset(0.54, 0.51),
        Offset(0.59, 0.44),

        // dół
        Offset(0.59, 0.54),
        Offset(0.57, 0.64),
        Offset(0.54, 0.72),
        Offset(0.49, 0.78),
        Offset(0.44, 0.80),
      ],
    ],
    arrows: [
      // górne koło
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 0,
        toIndex: 1,
      ),

      // przejście
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 4,
        toIndex: 5,
      ),

      // dół
      TraceArrow(
        strokeIndex: 0,
        fromIndex: 9,
        toIndex: 10,
      ),
    ],
  ),
};
