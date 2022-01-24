import 'package:notes_firebase_app/components/facebook_sign_in_button.dart';
import 'package:notes_firebase_app/data/models/app_state_manager.dart';
import 'package:notes_firebase_app/data/models/auth_manager.dart';
import 'package:notes_firebase_app/data/models/notes_pages.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/components/google_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: NotesPages.loginPath,
      key: ValueKey(NotesPages.loginPath),
      child: const LoginScreen(),
    );
  }

  final String? username;

  const LoginScreen({
    Key? key,
    this.username,
  }) : super(key: key);

  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);
  final TextStyle focusedStyle = const TextStyle(color: Colors.green);
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
                child: Image(
                  image: AssetImage(
                    'assets/notes.png',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              buildTextfield(username ?? '🍔 username'),
              const SizedBox(height: 16),
              buildTextfield('🎹 password'),
              const SizedBox(height: 16),
              buildButton(context),
              const SizedBox(height: 16),
              googleSignInButton(context),
              facebookSignInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget googleSignInButton(BuildContext context) {
    return FutureBuilder(
      future: AuthManager.initializeFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error initializing Firebase');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return const GoogleSignInButton();
        }
        return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.blueGrey,
          ),
        );
      },
    );
  }

  Widget facebookSignInButton(BuildContext context) {
    return FutureBuilder(
      future: AuthManager.initializeFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error initializing Firebase');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return const FacebookSignInButton();
        }
        return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.blueGrey,
          ),
        );
      },
    );
  }

  Widget buildButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: rwColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          Provider.of<AppStateManager>(context, listen: false)
              .login('mockUsername', 'mockPassword');
        },
      ),
    );
  }

  Widget buildTextfield(String hintText) {
    return TextField(
      cursorColor: rwColor,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(height: 0.5),
      ),
    );
  }
}
