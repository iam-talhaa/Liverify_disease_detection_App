import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final generativeChatServiceProvider = Provider<GenerativeChatService>((ref) {
  return GenerativeChatService();
});

class GenerativeChatService {
  late final GenerativeModel model;
  late final ChatSession chat;

  GenerativeChatService() {
    final apiKey =
        'AIzaSyBQTFybVHoG9sAukKYEOXV4ARKF-Eq3vKM'; // Ensure to securely load the API key
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    chat = model.startChat();
  }

  Future<String> sendMessage(String message) async {
    var content = Content.text(message);
    var response = await chat.sendMessage(content);
    return response.text!;
  }
}
