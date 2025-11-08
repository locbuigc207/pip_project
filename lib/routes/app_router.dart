import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pippips/pages/ChatHistoryPage/chat_history_page.dart';
import 'package:pippips/pages/landing_page.dart';
import '../pages/ChatPage/chat_page.dart';
import '../pages/LoginPage/login_page.dart';
import '../pages/LoginPage/register_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash.path,
  routes: [
    GoRoute(
      path: AppRoutes.splash.path,
      name: AppRoutes.splash.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashPage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: _slideTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.landing.path,
      name: AppRoutes.landing.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LandingPage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: _slideTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.login.path,
      name: AppRoutes.login.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginPage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: _slideTransition,
      ),
    ),

    GoRoute(
      path: AppRoutes.register.path,
      name: AppRoutes.register.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterPage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: _slideTransition,
      ),
    ),

    ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.chat.path,
            name: AppRoutes.chat.name,
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;

              final int? totalConv = extra?['totalConv'] as int?;
              final String? conversationId = extra?['conversationId'] as String?;
              final String? quoteCode = extra?['quoteCode'] as String?;

              return CustomTransitionPage(
                key: state.pageKey,
                child: ChatPage(
                  totalConv: totalConv!,
                  conversationId: conversationId,
                  quoteCode: quoteCode,
                ),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder: _slideTransition,
              );
            },
          ),

          GoRoute(
              path: AppRoutes.chat_history.path,
              name: AppRoutes.chat_history.name,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final String? prevPage = extra?['prevPage'] as String?;

                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ChatHistoryPage(
                    prevPage: prevPage,
                  ),
                  transitionDuration: const Duration(milliseconds: 400),
                  transitionsBuilder: _slideTransition,
                );
              }
          )
        ]
    )

  ],
);

Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    ) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  );

  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(curvedAnimation),
    child: child,
  );
}