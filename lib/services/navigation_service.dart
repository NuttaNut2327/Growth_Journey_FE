import 'package:fe/routes/app_routes.dart';
import 'package:flutter/widgets.dart';

class AppNavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static bool _isRedirectingToLogin = false;

  static void redirectToLogin() {
    if (_isRedirectingToLogin) {
      return;
    }

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    _isRedirectingToLogin = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      _isRedirectingToLogin = false;
    });
  }
}
