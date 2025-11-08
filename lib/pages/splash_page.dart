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

  /// Kiểm tra trạng thái auth và navigate đến page phù hợp
  Future<void> _navigateToNextPage() async {
    // Đợi 2 giây để hiển thị splash screen
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    try {
      // Kiểm tra xem user đã đăng nhập hoặc đang dùng guest mode
      final isLoggedIn = await AuthManager.isLoggedIn();
      final isGuest = await AuthManager.isGuestMode();

      print('Splash Check - isLoggedIn: $isLoggedIn, isGuest: $isGuest');

      if (!mounted) return;

      if (isLoggedIn || isGuest) {
        // Đã đăng nhập hoặc đang dùng guest mode -> đi đến chat history
        print('Navigating to chat_history');
        context.go(AppRoutes.chat_history.path);
      } else {
        // Chưa đăng nhập và không phải guest -> đi đến landing page
        print('Navigating to landing');
        context.go(AppRoutes.landing.path);
      }
    } catch (e) {
      print('Error in splash navigation: $e');
      if (mounted) {
        // Nếu có lỗi, mặc định về landing page
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
            // Logo ở giữa màn hình
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
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
                  // App name (optional)
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
            // Loading indicator ở dưới
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Loading spinner
                    AppIcons.buildSpinningWidget(
                      child: AppIcons.LoadingIcon,
                    ),
                    const SizedBox(height: 12),
                    // Loading text
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
            // Version info (optional)
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