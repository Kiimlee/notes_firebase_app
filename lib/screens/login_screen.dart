import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_firebase_app/components/facebook_sign_in_button.dart';
import 'package:notes_firebase_app/data/models/auth_manager.dart';
import 'package:notes_firebase_app/data/models/models.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/components/google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: NotesPages.loginPath,
      key: ValueKey(NotesPages.loginPath),
      child: const LoginScreen(),
    );
  }

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SharedPreferencesManager preferencesManager =
      SharedPreferencesManager();

  bool _isSigningIn = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Color rwColor = const Color.fromRGBO(64, 143, 77, 1);
  final TextStyle focusedStyle = const TextStyle(color: Colors.green);
  final TextStyle unfocusedStyle = const TextStyle(color: Colors.grey);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // 4
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              buildTextfield('🍔 username', false),
              const SizedBox(height: 16),
              buildTextfield('🎹 password', true),
              const SizedBox(height: 16),
              signupButton(context),
              const SizedBox(height: 16),
              loginButton(context),
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

  Widget signupButton(BuildContext context) {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: rwColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Signup',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await AuthManager.signup(
              _emailController.text, _passwordController.text,
              context: context);
        },
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return _isSigningIn
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : SizedBox(
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
                setState(() {
                  _isSigningIn = true;
                });

                User? user = await AuthManager.signInWithEmailAndPassword(
                    _emailController.text, _passwordController.text,
                    context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  print(user);
                  final NoteUser newUser = NoteUser(
                      displayName: user.displayName,
                      email: user.email,
                      profileImageUrl: user.photoURL,
                      darkMode: false);
                  preferencesManager.saveUser(newUser);

                  Provider.of<AppStateManager>(context, listen: false)
                      .login('mockUsername', 'mockPassword');
                }
              },
            ),
          );
  }

  Widget buildTextfield(String hintText, bool isPassword) {
    return TextFormField(
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return hintText + ' Required';
        }
        return null;
      },
      obscureText: isPassword,
      autocorrect: false,
      keyboardType: isPassword
          ? TextInputType.emailAddress
          : TextInputType.visiblePassword,
      controller: isPassword ? _emailController : _passwordController,
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
