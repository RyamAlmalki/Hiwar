import 'package:chatapp/models/conversation.dart';
import 'package:chatapp/pages/home/message/message_widget/image_page.dart';
import 'package:flutter/material.dart';


import '../../../../models/message.dart';
import '../../../../shared/const.dart';


class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isMe, required this.conversation});
  final Message message;
  final bool isMe;
  final Conversation? conversation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, 
        children: [
          

          ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5,
              ),
              child: Material(
              color: isMe? message.type == 'text' ? bubbleColor : Colors.black : message.type == 'text' ? accentColor : Colors.black ,
              elevation: 0,
              borderRadius: message.type == 'text' ? BorderRadius.only( topLeft: !isMe ? const Radius.circular(0.0): const Radius.circular(30.0), bottomRight: const Radius.circular(30.0), bottomLeft: const Radius.circular(30.0), topRight:  isMe ? const Radius.circular(0.0): const Radius.circular(30.0)) : const BorderRadius.only( topLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              child: Padding(
                padding: message.type == 'text' ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0) : const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message.type == 'text' ? Text(
                    '${message.message}', 
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style:  TextStyle(color: isMe ? Colors.white: Colors.white, fontSize: 16),
                    ) : GestureDetector(
                      onTap: () {
                        // view full image
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Scaffold(
                              body: ImagePage(message: message, conversation: conversation),
                            );
                          },
                        );
                      },
                      child: Container(
                      width: MediaQuery.of(context).size.width,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage("${message.message}"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}