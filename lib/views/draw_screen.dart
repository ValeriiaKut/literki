import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'painter.dart';

class DrawScreen extends StatefulWidget {
  final String letter;
  final List<String> letters;
  final int index;

  const DrawScreen({
    super.key,
    required this.letter,
    required this.letters,
    required this.index,
  });

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  static const double _targetFontSize = 400;
  static const double _targetLetterSpacing = 2;
  // Wider stroke is used only when scoring, so a tracing line through the
  // middle of the letter still covers most of its area.
  static const double _scoringStrokeWidth = 25;

  List<Offset?> points = [];
  Size? _canvasSize;

  void goToLetter(int newIndex) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DrawScreen(
          letter: widget.letters[newIndex],
          letters: widget.letters,
          index: newIndex,
        ),
      ),
    );
  }

  Future<void> _checkLetter() async {
    final size = _canvasSize;
    if (size == null) return;

    final hasDrawing = points.any((p) => p != null);
    if (!hasDrawing) {
      _showResultDialog(0, "Najpierw narysuj literę!");
      return;
    }

    final score = await _scoreDrawing(size);
    _showResultDialog(score, _messageForScore(score));
  }

  Future<int> _scoreDrawing(Size size) async {
    final width = size.width.toInt();
    final height = size.height.toInt();
    if (width <= 0 || height <= 0) return 1;

    final targetImage = await _renderTarget(size);
    final drawingImage = await _renderDrawing(size);

    final targetBytes =
        await targetImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    final drawingBytes =
        await drawingImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    targetImage.dispose();
    drawingImage.dispose();

    if (targetBytes == null || drawingBytes == null) return 1;

    int targetPixels = 0;
    int drawnPixels = 0;
    int intersection = 0;
    final length = targetBytes.lengthInBytes;
    for (int i = 3; i < length; i += 4) {
      final tActive = targetBytes.getUint8(i) > 30;
      final dActive = drawingBytes.getUint8(i) > 30;
      if (tActive) targetPixels++;
      if (dActive) drawnPixels++;
      if (tActive && dActive) intersection++;
    }

    if (targetPixels == 0 || drawnPixels == 0) return 1;

    final coverage = intersection / targetPixels;
    final accuracy = intersection / drawnPixels;
    final denom = coverage + accuracy;
    final f1 = denom == 0 ? 0.0 : 2 * coverage * accuracy / denom;

    if (f1 >= 0.65) return 5;
    if (f1 >= 0.50) return 4;
    if (f1 >= 0.35) return 3;
    if (f1 >= 0.20) return 2;
    return 1;
  }

  Future<ui.Image> _renderTarget(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final tp = TextPainter(
      text: TextSpan(
        text: widget.letter,
        style: const TextStyle(
          fontFamily: 'Handwriting',
          fontSize: _targetFontSize,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          letterSpacing: _targetLetterSpacing,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
    );
    return recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
  }

  Future<ui.Image> _renderDrawing(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = _scoringStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (int i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      if (a != null && b != null) {
        canvas.drawLine(a, b, paint);
      }
    }
    return recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
  }

  String _messageForScore(int score) {
    switch (score) {
      case 5:
        return "Doskonale!";
      case 4:
        return "Świetnie!";
      case 3:
        return "Bardzo dobrze!";
      case 2:
        return "Coraz lepiej!";
      default:
        return "Spróbuj jeszcze raz!";
    }
  }

  void _showResultDialog(int score, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (i) => Icon(
              i < score ? Icons.star_rounded : Icons.star_border_rounded,
              color: Colors.amber,
              size: 56,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => points.clear());
            },
            child: const Text("Spróbuj ponownie", style: TextStyle(fontSize: 16)),
          ),
          if (widget.index < widget.letters.length - 1)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                goToLetter(widget.index + 1);
              },
              child: const Text("Następna litera", style: TextStyle(fontSize: 16)),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Litera ${widget.letter}'),
      ),

      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
                return Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.letter,
                        style: TextStyle(
                          fontSize: _targetFontSize,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey.withOpacity(0.25),
                          letterSpacing: _targetLetterSpacing,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          points.add(details.localPosition);
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          points.add(details.localPosition);
                        });
                      },
                      onPanEnd: (_) {
                        points.add(null);
                      },
                      child: CustomPaint(
                        painter: DrawingPainter(points),
                        size: Size.infinite,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkLetter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Sprawdź",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ← PREV
              SizedBox(
                width: 120,
                child: widget.index > 0
                    ? ElevatedButton(
                  onPressed: () => goToLetter(widget.index - 1),
                  child: const Text("Powrót"),
                )
                    : const SizedBox(),
              ),

              // CLEAR
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    points.clear();
                  });
                },
                child: const Text("Wyczyścić"),
              ),

              // NEXT →
              SizedBox(
                width: 130,
                child: widget.index < widget.letters.length - 1
                    ? ElevatedButton(
                  onPressed: () => goToLetter(widget.index + 1),
                  child: const Text("Następny"),
                )
                    : const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}