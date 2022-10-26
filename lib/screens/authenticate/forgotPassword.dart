import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'confirmEmail.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';
  final String message =
      "An email has just been sent to you, Click the link provided to complete password reset";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  String? _email;
  String error = '';

  _passwordReset() async {
    try {
      _formKey.currentState!.save();
      final user = await _auth.sendPasswordResetEmail(email: _email!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ConfirEmail(
            message: widget.message,
          );
        }),
      );
    } catch (e) {
      print(e);
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff154c79),
      appBar: AppBar(
        title: Text(
          'PASSWORD RESET',
          style: GoogleFonts.baiJamjuree(
            textStyle: Theme.of(context).textTheme.headline5,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff133957),
        // actions: [
        //   TextButton.icon(
        //     icon: Icon(Icons.person),
        //     label: Text('register'),
        //     onPressed: () {
        //       Get.to(() => Register());
        //     },
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 150.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Email',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      onSaved: (newEmail) {
                        _email = newEmail;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(
                          Icons.mail,
                          color: Color(0xffD90429),
                        ),
                        errorStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        child: Text(
                          'Send Reset Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _passwordReset();
                          print(_email);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffD90429)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
