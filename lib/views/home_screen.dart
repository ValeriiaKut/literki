import 'package:flutter/material.dart';
import 'draw_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> letters = [
    'A', 'a',
    'Ą', 'ą',
    'B', 'b',
    'C', 'c',
    'Ć', 'ć',
    'D', 'd',
    'E', 'e',
    'Ę', 'ę',
    'F', 'f',
    'G', 'g',
    'H', 'h',
    'I', 'i',
    'J', 'j',
    'K', 'k',
    'L', 'l',
    'Ł', 'ł',
    'M', 'm',
    'N', 'n',
    'Ń', 'ń',
    'O', 'o',
    'Ó', 'ó',
    'P', 'p',
    'R', 'r',
    'S', 's',
    'Ś', 'ś',
    'T', 't',
    'U', 'u',
    'W', 'w',
    'Y', 'y',
    'Z', 'z',
    'Ź', 'ź',
    'Ż', 'ż',
  ];

  final Set<String> vowels = {
    'A', 'a',
    'Ą', 'ą',
    'E', 'e',
    'Ę', 'ę',
    'I', 'i',
    'O', 'o',
    'Ó', 'ó',
    'U', 'u',
    'Y', 'y',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Literki"),
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(10),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),

        itemCount: letters.length,

        itemBuilder: (context, index) {
          final letter = letters[index];

          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DrawScreen(
                    letter: letter,
                    letters: letters,
                    index: index,
                  ),
                ),
              );
            },

            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(6),
              minimumSize: const Size(15, 15),

              backgroundColor: Colors.white,

              elevation: 3,
            ),

            child: Text(
              letter,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,

                color: vowels.contains(letter)
                    ? Colors.red
                    : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}