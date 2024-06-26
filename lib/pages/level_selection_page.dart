import 'package:flutter/material.dart';
import 'package:memory_game/pages/sub_level_selection_page.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend background behind app bar
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 35, bottom: 20), // Reduce the top padding
          child: Text(
            'B03 - Memory Game',
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
                const Text(
                  'Select a main level',
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubLevelSelectionPage(mainLevel: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80), // Adjust button size for tablet
                    ),
                    child: const Text(
                      'Level 1',
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
                          builder: (context) => const SubLevelSelectionPage(mainLevel: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80), // Adjust button size for tablet
                    ),
                    child: const Text(
                      'Level 2',
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
                          builder: (context) => const SubLevelSelectionPage(mainLevel: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 80), // Adjust button size for tablet
                    ),
                    child: const Text(
                      'Level 3',
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
