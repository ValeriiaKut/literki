import 'package:flutter/material.dart';

class LetterTrace {
  final String letter;
  final List<List<Offset>> strokes;

  // нове поле для стрілок
  final List<TraceArrow> arrows;

  const LetterTrace({
    required this.letter,
    required this.strokes,

    // якщо стрілок нема → пустий список
    this.arrows = const [],
  });
}

class TraceArrow {
  final int strokeIndex;
  final int fromIndex;
  final int toIndex;

  const TraceArrow({
    required this.strokeIndex,
    required this.fromIndex,
    required this.toIndex,
  });
}