import 'package:flutter/material.dart';
import 'package:pippips/utils/icons.dart';

import '../../../utils/fonts.dart';

class ChatHistoryItem extends StatefulWidget{
  final String title;
  final VoidCallback? onTap;
  final bool hasRead;
  const ChatHistoryItem({
    super.key,
    required this.title,
    required this.onTap,
    this.hasRead = true
  });

  @override
  State createState() => ChatHistoryItemState();
}

class ChatHistoryItemState extends State<ChatHistoryItem>{

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            AppIcons.MessageIcon,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.title,
                style: AppFonts.beVietnamRegular14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            if(!widget.hasRead) Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ) else const SizedBox(width: 8,),
          ],
        ),
      )


    );
  }

}