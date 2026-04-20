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
  List<Offset?> points = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Litera ${widget.letter}'),
      ),

      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.letter,
                    style: TextStyle(
                      fontSize:400,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.withOpacity(0.25),
                      letterSpacing: 2,
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