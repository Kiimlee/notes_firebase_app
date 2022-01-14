import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:notes_firebase_app/notes_theme.dart';
import 'package:provider/provider.dart';
import 'package:notes_firebase_app/data/models/models.dart';
import 'navigation/app_route_parser.dart';
import 'navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const NoteFirebaseApp());
}

class NoteFirebaseApp extends StatefulWidget {
  const NoteFirebaseApp({Key? key}) : super(key: key);

  @override
  _NoteFirebaseAppState createState() => _NoteFirebaseAppState();
}

class _NoteFirebaseAppState extends State<NoteFirebaseApp> {
  final _appStateManager = AppStateManager();
  final _notesManager = NotesManager();
  final _profileManager = ProfileManager();
  final _preferencesManager = SharedPreferencesManager();
  final routeParser = AppRouteParser();
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      notesManager: _notesManager,
      profileManager: _profileManager,
      sharedPreferencesManager: _preferencesManager,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _notesManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _preferencesManager,
        )
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = NotesTheme.dark();
          } else {
            theme = NotesTheme.light();
          }

          return MaterialApp.router(
            theme: theme,
            title: 'Fooderlich',
            backButtonDispatcher: RootBackButtonDispatcher(),
            // 1
            routeInformationParser: routeParser,
            // 2
            routerDelegate: _appRouter,
          );
        },
      ),
    );
  }
}
