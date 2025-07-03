import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';

import 'generative_model_view_model.dart';

class ChatView extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  ChatView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMessages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image(height: 30.h, image: AssetImage('assets/ai_icon.png')),
            SizedBox(width: 10.w),
            Text(
              'Ai Doctor',
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay-VariableFont_wght',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: whiteColor,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final isUserMessage = chatMessages[index].startsWith("You:");
                  return Align(
                    alignment:
                        isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUserMessage
                                ? Colors.lightBlue[100]
                                : Colors.deepPurple[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: buildStyledMessage(chatMessages[index]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.chat),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Type your message here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          ref
                              .read(chatProvider.notifier)
                              .sendMessage(_controller.text);
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Main formatter for Gemini's response
  Widget buildStyledMessage(String message) {
    if (message.startsWith("You:")) {
      return Text(message, style: TextStyle(fontSize: 15, color: Colors.black));
    }

    List<InlineSpan> spans = [];
    List<String> lines = message.split('\n');

    for (String line in lines) {
      if (line.trim().isEmpty) {
        spans.add(TextSpan(text: '\n'));
        continue;
      }

      // Headings like ## Treatment
      if (line.trim().startsWith('##')) {
        final headingText = line.trim().replaceFirst('##', '').trim();
        spans.add(
          TextSpan(
            text: '$headingText\n\n',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          ),
        );
      }
      // Bullet points like * **Topic:** Description
      else if (line.trim().startsWith('*') ||
          line.trim().startsWith('-') ||
          line.trim().startsWith('•')) {
        String bulletText =
            line.trim().replaceFirst(RegExp(r'[*\-•]'), '').trim();

        final RegExp boldPrefix = RegExp(r'^\*\*(.*?):\*\*');
        final match = boldPrefix.firstMatch(bulletText);

        if (match != null) {
          String bold = match.group(1)!;
          String rest = bulletText.replaceFirst(boldPrefix, '').trim();

          spans.add(
            TextSpan(
              children: [
                TextSpan(
                  text: '• ',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                TextSpan(
                  text: '$bold: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '$rest\n',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: '• $bulletText\n',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          );
        }
      }
      // Paragraph with possible inline **bold**
      else {
        final parts = line.split(RegExp(r'(\*\*[^*]+\*\*)'));
        for (var part in parts) {
          if (part.startsWith('**') && part.endsWith('**')) {
            spans.add(
              TextSpan(
                text: part.substring(2, part.length - 2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            );
          } else {
            spans.add(
              TextSpan(
                text: part,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            );
          }
        }
        spans.add(TextSpan(text: '\n\n'));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
      textAlign: TextAlign.start,
    );
  }
}
