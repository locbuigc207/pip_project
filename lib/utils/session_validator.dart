import 'dart:async';
import 'package:pippips/services/auth_service.dart';
import 'package:pippips/utils/auth_manager.dart';

class SessionValidator {
  static final SessionValidator _instance = SessionValidator._internal();
  factory SessionValidator() => _instance;

  SessionValidator._internal();

  Timer? _validationTimer;
  Timer? _updateTimer;
  bool _isRunning = false;

  static const Duration _validationInterval = Duration(minutes: 5);
  static const Duration _updateInterval = Duration(minutes: 1);


  void start() {
    if (_isRunning) {
      print(' Session validator already running');
      return;
    }

    print(' Starting session validator...');
    _isRunning = true;

    _validationTimer = Timer.periodic(_validationInterval, (_) {
      _validateSession();
    });

    _updateTimer = Timer.periodic(_updateInterval, (_) {
      _updateSession();
    });

    _validateSession();

    print(' Session validator started');
  }

  void stop() {
    if (!_isRunning) {
      return;
    }

    print(' Stopping session validator...');

    _validationTimer?.cancel();
    _updateTimer?.cancel();
    _validationTimer = null;
    _updateTimer = null;
    _isRunning = false;

    print(' Session validator stopped');
  }


  Future<void> _validateSession() async {
    try {
      final isLoggedIn = await AuthManager.isLoggedIn();
      final isGuest = await AuthManager.isGuestMode();

      if (!isLoggedIn || isGuest) {
        return;
      }

      print(' Validating session...');

      final hasValidToken = await AuthManager.isTokenValid();

      if (!hasValidToken) {
        print(' Token is invalid, attempting refresh...');

        final authService = AuthService();
        final refreshResult = await authService.refreshToken();

        if (refreshResult['success'] != true) {
          print(' Token refresh failed during validation');
          await _handleInvalidSession();
          return;
        }

        print(' Token refreshed during validation');
      }

      final authService = AuthService();
      final verifyResult = await authService.verifySession();

      if (verifyResult['success'] == true &&
          verifyResult['is_valid'] == true) {
        print(' Session is valid');
      } else {
        print(' Session verification failed');
        await _handleInvalidSession();
      }
    } catch (e) {
      print(' Session validation error: $e');
    }
  }

  Future<void> _updateSession() async {
    try {
      final isLoggedIn = await AuthManager.isLoggedIn();
      final isGuest = await AuthManager.isGuestMode();

      if (!isLoggedIn || isGuest) {
        return;
      }

      final needsRefresh = await AuthManager.needsTokenRefresh();

      if (needsRefresh) {
        print(' Token needs refresh during update...');

        final authService = AuthService();
        final refreshResult = await authService.refreshToken();

        if (refreshResult['success'] != true) {
          print(' Token refresh failed during update');
          return;
        }

        print(' Token refreshed during update');
      }

      final authService = AuthService();
      final updateResult = await authService.updateSession();

      if (updateResult['success'] == true) {
        print(' Session heartbeat sent');
      } else {
        print(' Session update failed');
      }
    } catch (e) {
      print(' Session update error: $e');
    }
  }


  Future<void> _handleInvalidSession() async {
    print(' Handling invalid session...');

    stop();

    await AuthManager.logout();

    print(' User logged out due to invalid session');
    print(' App should navigate to login page');

  }


  bool get isRunning => _isRunning;

  Duration get validationInterval => _validationInterval;

  Duration get updateInterval => _updateInterval;
}