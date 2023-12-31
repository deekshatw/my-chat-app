// ignore_for_file: avoid_print

import 'package:my_chat_app/helper/helper_functions.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/views/chatrooms_screen.dart';
import 'package:my_chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final Function toggle;

  const SignUpScreen({super.key, required this.toggle});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController rePasswordTextEditingController =
      TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        'username': usernameTextEditingController.text,
        'email': emailTextEditingController.text
      };

      HelperFunctions.saveUsernameSharedPreference(
          usernameTextEditingController.text);

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpwithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        // print(value.userId);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        databaseMethods.uploadUserInfoToFirestore(userInfoMap);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ChatroomsScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 180),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return val!.isEmpty || val.length < 4
                                  ? 'Please provide a valid username'
                                  : null;
                            },
                            controller: usernameTextEditingController,
                            style: const TextStyle(color: Colors.white),
                            decoration: textFieldInputDecoration('Username'),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                      .hasMatch(val!)
                                  ? null
                                  : 'Please provide a valid email';
                            },
                            controller: emailTextEditingController,
                            style: const TextStyle(color: Colors.white),
                            decoration: textFieldInputDecoration('Email'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: (val) {
                              return val!.isEmpty || val.length < 6
                                  ? 'Please provide a valid password'
                                  : null;
                            },
                            controller: passwordTextEditingController,
                            style: const TextStyle(color: Colors.white),
                            decoration: textFieldInputDecoration('Password'),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            validator: (val) {
                              return val!.isEmpty ||
                                      rePasswordTextEditingController.text !=
                                          passwordTextEditingController.text
                                  ? 'Please enter same password twice'
                                  : null;
                            },
                            controller: rePasswordTextEditingController,
                            style: const TextStyle(color: Colors.white),
                            decoration: textFieldInputDecoration('Re-Password'),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          signMeUp();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xff145C9E),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                        child: const Text(
                          'Sign Up with Google',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.toggle();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
