import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memory_game/animation/confetti_animation.dart';
import 'package:memory_game/components/replay_popup.dart';
import 'package:memory_game/components/word_tile.dart';
import 'package:memory_game/main.dart';
import 'package:memory_game/managers/game_manager.dart';
import 'package:memory_game/models/word.dart';
import 'package:memory_game/pages/error_page.dart';
import 'package:memory_game/pages/loading_page.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  final int mainLevel;
  final int difficulty;

  const GamePage({Key? key, required this.mainLevel, required this.difficulty})
      : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final _futureCachedImages;
  final List<Word> _gridWords = [];
  late int _currentMainLevel = widget.mainLevel;
  late int _currentDifficulty = widget.difficulty;
  late int _totalPairs;

  @override
  void initState() {
    _futureCachedImages = _cacheImages();
    _totalPairs = _getLevelSettings().rows * _getLevelSettings().columns;
    final gameManager = Provider.of<GameManager>(context, listen: false);
    gameManager.totalPairs = _totalPairs;
    _setUp(_getLevelSettings());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * 0.10;
    return FutureBuilder(
      future: _futureCachedImages,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorPage();
        }
        if (snapshot.hasData) {
          return Selector<GameManager, bool>(
            selector: (_, gameManager) =>
            gameManager.roundCompleted ||
                gameManager.answeredWords.length == _totalPairs,
            builder: (_, __, ___) {
              final gameManager = Provider.of<GameManager>(context);
              final roundCompleted = gameManager.roundCompleted ||
                  gameManager.answeredWords.length == _totalPairs;

              WidgetsBinding.instance!.addPostFrameCallback(
                    (timeStamp) async {
                  if (roundCompleted ||
                      gameManager.answeredWords.length == _totalPairs) {
                    await showDialog(
                      barrierColor: Colors.transparent,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => const ReplayPopUp(),
                    );
                  }
                },
              );

              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/Cloud.png'),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          left: widthPadding,
                          right: widthPadding,
                        ),
                        itemCount: _gridWords.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getLevelSettings().columns,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: _getMainAxisExtent(),
                        ),
                        itemBuilder: (context, index) => WordTile(
                          index: index,
                          word: _gridWords[index],
                          currentLevel: _currentMainLevel
                        ),
                      ),
                    ),
                  ),
                  ConfettiAnimation(animate: roundCompleted),
                ],
              );
            },
          );
        } else {
          return const LoadingPage();
        }
      },
    );
  }

  void _setUp(LevelSettings levelSettings) {
    Set<String> uniqueTextImageCombos = {};
    List<Word> uniqueWords = [];

    for (var word in sourceWords) {
      String textImageCombo = '${word.text}_${word.url}';

      if (!uniqueTextImageCombos.contains(textImageCombo)) {
        uniqueTextImageCombos.add(textImageCombo);
        uniqueWords.add(word);
      }
    }
    uniqueWords.shuffle();
    _gridWords.clear();

    int totalWords = levelSettings.rows * levelSettings.columns;
    switch(_currentMainLevel){
      case 1:
        for (int i = 0; i < totalWords ~/ 2; i++) {
          _gridWords.add(Word(
            text: uniqueWords[i].text,
            url: uniqueWords[i].url,
            displayText: false,
          ));

          _gridWords.add(Word(
            text: uniqueWords[i].text,
            url: uniqueWords[i].url,
            displayText: false,
          ));
        }

        _gridWords.shuffle();
        break;

      case 2:
        for (int i = 0; i < totalWords ~/ 2; i++) {
          _gridWords.add(Word(
            text: uniqueWords[i].text,
            url: uniqueWords[i].url,
            displayText: true,
          ));

          _gridWords.add(Word(
            text: uniqueWords[i].text,
            url: uniqueWords[i].url,
            displayText: true,
          ));
        }
        _gridWords.shuffle();
        break;
      case 3:
        for (int i = 0; i < totalWords ~/ 2; i++) {
          _gridWords.add(Word(
            text: uniqueWords[i].text,
            displayText: true,
          ));

          _gridWords.add(Word(
            text: uniqueWords[i].text,
            url: uniqueWords[i].url,
            displayText: false,
          ));
        }
        _gridWords.shuffle();
        break;
    }
  }

  Future<int> _cacheImages() async {
    for (var w in _gridWords) {
      if (!w.displayText && w.url != null) {
        try {
          String base64Image = w.url!;
          Uint8List bytes = base64Decode(base64Image);
          w.imageBytes = bytes;
        } catch (e) {
          if (kDebugMode) {
            print('Error decoding image: $e');
          }
        }
      }
    }

    return Future.value(1);
  }

  double _getMainAxisExtent() {
    final screenHeight = MediaQuery.of(context).size.height;
    if (_currentDifficulty == 3 || _currentDifficulty == 2) {
      return screenHeight * 0.3;
    } else {
      final size = MediaQuery.of(context).size;
      return size.height * 0.38;
    }
  }

  LevelSettings _getLevelSettings() {
    switch (_currentDifficulty) {
      case 1:
        return LevelSettings(rows: 2, columns: 3);
      case 2:
        return LevelSettings(rows: 3, columns: 4);
      case 3:
        return LevelSettings(rows: 3, columns: 6);
      default:
        return LevelSettings(rows: 2, columns: 3);
    }
  }
}