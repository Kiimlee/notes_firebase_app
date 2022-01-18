import 'package:flutter/material.dart';
import 'package:notes_firebase_app/components/circle_image.dart';
import 'package:notes_firebase_app/data/models/auth_manager.dart';
import 'package:notes_firebase_app/data/models/models.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:provider/provider.dart';

import '../components/circle_image.dart';

class ProfileScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: NotesPages.profilePath,
      key: ValueKey(NotesPages.profilePath),
      child: ProfileScreen(),
    );
  }

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedPreferencesManager preferencesManager =
      SharedPreferencesManager();
  late NoteUser user;

  //   @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Consumer<SharedPreferencesManager>(
  //         builder: (context, manager, child) {
  //       getPrefsNotes();
  //       return ListView.builder(
  //           padding: const EdgeInsets.only(top: 20.0),
  //           itemCount: prefsNotes.length,
  //           itemBuilder: (context, index) {
  //             return noteTile(context, prefsNotes[index]);
  //           });
  //     }),
  //   );
  // }

  void getProfile() async {
    final profile = await preferencesManager.getUser();
    user = profile!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Provider.of<ProfileManager>(context, listen: false)
                .tapOnProfile(false);
          },
        ),
      ),
      body: Consumer<SharedPreferencesManager>(
        builder: (context, manager, child) {
          getProfile();
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                buildProfile(),
                Expanded(
                  child: buildMenu(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildMenu() {
    return ListView(
      children: [
        buildDarkModeRow(),
        ListTile(
          title: Text(user.email),
        ),
        ListTile(
          title: const Text('View raywenderlich.com'),
          onTap: () {
            Provider.of<ProfileManager>(context, listen: false)
                .tapOnRaywenderlich(true);
          },
        ),
        ListTile(
          title: const Text('Log out'),
          onTap: () async {
            Provider.of<ProfileManager>(context, listen: false)
                .tapOnProfile(false);
            Provider.of<AppStateManager>(context, listen: false).logout();
            await AuthManager.signOut(context: context);
          },
        ),
        myFavoritesButton(),
      ],
    );
  }

  Widget myFavoritesButton() {
    return Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: MaterialButton(
          textColor: Colors.white,
          child: const Text('Ma liste de favoris'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.green,
          onPressed: () {
            Provider.of<AppStateManager>(context, listen: false)
                .goToFavorites();
          },
        ));
  }

  Widget buildDarkModeRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dark Mode'),
          Switch(
            value: user.darkMode,
            onChanged: (value) {
              Provider.of<ProfileManager>(context, listen: false).darkMode =
                  value;
            },
          )
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleImage(
          imageProvider: NetworkImage(user.profileImageUrl),
          imageRadius: 60.0,
        ),
        const SizedBox(height: 16.0),
        Text(
          user.displayName,
          style: const TextStyle(
            fontSize: 21,
          ),
        ),
      ],
    );
  }
}
