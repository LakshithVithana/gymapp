import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgotPassword.dart';
import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key, this.toggleView}) : super(key: key);
  final Function? toggleView;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _isObsecure = true;

  //text field state
  String email = '';
  String password = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color(0xff154c79),
            appBar: AppBar(
              backgroundColor: const Color(0xff133957),
              title: Text(
                'LOG IN',
                style: GoogleFonts.baiJamjuree(
                  textStyle: Theme.of(context).textTheme.headline5,
                  color: Colors.white,
                ),
              ),
              actions: [
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('register'),
                  onPressed: () {
                    widget.toggleView!();
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      // Container(
                      //   height: 150.0,
                      //   child: Image.asset('assets/images/logo.png'),
                      // ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      TextFormField(
                        style: const TextStyle(color: Color(0xffEDF2F4)),
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter an Email' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        style: const TextStyle(color: Color(0xffEDF2F4)),
                        obscureText: _isObsecure,
                        validator: (value) => value!.length < 6
                            ? 'Enter a password of 6 or more charactors long'
                            : null,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObsecure = !_isObsecure;
                              });
                            },
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(height: 35.0),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 55.0,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffD90429),
                            ),
                          ),
                          child: const Text(
                            'LOG IN',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              userCollection
                                  .where('email', isEqualTo: email)
                                  .get()
                                  .then((userDoc) async {
                                if (userDoc.docs[0]['isDeleting'] == false) {
                                  setState(() => loading = true);
                                  // _auth.signOut();
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);

                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          'Can Not Log In With Those Credentials';
                                    });
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                    error =
                                        'Can Not Log In With Those Credentials';
                                  });
                                }
                              }).catchError((onError) {
                                setState(() {
                                  error =
                                      'Can Not Log In With Those Credentials';
                                });
                              });

                              // print('result user ' + result.uid);

                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextButton(
                        onPressed: () {
                          Get.to(() => ForgotPassword());
                        },
                        child: const Text(
                          'Forgot Password ?',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
