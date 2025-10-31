class AppRouteInfo {
  final String name;
  final String path;

  const AppRouteInfo({required this.name, required this.path});
}

class AppRoutes {
  static const splash = AppRouteInfo(
    name: 'Splash_Page',
    path: '/',
  );

  static const AppRouteInfo login = AppRouteInfo(
    name: 'Login Page',
    path: '/login',
  );

  static const AppRouteInfo chat = AppRouteInfo(
    name: 'Chat_Page',
    path: '/chat',
  );

  static const AppRouteInfo chat_history = AppRouteInfo(
      name: 'Chat_History_Page',
      path: '/chat_history'
  );

  // static const String userIdParam = 'userId';

  static List<AppRouteInfo> get all => [splash, login, chat, chat_history];
}