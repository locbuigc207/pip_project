import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/routes/app_routes.dart';
import 'package:pippips/utils/auth_manager.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoading = false;

  Future<void> _handleBookNow() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthManager.enableGuestMode();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Chào mừng! Bạn đang sử dụng chế độ khách.',
              style: AppFonts.beVietnamRegular14.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go(AppRoutes.chat_history.path);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Không thể kích hoạt chế độ khách. Vui lòng thử lại.',
              style: AppFonts.beVietnamRegular14.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Có lỗi xảy ra: $e',
              style: AppFonts.beVietnamRegular14.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Tư vấn đặt xe',
                  style: AppFonts.beVietnamSemiBold16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    disabledBackgroundColor: AppColors.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.textWhite,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    'ĐẶT XE PIPPIP',
                    style: AppFonts.robotoMedium16.copyWith(
                      color: AppColors.textWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn đã có tài khoản? ',
                    style: AppFonts.beVietnamRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                      context.go(AppRoutes.login.path);
                    },
                    child: Text(
                      'Đăng nhập',
                      style: AppFonts.beVietnamMedium14.copyWith(
                        color: _isLoading
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}