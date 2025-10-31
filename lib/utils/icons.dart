import 'package:flutter/material.dart';

import 'colors.dart';

class AppIcons{

  static const String basePath =  'assets/icons/';

  static const Image PippipLogo = Image(image: AssetImage(basePath + 'logo_pippip.png'),);
  static const Image MenuIcon = Image(image: AssetImage(basePath + 'menu_icons.png'),
    width: 32, height: 32, color: AppColors.textPrimary,);
  static const Image NotFound = Image(image: AssetImage(basePath + 'not_found_dog.png'),
    width: 160, height: 160, color: AppColors.textPrimary,);
  static const Icon SendMessage = Icon(Icons.send, size: 26, color: AppColors.textPrimary,);
  static const Icon TalkMessage = Icon(Icons.mic_none, size: 26, color: AppColors.textPrimary,);
  static const Icon GoBackIcon = Icon(Icons.arrow_back, size: 26, color: AppColors.textPrimary);
  static Transform LoadingIcon = Transform(
    alignment: Alignment.center,
    transform: Matrix4.rotationY(3.1416),
    child: const Icon(Icons.sync, size: 24, color: AppColors.textSecondary),
  );
  static const Icon UserIcon = Icon(Icons.account_circle, size: 32, color: AppColors.textPrimary,);
  static const Icon MessageIcon = Icon(Icons.messenger_outline, size: 24, color: AppColors.textPrimary,);


  //path
  static const String PippipLogo_Path = basePath + 'logo_pippip.png';

  //Cho animation quay vong
  static Widget buildSpinningWidget({
    required Widget child,
    bool backWard = false,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _SpinningWidget(
      child: child,
      duration: duration,
      backWard: backWard,
    );
  }
}

//widget quay vong tron
class _SpinningWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool backWard;
  const _SpinningWidget({
    Key? key,
    required this.child,
    required this.duration,
    this.backWard = false,
  }) : super(key: key);

  @override
  State<_SpinningWidget> createState() => _SpinningWidgetState();
}

class _SpinningWidgetState extends State<_SpinningWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(); // Lặp vô hạn
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: (widget.backWard)? Tween(begin: 0.0, end: -1.0).animate(_controller) : _controller,
      child: widget.child,
    );
  }
}