import 'package:flutter/material.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MicroPhone extends StatefulWidget {
  final TextEditingController? controller;
  const MicroPhone({super.key, this.controller});

  @override
  State createState() => MicroPhoneState();
}

class MicroPhoneState extends State<MicroPhone> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _texts = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    if (_texts.isNotEmpty) {
      setState(() {
        widget.controller?.text = _texts;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _texts = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundMain, // màu nền chính
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.25),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   )
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _texts.isEmpty ? "Hãy nói gì đó..." : _texts,
            style: AppFonts.beVietnamMedium14.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _speechToText.isNotListening ? _startListening : _stopListening,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _speechToText.isNotListening
                    ? Colors.grey[700]
                    : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _speechToText.isNotListening
                ? "Nhấn để bắt đầu nói"
                : "Đang nghe...",
            style: AppFonts.beVietnamMedium14.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        ],
      ),
    );
  }
}
