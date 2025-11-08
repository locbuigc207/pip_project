import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/routes/app_routes.dart';
import 'package:pippips/utils/auth_manager.dart';
import 'package:pippips/utils/boxChat.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';

class UserMenuWidget extends StatefulWidget {
  const UserMenuWidget({super.key});

  @override
  State<UserMenuWidget> createState() => _UserMenuWidgetState();
}

class _UserMenuWidgetState extends State<UserMenuWidget> {
  String userName = '';
  String userEmail = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await AuthManager.getUserData();
      if (userData != null && mounted) {
        setState(() {
          userName = userData['full_name'] ?? 'User';
          userEmail = userData['email'] ?? '';
          isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          userName = 'User';
          userEmail = 'user@example.com';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          userName = 'User';
          userEmail = '';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundMain,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Đăng xuất',
              style: AppFonts.beVietnamSemiBold16.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
          style: AppFonts.beVietnamRegular14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Hủy',
              style: AppFonts.beVietnamMedium14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.error.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Đăng xuất',
              style: AppFonts.beVietnamMedium14.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        // Hiển thị loading
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMain,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đang đăng xuất...',
                      style: AppFonts.beVietnamRegular14.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Đăng xuất và xóa dữ liệu
        await AuthManager.logout();

        // Có thể xóa luôn dữ liệu chat nếu muốn
        // await AppBoxChat.clearSpecificBox('conversationBox');

        // Đóng loading dialog
        if (mounted) {
          Navigator.of(context).pop();

          // Hiển thị thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Đã đăng xuất thành công',
                style: AppFonts.beVietnamRegular14.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );

          // Chuyển về trang login
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            context.go(AppRoutes.login.path);
          }
        }
      } catch (e) {
        print('Error during logout: $e');
        if (mounted) {
          // Đóng loading dialog nếu có lỗi
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Có lỗi xảy ra khi đăng xuất. Vui lòng thử lại.',
                style: AppFonts.beVietnamRegular14.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.greyBorder,
          width: 1,
        ),
      ),
      color: AppColors.backgroundMain,
      elevation: 8,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.greyBorder,
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.account_circle,
          size: 32,
          color: AppColors.textPrimary,
        ),
      ),
      itemBuilder: (BuildContext context) => [
        // User Info Header
        PopupMenuItem<String>(
          enabled: false,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.deliveredStatus.withOpacity(0.8),
                          AppColors.deliveredStatus,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deliveredStatus.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.textWhite,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          Container(
                            width: 100,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.greyBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        else
                          Text(
                            userName,
                            style: AppFonts.beVietnamSemiBold16.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        if (isLoading)
                          Container(
                            width: 140,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.greyBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        else if (userEmail.isNotEmpty)
                          Text(
                            userEmail,
                            style: AppFonts.beVietnamRegular12.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Divider(
                  color: AppColors.greyBorder,
                  height: 1,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        // Logout Button
        PopupMenuItem<String>(
          value: 'logout',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onTap: () {
            // Delay để menu đóng trước khi hiển thị dialog
            Future.delayed(
              const Duration(milliseconds: 100),
                  () => _handleLogout(),
            );
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.logout,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Đăng xuất',
                style: AppFonts.beVietnamMedium14.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}