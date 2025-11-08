class AppRouteInfo {
  final String name;
  final String path;

  const AppRouteInfo({required this.name, required this.path});
}

class AppRoutes {
  // Splash Screen - Màn hình khởi động
  static const splash = AppRouteInfo(
    name: 'Splash_Page',
    path: '/',
  );

  // Landing Page - Màn hình đầu tiên cho người chưa đăng nhập
  static const landing = AppRouteInfo(
    name: 'Landing_Page',
    path: '/landing',
  );

  // Login Page - Màn hình đăng nhập
  static const AppRouteInfo login = AppRouteInfo(
    name: 'Login_Page',
    path: '/login',
  );

  // Register Page - Màn hình đăng ký
  static const AppRouteInfo register = AppRouteInfo(
    name: 'Register_Page',
    path: '/register',
  );

  // Chat Page - Màn hình chat
  static const AppRouteInfo chat = AppRouteInfo(
    name: 'Chat_Page',
    path: '/chat',
  );

  // Chat History Page - Màn hình lịch sử chat
  static const AppRouteInfo chat_history = AppRouteInfo(
      name: 'Chat_History_Page',
      path: '/chat_history'
  );

  // Danh sách tất cả routes
  static List<AppRouteInfo> get all => [
    splash,
    landing,
    login,
    register,
    chat,
    chat_history
  ];
}