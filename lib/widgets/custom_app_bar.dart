import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/pages/splash_page.dart';
import 'package:pippips/routes/app_router.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';

import '../utils/icons.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leftscr, rightscr;
  final bool goBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.goBack = true,
    this.leftscr,
    this.rightscr
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State createState() => CustomAppBarState();
}


class CustomAppBarState extends State<CustomAppBar>{


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 80),
            child: Align(
              alignment: Alignment.centerLeft,
              child: (widget.goBack)? IconButton(
                onPressed: () => context.pop(),
                icon: AppIcons.GoBackIcon,
              ) : widget.leftscr,
            ),
          ),
          Center(
            child: Text(
              widget.title,
              style: AppFonts.beVietnamSemiBold16.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 80),
            child: Align(
              alignment: Alignment.centerRight,
              child: (widget.rightscr != null)? widget.rightscr : const SizedBox(),
            ),
          ),

        ],
      ),
    );
  }
}