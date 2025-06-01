import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liverify_disease_detection/res/my_colors.dart';

import 'generative_model_view_model.dart';

class ChatView extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

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
        backgroundColor: Colors.teal, // Adjusted color
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
                      child: Text(
                        chatMessages[index],
                        style: TextStyle(
                          color: isUserMessage ? Colors.black : Colors.black,
                        ),
                      ),
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
                        //fillColor: LightBlue,
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
}
