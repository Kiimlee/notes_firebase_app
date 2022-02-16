import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/app_state_manager.dart';
import 'package:notes_firebase_app/data/models/auth_manager.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:notes_firebase_app/data/models/note_user.dart';
import 'package:provider/provider.dart';

class FacebookSignInButton extends StatefulWidget {
  const FacebookSignInButton({Key? key}) : super(key: key);

  @override
  _FacebookSignInButtonState createState() => _FacebookSignInButtonState();
}

class _FacebookSignInButtonState extends State<FacebookSignInButton> {
  bool _isSigningIn = false;
  final SharedPreferencesManager preferencesManager =
      SharedPreferencesManager();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                User? user =
                    await AuthManager.signInWithFacebook(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  final NoteUser newUser = NoteUser(
                      displayName: user.displayName!,
                      email: user.email ?? '',
                      profileImageUrl: user.photoURL!,
                      darkMode: false);
                  preferencesManager.saveUser(newUser);

                  Provider.of<AppStateManager>(context, listen: false)
                      .login('mockUsername', 'mockPassword');
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Image(
                      image: AssetImage("assets/facebook_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Se connecter avec META',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
