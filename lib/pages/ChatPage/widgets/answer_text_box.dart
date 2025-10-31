import 'package:flutter/material.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/gradients.dart';
import '../../../utils/fonts.dart';

class AnswerTextBox extends StatefulWidget {
  final bool isHuman;
  final TextSpan? textSpan;
  final String text;
  final GestureTapCallback? onTap;
  const AnswerTextBox({
    super.key,
    this.isHuman = false,
    this.textSpan,
    this.onTap,
    required this.text,
  });

  @override
  State<StatefulWidget> createState() => AnswerTextBoxState();
}

class AnswerTextBoxState extends State<AnswerTextBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // từ dưới đi lên
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward(); // chạy animation ngay khi widget mount
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Align(
          alignment: (widget.isHuman)? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.7,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                // border: (!widget.isHuman)?  Border.all(color: AppColors.textPrimary, width: 1 ) : null,
                  borderRadius: BorderRadius.circular(8),
                  // gradient: widget.isHuman
                  //     ? AppGradients.TechnoStyle
                  //     : AppGradients.InstagramStyle,
                  color: widget.isHuman? AppColors.deliveredStatus : AppColors.textBoxBackground
              ),
              child: RichText(
                text: widget.textSpan ??
                    TextSpan(
                      text: widget.text,
                      style: AppFonts.beVietnamRegular16.copyWith(color:
                      widget.isHuman? AppColors.textWhite : ((widget.onTap == null)?AppColors.textPrimary : AppColors.deliveredStatus)),
                    ),
                textAlign: TextAlign.start,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          )
        )

      ),
    );
  }
}
