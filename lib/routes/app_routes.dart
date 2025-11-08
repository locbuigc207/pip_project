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

  static const landing = AppRouteInfo(
    name: 'Landing_Page',
    path: '/landing',
  );

  static const AppRouteInfo login = AppRouteInfo(
    name: 'Login_Page',
    path: '/login',
  );

  static const AppRouteInfo register = AppRouteInfo(
    name: 'Register_Page',
    path: '/register',
  );

  static const AppRouteInfo chat = AppRouteInfo(
    name: 'Chat_Page',
    path: '/chat',
  );

  static const AppRouteInfo chat_history = AppRouteInfo(
      name: 'Chat_History_Page',
      path: '/chat_history'
  );

  static List<AppRouteInfo> get all => [
    splash,
    landing,
    login,
    register,
    chat,
    chat_history
  ];
}