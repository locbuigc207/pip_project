import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/models/token_model.dart';
import 'package:pippips/routes/app_routes.dart';
import 'package:pippips/services/auth_service.dart';
import 'package:pippips/utils/auth_manager.dart';
import 'package:pippips/utils/colors.dart';
import 'package:pippips/utils/fonts.dart';
import 'package:pippips/utils/icons.dart';
import 'package:pippips/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        print(' Attempting login for: ${_emailController.text.trim()}');

        final result = await AuthService().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (result['success'] == true) {
          final userData = result['data'];
          final TokenModel token = result['token'];

          print(' Login successful');
          print('Token expires at: ${token.expiresAt}');
          print('Token needs refresh: ${token.needsRefresh}');

          final saveSuccess = await AuthManager.saveLoginData(
            userId: userData['id']?.toString() ??
                userData['_id']?.toString() ??
                'unknown',
            fullName: userData['name'] ?? userData['name'] ?? 'User',
            email: userData['identifier'] ?? _emailController.text.trim(),
            token: token,
            sessionId: userData['session_id'],
          );

          if (saveSuccess && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Đăng nhập thành công!',
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
                  'Có lỗi xảy ra khi lưu thông tin. Vui lòng thử lại.',
                  style: AppFonts.beVietnamRegular14.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          print(' Login failed: ${result['message']}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result['message'] ??
                      'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.',
                  style: AppFonts.beVietnamRegular14.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        print(' Login exception: $e');

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundMain,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: _isLoading
              ? null
              : () {
                  context.go(AppRoutes.landing.path);
                },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppIcons.PippipLogo,
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    'Đăng nhập',
                    style: AppFonts.beVietnamBold20.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chào mừng bạn trở lại!',
                    style: AppFonts.beVietnamRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'identifier',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.textSecondary,
                    ),
                    validator: _validateEmail,
                    borderColor: AppColors.greyBorder,
                    fillColor: AppColors.textBoxBackground,
                    filled: true,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Mật khẩu',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: _validatePassword,
                    borderColor: AppColors.greyBorder,
                    fillColor: AppColors.textBoxBackground,
                    filled: true,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
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
                              'Đăng nhập',
                              style: AppFonts.robotoMedium16.copyWith(
                                color: AppColors.textWhite,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn chưa có tài khoản? ',
                        style: AppFonts.beVietnamRegular14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                context.push(AppRoutes.register.path);
                              },
                        child: Text(
                          'Đăng ký',
                          style: AppFonts.beVietnamMedium14.copyWith(
                            color: _isLoading
                                ? AppColors.textSecondary
                                : AppColors.deliveredStatus,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
