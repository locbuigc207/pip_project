import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/utils/auth_manager.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';
import 'package:pippips/utils/icons.dart';
import 'package:pippips/utils/prompts.dart';
import '../../routes/app_routes.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    try {
      final isLoggedIn = await AuthManager.isLoggedIn();
      final isGuest = await AuthManager.isGuestMode();

      print('Splash Check - isLoggedIn: $isLoggedIn, isGuest: $isGuest');

      if (!mounted) return;

      if (isLoggedIn || isGuest) {
        print('Navigating to chat_history');
        context.go(AppRoutes.chat_history.path);
      } else {
        print('Navigating to landing');
        context.go(AppRoutes.landing.path);
      }
    } catch (e) {
      print('Error in splash navigation: $e');
      if (mounted) {
        context.go(AppRoutes.landing.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppColors.backgroundMain,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.5,
                    height: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppIcons.PippipLogo,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PIPPIP',
                    style: AppFonts.beVietnamBold20.copyWith(
                      color: AppColors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.buildSpinningWidget(
                      child: AppIcons.LoadingIcon,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppPrompts.loading,
                      style: AppFonts.beVietnamRegular14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Version 1.0.0',
                  style: AppFonts.beVietnamRegular12.copyWith(
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}