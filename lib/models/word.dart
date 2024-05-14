import 'dart:typed_data';

class Word {
  final String text;
  final String? url; // Store base64-encoded image data
  final bool displayText;
  Uint8List? imageBytes; // Store decoded image bytes

  Word({
    required this.text,
    this.url,
    required this.displayText,
  });
}
/*   - word.dart: This file defines the `Word` model class,
 representing individual words used in the game.
 It includes properties such as the word's text, image URL,
 and whether the text should be displayed.*/