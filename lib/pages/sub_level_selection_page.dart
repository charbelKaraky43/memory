import 'package:flutter/material.dart';
import 'package:memory_game/pages/game_page.dart';

class SubLevelSelectionPage extends StatelessWidget {
  final int mainLevel;

  const SubLevelSelectionPage({Key? key, required this.mainLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend background behind app bar
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 35, bottom: 20), // Reduce the top padding
          child: Text(
            'Select Difficulty',
            style: TextStyle(
              fontSize: 50, // Reduce the font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Cloud.png',
            fit: BoxFit.cover, // Cover the entire screen
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Add space between title and select level
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(mainLevel: mainLevel, difficulty: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80), // Adjust button size for tablet
                    ),
                    child: const Text(
                      'Easy',
                      style: TextStyle(fontSize: 52), // Increase font size
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(mainLevel: mainLevel, difficulty: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80), // Adjust button size for tablet
                    ),
                    child: const Text(
                      'Medium',
                      style: TextStyle(fontSize: 52), // Increase font size
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(mainLevel: mainLevel, difficulty: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80), // Adjust button size for tablet
                    ),
                    child: const Text(
                      'Hard',
                      style: TextStyle(fontSize: 52), // Increase font size
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
