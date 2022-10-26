import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool loading = false;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  bool _isObsecure = true;

  //text field state
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser?>(context);

    return StreamBuilder<UserDetails>(
      stream: DatabaseService(uid: user!.uid).userDetails,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserDetails? userDetails = snapshot.data;
          return Scaffold(
            backgroundColor: Color(0xff154c79),
            appBar: AppBar(
              backgroundColor: Color(0xff133957),
              title: Text('CHANGE PASSWORD'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      // TextFormField(
                      //   style: TextStyle(color: Color(0xffEDF2F4)),
                      //   // obscureText: _isObsecure,
                      //   validator: (value) => !(userDetails!.password == value)
                      //       ? 'Entered password is incorrect'
                      //       : null,
                      //   decoration: textInputDecoration.copyWith(
                      //     hintText: 'old password',
                      //     // suffixIcon: IconButton(
                      //     //   icon: Icon(Icons.remove_red_eye),
                      //     //   onPressed: () {
                      //     //     setState(() {
                      //     //       _isObsecure = !_isObsecure;
                      //     //     });
                      //     //   },
                      //     // ),
                      //   ),
                      //   onChanged: (val) {
                      //     setState(() {
                      //       oldPassword = val;
                      //     });
                      //   },
                      // ),
                      // SizedBox(height: 35.0),
                      TextFormField(
                        style: TextStyle(color: Color(0xffEDF2F4)),
                        obscureText: _isObsecure,
                        validator: (value) => value!.length < 6
                            ? 'Enter a password of 6 or more charactors long'
                            : null,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'new password',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                _isObsecure = !_isObsecure;
                              });
                            },
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            newPassword = val;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        style: TextStyle(color: Color(0xffEDF2F4)),
                        obscureText: _isObsecure,
                        validator: (value) => value != newPassword
                            ? 'Password Does Not Match'
                            : null,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'confirm new password',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                _isObsecure = !_isObsecure;
                              });
                            },
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            confirmPassword = val;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      Text(error,
                          style: TextStyle(
                            color: Colors.red,
                          )),
                      SizedBox(height: 35.0),
                      Container(
                        height: 55.0,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xffD90429))),
                          child: loading == true
                              ? CircularProgressIndicator(
                                  backgroundColor: Color(0xffD90429),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                )
                              : Text(
                                  'CHANGE PASSWORD',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              void _changePassword(String newpassword) async {
                                //Create an instance of the current user.
                                var user = FirebaseAuth.instance.currentUser!;

                                //Pass in the password to updatePassword.
                                user.updatePassword(newpassword).then((_) {
                                  print("Successfully changed password");
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .update({'password': newPassword});
                                  setState(() {
                                    loading = false;
                                    error = "Successfully changed password";
                                    oldPassword = '';
                                    newPassword = '';
                                    confirmPassword = '';
                                    _formKey.currentState!.reset();
                                  });

                                  return (Text('Password reset successful!'));
                                  // _passwordReset = '';
                                  // _passwordResetConfirm = '';
                                }).catchError((err) {
                                  print("Password can't be changed" +
                                      err.toString());
                                  error = "Password can't be changed" +
                                      err.toString();
                                  setState(() {
                                    loading = false;
                                    error =
                                        "Recent log-in required. Please logout and login and then try to change the password.";
                                  });

                                  return Text(
                                    "Password can't be changed" +
                                        err.toString(),
                                  );
                                  //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                                });
                              }

                              _changePassword(newPassword);
                              // Future.delayed(const Duration(milliseconds: 1000),
                              //     () {
                              //   setState(() {
                              //     oldPassword = '';
                              //     newPassword = '';
                              //     confirmPassword = '';
                              //   });
                              // });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
