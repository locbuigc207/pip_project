import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pippips/routes/app_routes.dart';
import 'package:pippips/services/auth_service.dart';
import 'package:pippips/utils/auth_manager.dart';
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
  String? avatarPath;
  bool isLoading = true;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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
          userName = userData['name'] ?? '';
          userEmail = userData['identifier'] ?? '';
          avatarPath = userData['avatar'];
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          userName = '';
          userEmail = '';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        avatarPath = picked.path;
      });
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

      if (isGuest) {
        await AuthManager.logout();
      } else {
        final result = await AuthService().logout();
        if (result['success'] != true) {
          print('Logout API returned error, continuing anyway');
        }
      }

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

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

      await Future.delayed(const Duration(milliseconds: 300));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go(AppRoutes.splash.path);
      });
    } catch (e) {
      print('Error during logout: $e');
      if (!mounted) return;
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
        side: BorderSide(color: AppColors.greyBorder, width: 1),
      ),
      color: AppColors.backgroundMain,
      elevation: 8,
      padding: EdgeInsets.zero,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isGuest
              ? AppColors.greyBorder.withOpacity(0.4)
              : Colors.transparent,
          border: isGuest
              ? null
              : Border.all(color: AppColors.greyBorder, width: 1),
          image: (!isGuest && avatarPath != null)
              ? DecorationImage(
                  image: FileImage(File(avatarPath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: (isGuest || avatarPath == null)
            ? Icon(
                Icons.person,
                size: 28,
                color: isGuest
                    ? AppColors.textSecondary.withOpacity(0.7)
                    : AppColors.textPrimary,
              )
            : null,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          enabled: false,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: isGuest ? null : _pickAvatar,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isGuest
                              ? AppColors.greyBorder.withOpacity(0.3)
                              : null,
                          backgroundImage: (!isGuest && avatarPath != null)
                              ? FileImage(File(avatarPath!))
                              : null,
                          child: (isGuest || avatarPath == null)
                              ? Icon(
                                  Icons.person,
                                  color:
                                      AppColors.textSecondary.withOpacity(0.8),
                                  size: 28,
                                )
                              : null,
                        ),
                        if (!isGuest)
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundMain,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                      ],
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
                                        ? AppColors.textSecondary
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
