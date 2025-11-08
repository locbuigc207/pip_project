import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/routes/app_routes.dart';
import 'package:pippips/utils/auth_manager.dart';
import 'package:pippips/utils/boxChat.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';

/// UserMenuWidget - Widget hiển thị menu user ở góc phải màn hình
/// --------------------------------------------------------------
/// Features:
/// - Hiển thị thông tin user (tên, email)
/// - Icon khác nhau cho Guest (màu vàng) và User đã đăng ký (xanh)
/// - Chức năng logout/exit với logic đồng bộ SplashPage
class UserMenuWidget extends StatefulWidget {
  const UserMenuWidget({super.key});

  @override
  State<UserMenuWidget> createState() => _UserMenuWidgetState();
}

class _UserMenuWidgetState extends State<UserMenuWidget> {
  String userName = '';
  String userEmail = '';
  bool isLoading = true;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load thông tin user từ SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final guestMode = await AuthManager.isGuestMode();
      final userData = await AuthManager.getUserData();

      if (!mounted) return;

      setState(() {
        isGuest = guestMode;
        if (guestMode) {
          userName = 'Khách';
          userEmail = 'Chế độ khách vãng lai';
        } else if (userData != null) {
          userName = userData['full_name'] ?? 'User';
          userEmail = userData['email'] ?? '';
        } else {
          userName = 'User';
          userEmail = 'user@example.com';
        }
        isLoading = false;
      });
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

  /// Xử lý logout/exit - đồng bộ với SplashPage logic
  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundMain,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGuest ? Icons.exit_to_app : Icons.logout,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isGuest ? 'Thoát chế độ khách' : 'Đăng xuất',
                style: AppFonts.beVietnamSemiBold16.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          isGuest
              ? 'Lịch sử chat của bạn sẽ được lưu trên thiết bị này. Bạn có chắc muốn thoát?'
              : 'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
          style: AppFonts.beVietnamRegular14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
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
            ),
            child: Text(
              isGuest ? 'Thoát' : 'Đăng xuất',
              style: AppFonts.beVietnamMedium14.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    try {
      // Hiển thị loading dialog
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
                  const CircularProgressIndicator(color: AppColors.textPrimary),
                  const SizedBox(height: 16),
                  Text(
                    isGuest ? 'Đang thoát...' : 'Đang đăng xuất...',
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

      // Logout logic
      await AuthManager.logout();

      // Nếu là guest, có thể giữ lại chat local (hoặc xóa nếu muốn)
      if (isGuest) {
        // await AppBoxChat.clearSpecificBox('conversationBox'); // nếu muốn xóa
      }

      if (!mounted) return;

      // Đóng dialog loading
      Navigator.of(context, rootNavigator: true).pop();

      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isGuest ? 'Đã thoát chế độ khách' : 'Đăng xuất thành công',
            style: AppFonts.beVietnamRegular14.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 1),
        ),
      );

      // Chờ 300ms rồi điều hướng (đảm bảo GoRouter không bị lock)
      await Future.delayed(const Duration(milliseconds: 300));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go(AppRoutes.splash.path);
      });
    } catch (e) {
      print('Error during logout: $e');
      if (!mounted) return;

      // Đóng loading dialog nếu đang mở
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Có lỗi xảy ra khi đăng xuất. Vui lòng thử lại.',
            style: AppFonts.beVietnamRegular14.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
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
            color: isGuest ? AppColors.warning : AppColors.greyBorder,
            width: isGuest ? 2 : 1,
          ),
        ),
        child: Icon(
          isGuest ? Icons.person_off_outlined : Icons.account_circle,
          size: 32,
          color: isGuest ? AppColors.warning : AppColors.textPrimary,
        ),
      ),
      itemBuilder: (BuildContext context) => [
        // Header hiển thị thông tin người dùng
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
                        colors: isGuest
                            ? [
                          AppColors.warning.withOpacity(0.8),
                          AppColors.warning,
                        ]
                            : [
                          AppColors.deliveredStatus.withOpacity(0.8),
                          AppColors.deliveredStatus,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isGuest
                              ? AppColors.warning
                              : AppColors.deliveredStatus)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isGuest ? Icons.person_off : Icons.person,
                      color: AppColors.textWhite,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: isLoading
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 16,
                          color: AppColors.greyBorder,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 140,
                          height: 12,
                          color: AppColors.greyBorder,
                        ),
                      ],
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: AppFonts.beVietnamSemiBold16.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (userEmail.isNotEmpty)
                          Text(
                            userEmail,
                            style: AppFonts.beVietnamRegular12.copyWith(
                              color: isGuest
                                  ? AppColors.warning
                                  : AppColors.textSecondary,
                              fontStyle: isGuest
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: AppColors.greyBorder,
                height: 20,
                thickness: 1,
              ),
            ],
          ),
        ),

        // Logout / Exit option
        PopupMenuItem<String>(
          value: 'logout',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onTap: () {
            Future.delayed(const Duration(milliseconds: 150), () {
              _handleLogout();
            });
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isGuest ? Icons.exit_to_app : Icons.logout,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isGuest ? 'Thoát chế độ khách' : 'Đăng xuất',
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
