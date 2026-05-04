import 'package:flutter/material.dart';
import 'draw_screen.dart';

class NumbersScreen extends StatelessWidget {
  NumbersScreen({super.key});

  final List<String> numbers = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cyfry"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          final number = numbers[index];
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DrawScreen(
                    letter: number,
                    letters: numbers,
                    index: index,
                    itemLabel: 'cyfra',
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
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
