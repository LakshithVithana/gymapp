import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/database.dart';
import '../../../shared/constants.dart';
import '../../../shared/loading.dart';

class ClubAdminRegister extends StatefulWidget {
  const ClubAdminRegister(
      {Key? key,
      this.firstName,
      this.lastName,
      this.club,
      // this.datOfBirth,
      // this.gender,
      this.email})
      : super(key: key);
  final String? firstName;
  final String? lastName;
  final String? club;
  // final String? datOfBirth;
  // final String? gender;
  final String? email;

  @override
  _ClubAdminRegisterState createState() => _ClubAdminRegisterState();
}

class _ClubAdminRegisterState extends State<ClubAdminRegister> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = 'test1234';
  String club = '';
  String firstName = '';
  String lastName = '';
  String? dateOfBirth;
  String gender = '';
  String confirmPassword = '';
  bool isUser = false;
  bool isCoach = false;
  bool isClubAdmin = true;
  bool isSuperAdmin = false;

  String? dropdownValue = 'Male';

  String error = '';

  // Gender _gender = Gender.male;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? passwordGenerator() {
      var rng = Random();
      int randomNumber = rng.nextInt(99999) + 99999;
      return randomNumber.toString();
    }

    showPassword(String? password) {
      return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 100,
            color: const Color(0xff133957),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Password for that account is $password'),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    sendEmail({email, String? randomPassword}) {
      String username = 'speakupemailing@gmail.com';
      String password = 'AbCd1234';

      // final smtpServer = gmail(username, password);
      // Use the SmtpServer class to configure an SMTP server:
      // final smtpServer =
      //     SmtpServer('smtp.gmail.com', username: username, password: password);
      // // See the named arguments of SmtpServer for further configuration
      // // options.

      // // Create our message.
      // final message = Message()
      //   ..from = Address(username, 'SpeakUp')
      //   ..recipients.add(email)
      //   ..subject = 'New Account Created'
      //   ..text = 'Your club has been created with your Club Admin Profile'
      //   ..html =
      //       "<h1>Successfully Created</h1>\n<p>Your password is.</p>\n<h3>$randomPassword<h3>\n<p>Please change the password when you log in. Because the 'Access Code' for the club is also same as the genarated Random Password $randomPassword.</p>";

      // try {
      //   setState(() {
      //     error = '';
      //   });
      //   final sendReport = send(message, smtpServer);
      //   print('Message sent: $sendReport');
      // } on MailerException catch (e) {
      //   print('Message not sent.');

      //   for (var p in e.problems) {
      //     print('Problem: ${p.code}: ${p.msg}');
      //   }
      // }
      print(randomPassword);
      showPassword(randomPassword);
      return randomPassword;
    }

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color(0xff154c79),
            appBar: AppBar(
              backgroundColor: const Color(0xff133957),
              title: const Text('HOME'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      TextFormField(
                        initialValue: widget.club,
                        style: const TextStyle(color: Color(0xffEDF2F4)),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a Club' : null,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'club',
                          labelText: 'club',
                        ),
                        onChanged: (val) {
                          setState(() {
                            club = val;
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        initialValue: widget.firstName,
                        style: const TextStyle(color: Color(0xffEDF2F4)),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter First Name' : null,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'first name',
                          labelText: 'first name',
                        ),
                        onChanged: (val) {
                          setState(() {
                            firstName = val;
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        initialValue: widget.lastName,
                        style: const TextStyle(color: Color(0xffEDF2F4)),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Last Name' : null,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'last name',
                          labelText: 'last name',
                        ),
                        onChanged: (val) {
                          setState(() {
                            lastName = val;
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      // TextFormField(
                      //   style: TextStyle(color: Color(0xffEDF2F4)),
                      //   decoration:
                      //       textInputDecoration.copyWith(hintText: 'date of birth'),
                      //   onChanged: (val) {
                      //     setState(() {
                      //       password = val;
                      //     });
                      //   },
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       ' Date of Birth',
                      //       style: TextStyle(
                      //         color: Color(0xff8d99ae),
                      //         fontSize: 16.0,
                      //       ),
                      //     ),
                      //     SizedBox(width: 20.0),
                      //     Text(
                      //       widget.datOfBirth ??
                      //           "${selectedDate.toLocal()}".split(' ')[0],
                      //       style: TextStyle(
                      //         color: Color(0xffEDF2F4),
                      //         fontSize: 18.0,
                      //       ),
                      //     ),
                      //     SizedBox(width: 10.0),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //           color: Color(0xff8D99AE),
                      //           borderRadius: BorderRadius.circular(5.0)),
                      //       child: IconButton(
                      //         icon: Icon(Icons.date_range, size: 30.0),
                      //         onPressed: () {
                      //           _selectDate(context);
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 15.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       ' Gender',
                      //       style: TextStyle(
                      //         color: Color(0xff8d99ae),
                      //         fontSize: 16.0,
                      //       ),
                      //     ),
                      //     DropdownButton<String>(
                      //       dropdownColor: Colors.black,
                      //       value: widget.gender,
                      //       icon: const Icon(
                      //         Icons.arrow_downward,
                      //         color: Color(0xffD90429),
                      //       ),
                      //       iconSize: 24,
                      //       elevation: 16,
                      //       style: const TextStyle(color: Color(0xffEDF2F4)),
                      //       underline: Container(
                      //         height: 2,
                      //         color: Color(0xffD90429),
                      //       ),
                      //       onChanged: (String? newValue) {
                      //         setState(() {
                      //           dropdownValue = newValue;
                      //         });
                      //       },
                      //       items: <String>['Male', 'Female']
                      //           .map<DropdownMenuItem<String>>((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(
                      //             value,
                      //             style: TextStyle(
                      //               fontSize: 18.0,
                      //             ),
                      //           ),
                      //         );
                      //       }).toList(),
                      //     ),
                      //     SizedBox(width: 30.0),
                      //   ],
                      // ),
                      // SizedBox(height: 15.0),
                      TextFormField(
                        initialValue: widget.email,
                        style: const TextStyle(color: Color(0xffEDF2F4)),
                        decoration: textInputDecoration.copyWith(
                          hintText: 'email',
                          labelText: 'email',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter an Email' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                            dateOfBirth =
                                selectedDate.toLocal().toString().split(' ')[0];
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      // TextFormField(
                      //   initialValue: 'test1234',
                      //   style: TextStyle(color: Color(0xffEDF2F4)),
                      //   obscureText: false,
                      //   validator: (value) => value!.length < 6
                      //       ? 'Enter a password of 6 or more charactors long'
                      //       : null,
                      //   decoration: textInputDecoration.copyWith(
                      //     hintText: 'password',
                      //     labelText: 'password',
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
                      //       password = val;
                      //     });
                      //   },
                      // ),
                      // SizedBox(height: 15.0),
                      // TextFormField(
                      //   initialValue: 'test1234',
                      //   style: TextStyle(color: Color(0xffEDF2F4)),
                      //   obscureText: false,
                      //   validator: (value) =>
                      //       value != password ? 'Password Does Not Match' : null,
                      //   decoration: textInputDecoration.copyWith(
                      //     hintText: 'confirm password',
                      //     labelText: 'confirm password',
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
                      //       confirmPassword = val;
                      //     });
                      //   },
                      // ),
                      const SizedBox(height: 35.0),
                      SizedBox(
                        height: 55.0,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xffD90429))),
                            child: const Text(
                              'REGISTER',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                print("register pressed");
                                setState(() => loading = true);
                                DatabaseService(
                                        uid: email == "" ? widget.email : email)
                                    .requestUserDataConfirmed(
                                  email == "" ? widget.email : email,
                                  sendEmail(
                                          email: widget.email,
                                          randomPassword: "test1234")
                                      .toString(),
                                  firstName == ""
                                      ? widget.firstName
                                      : firstName,
                                  lastName == "" ? widget.lastName : lastName,
                                  club == "" ? widget.club : club,
                                  // dateOfBirth ?? widget.datOfBirth,
                                  // gender == "" ? widget.gender : gender,
                                  isUser,
                                  isCoach,
                                  isClubAdmin,
                                  isSuperAdmin,
                                  false,
                                );

                                DatabaseService(uid: widget.email)
                                    .deleteRequestUserData(widget.email);
                                setState(() => loading = false);
                                navigator!.pop(context);
                              }
                            }),
                      ),
                      const SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
