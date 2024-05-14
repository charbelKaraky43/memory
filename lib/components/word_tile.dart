import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memory_game/animation/flip_animation.dart';
import 'package:memory_game/animation/matched_animation.dart';
import 'package:memory_game/managers/game_manager.dart';
import 'package:memory_game/models/word.dart';
import 'package:provider/provider.dart';

class WordTile extends StatelessWidget {
  const WordTile({
    required this.index,
    required this.word,
    required this.currentLevel, // Add currentLevel parameter
    super.key,
  });

  final int index;
  final Word word;
  final int currentLevel; // Add currentLevel field

  @override
  Widget build(BuildContext context) {
    return Consumer<GameManager>(
      builder: (_, notifier, __) {
        bool animate = checkAnimationRun(notifier);

        return GestureDetector(
          onTap: () {
            if (!notifier.ignoreTaps &&
                !notifier.answeredWords.contains(index) &&
                !notifier.tappedWords.containsKey(index)) {
              notifier.tileTapped(index: index, word: word);
            }
          },
          child: FlipAnimation(
            delay: notifier.reverseFlip ? 1500 : 0,
            reverse: notifier.reverseFlip,
            animationCompleted: (isForward) {
              notifier.onAnimationCompleted(isForward: isForward);
            },
            animate: animate,
            word: MatchedAnimation(
              numberOfWordsAnswered: notifier.answeredWords.length,
              animate: notifier.answeredWords.contains(index),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: _buildContent(context, animate),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isFlipped) {
    if (currentLevel == 2) {
      // For level 2, display both text and image with rotation
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (word.imageBytes != null)
            Flexible(
              child: Image.memory(
                word.imageBytes!,
                width: 100, // Adjust the width and height as needed
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print('Error loading image: $error');
                  }
                  return const Icon(Icons.error);
                },
              ),
            )
          else
            FutureBuilder<Uint8List>(
              future: _loadImage(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  word.imageBytes = snapshot.data!;
                  return Flexible(
                    child: Image.memory(
                      snapshot.data!,
                      width: 100, // Adjust the width and height as needed
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        if (kDebugMode) {
                          print('Error loading image: $error');
                        }
                        return const Icon(Icons.error);
                      },
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          const SizedBox(height: 8),
          Flexible(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi), // Always rotate text in level 2
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  word.text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  // Minimum font size
                  maxLines: 1, // Display text in one line
                ),
              ),
            ),
          ),
        ],
      );
    }else {
      // For levels 1 and 3, keep original behavior without transformation
      if (word.displayText) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child:  Center(
            child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: Text(
              word.text!,
              style: const TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            ),
            ),
            ));
      } else {
        if (word.imageBytes != null) {
          return Image.memory(
            word.imageBytes!,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print('Error loading image: $error');
              }
              return const Icon(Icons.error);
            },
          );
        } else {
          return FutureBuilder<Uint8List>(
            future: _loadImage(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                word.imageBytes = snapshot.data!;
                return Image.memory(
                  snapshot.data!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    if (kDebugMode) {
                      print('Error loading image: $error');
                    }
                    return const Icon(Icons.error);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        }
      }
    }
  }

  Future<Uint8List> _loadImage(BuildContext context) async {
    try {
      String base64Image = word.url!;
      return base64Decode(base64Image);
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding image: $e');
      }
      rethrow;
    }
  }

  bool checkAnimationRun(GameManager notifier) {
    bool animate = false;

    if (notifier.canFlip) {
      if (notifier.tappedWords.isNotEmpty && notifier.tappedWords.keys.last == index) {
        animate = true;
      }
      if (notifier.reverseFlip && !notifier.answeredWords.contains(index)) {
        animate = true;
      }
    }
    return animate;
  }
}
