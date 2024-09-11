import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';

class SendMessageBox extends StatelessWidget {
  final Function(String message) onTapSend;

  const SendMessageBox({
    super.key,
    required this.onTapSend,
  });

  @override
  Widget build(BuildContext context) {
    return MessageBar(
      messageBarHintText: "Napiši poruku",
      messageBarColor: const Color(0xffF4F6F9),
      messageBarHintStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w400),
      onSend: onTapSend,
    );
  }
}
