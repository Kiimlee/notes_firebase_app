import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/models.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:notes_firebase_app/screens/screens.dart';
import 'app_link.dart';

class AppRouter extends RouterDelegate<AppLink>
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

// 1
  @override
  Future<void> setNewRoutePath(AppLink newLink) async {
    // 2
    switch (newLink.location) {
      // 3
      case AppLink.profilePath:
        profileManager.tapOnProfile(true);
        break;
      // 4
      //     case AppLink.task:
      // // 5
      // final itemId = newLink.itemId;
      // if (itemId != null) {
      //   task;
      // } else {
      //   // 6
      //   groceryManager.createNewItem();
      // }
      // 7
      // profileManager.tapOnProfile(false);
      // break;

      case AppLink.homePath:
        // 9
        appStateManager.goToTab(newLink.currentTab ?? 0);
        // 10
        profileManager.tapOnProfile(false);
        break;
      // 11
      default:
        break;
    }
  }

  @override
  AppLink get currentConfiguration => getCurrentPath();

  AppLink getCurrentPath() {
    // 1
    if (!appStateManager.isLoggedIn) {
      return AppLink(location: AppLink.loginPath);
      // 2
    } else if (!appStateManager.isOnboardingComplete) {
      return AppLink(location: AppLink.onboardingPath);
      // 3
    } else if (profileManager.didSelectUser) {
      return AppLink(location: AppLink.profilePath);
      // 4
    } else {
      return AppLink(
          location: AppLink.homePath,
          currentTab: appStateManager.getSelectedTab);
    }
  }
}
