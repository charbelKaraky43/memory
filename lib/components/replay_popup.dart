import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memory_game/main.dart';
import 'package:memory_game/animation/spin_animation.dart';

const messages = ['Awesome!', 'Fantastic!', 'Nice!', 'Great!'];

class ReplayPopUp extends StatelessWidget {
  const ReplayPopUp({Key? key});

  @override
  Widget build(BuildContext context) {
    final r = Random().nextInt(messages.length);
    String message = messages[r];

    return SpinAnimation(
      child: AlertDialog(
        contentPadding: EdgeInsets.zero, // Remove default padding
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 50), // Increase title font size
          ),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5, // Set custom height,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🥳',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 150), // Increase content font size
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const MyApp(),
                    ),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child: const Text(
                  'Replay!',
                  style: TextStyle(fontSize: 70), // Increase button text font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

