import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/models.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:notes_firebase_app/screens/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;

  final NotesManager notesManager;

  final ProfileManager profileManager;

  final SharedPreferencesManager sharedPreferencesManager;

  AppRouter({
    required this.appStateManager,
    required this.notesManager,
    required this.profileManager,
    required this.sharedPreferencesManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    notesManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
    sharedPreferencesManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    notesManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    sharedPreferencesManager.removeListener(notifyListeners);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == NotesPages.onboardingPath) {
      appStateManager.logout();
    }

    if (route.settings.name == NotesPages.raywenderlich) {
      profileManager.tapOnProfile(false);
    }

    if (route.settings.name == NotesPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
