import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/database.dart';
import '../../../shared/constants.dart';
import '../../../shared/loading.dart';

class ClubAdminRegisterRequest extends StatefulWidget {
  const ClubAdminRegisterRequest({Key? key}) : super(key: key);

  @override
  _ClubAdminRegisterRequestState createState() =>
      _ClubAdminRegisterRequestState();
}

class _ClubAdminRegisterRequestState extends State<ClubAdminRegisterRequest> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String club = '';
  String firstName = '';
  String lastName = '';
  // String? dateOfBirth;
  // String gender = '';
  String confirmPassword = '';
  bool isUser = false;
  bool isCoach = false;
  bool isClubAdmin = true;
  bool isSuperAdmin = false;
  String? dropdownValue = 'Male';
  String dropdownClub = '';
  String platformResponse = '';

  String error = '';

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

  final CollectionReference clubs =
      FirebaseFirestore.instance.collection('clubs');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: clubs.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // sendEmail({email}) async {
            //   String username = 'speakupemailing@gmail.com';
            //   String password = 'AbCd1234';

            //   // final smtpServer = gmail(username, password);
            //   // Use the SmtpServer class to configure an SMTP server:
            //   final smtpServer = SmtpServer('smtp.gmail.com',
            //       username: username, password: password);
            //   // See the named arguments of SmtpServer for further configuration
            //   // options.

            //   // Create our message.
            //   final message = Message()
            //     ..from = Address(username, 'SpeakUp')
            //     ..recipients.add("speakupsportsmobileapp@gmail.com")
            //     ..subject = 'New Register Request'
            //     ..text = 'New Register Request have recieved.'
            //     ..html =
            //         "<h1>Register Request</h1>\n<p>A new club admin register request have recieved from $email";

            //   try {
            //     setState(() {
            //       error = '';
            //     });
            //     final sendReport = await send(message, smtpServer);
            //     print('Message sent: ' + sendReport.toString());
            //   } on MailerException catch (e) {
            //     print('Message not sent.');

            //     for (var p in e.problems) {
            //       print('Problem: ${p.code}: ${p.msg}');
            //     }
            //   }
            //   // DONE
            // }

            //define variable for maintain list of clubs
            final clubs = snapshot.data!.docs;
            List clubList = [];
            //add clubs from stream into list
            for (var club in clubs) {
              final clubi = club['name'];
              clubList.add(clubi);
            }

            // dropdownClub = clubList.first;

            return Scaffold(
              backgroundColor: const Color(0xff154c79),
              appBar: AppBar(
                backgroundColor: const Color(0xff133957),
                title: Text(
                  'CLUB ADMIN REGISTRATION',
                  style: GoogleFonts.baiJamjuree(
                    textStyle: Theme.of(context).textTheme.headline5,
                    color: Colors.white,
                  ),
                ),
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
                          style: const TextStyle(color: Color(0xffEDF2F4)),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter a Club' : null,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'club'),
                          onChanged: (val) {
                            setState(() {
                              club = val;
                            });
                          },
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       ' Club',
                        //       style: TextStyle(
                        //         color: Color(0xff8d99ae),
                        //         fontSize: 16.0,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     DropdownButton<String>(
                        //       dropdownColor: Colors.black,
                        //       value: dropdownClub,
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
                        //       onChanged: (String newValue) {
                        //         setState(() {
                        //           dropdownClub = newValue;
                        //         });
                        //       },
                        //       items: <String>[
                        //         for (String clubName in clubList) clubName
                        //       ].map<DropdownMenuItem<String>>((String value) {
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
                        const SizedBox(height: 15.0),
                        TextFormField(
                          style: const TextStyle(color: Color(0xffEDF2F4)),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter First Name' : null,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'first name'),
                          onChanged: (val) {
                            setState(() {
                              firstName = val;
                            });
                          },
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          style: const TextStyle(color: Color(0xffEDF2F4)),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Last Name' : null,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'last name'),
                          onChanged: (val) {
                            setState(() {
                              lastName = val;
                            });
                          },
                        ),
                        const SizedBox(height: 15.0),
                        // Row(
                        //   children: [
                        //     SizedBox(width: 5.0),
                        //     Text(
                        //       'Date of Birth',
                        //       style: TextStyle(
                        //         color: Color(0xff8d99ae),
                        //         fontSize: 16.0,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     SizedBox(width: 20.0),
                        //     Text(
                        //       "${selectedDate.toLocal()}".split(' ')[0],
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
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     DropdownButton<String>(
                        //       dropdownColor: Colors.black,
                        //       value: dropdownValue,
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
                        //       items: <String>[
                        //         'Male',
                        //         'Female'
                        //       ].map<DropdownMenuItem<String>>((String value) {
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
                        const SizedBox(height: 15.0),
                        TextFormField(
                          style: const TextStyle(color: Color(0xffEDF2F4)),
                          decoration:
                              textInputDecoration.copyWith(hintText: 'email'),
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : 'Enter a valid email',
                          onChanged: (val) {
                            setState(() {
                              email = val;
                              // dateOfBirth = selectedDate
                              //     .toLocal()
                              //     .toString()
                              //     .split(' ')[0];
                            });
                          },
                        ),
                        // SizedBox(height: 15.0),
                        // TextFormField(
                        //   style: TextStyle(color: Color(0xffEDF2F4)),
                        //   obscureText: _isObsecure,
                        //   validator: (value) => value.length < 6
                        //       ? 'Enter a password of 6 or more charactors long'
                        //       : null,
                        //   decoration: textInputDecoration.copyWith(
                        //     hintText: 'password',
                        //     suffixIcon: IconButton(
                        //       icon: Icon(Icons.remove_red_eye),
                        //       onPressed: () {
                        //         setState(() {
                        //           _isObsecure = !_isObsecure;
                        //         });
                        //       },
                        //     ),
                        //   ),
                        //   onChanged: (val) {
                        //     setState(() {
                        //       password = val;
                        //     });
                        //   },
                        // ),
                        // SizedBox(height: 15.0),
                        // TextFormField(
                        //   style: TextStyle(color: Color(0xffEDF2F4)),
                        //   obscureText: _isObsecure,
                        //   validator: (value) => value != password
                        //       ? 'Password Does Not Match'
                        //       : null,
                        //   decoration: textInputDecoration.copyWith(
                        //     hintText: 'confirm password',
                        //     suffixIcon: IconButton(
                        //       icon: Icon(Icons.remove_red_eye),
                        //       onPressed: () {
                        //         setState(() {
                        //           _isObsecure = !_isObsecure;
                        //         });
                        //       },
                        //     ),
                        //   ),
                        //   onChanged: (val) {
                        //     setState(() {
                        //       confirmPassword = val;
                        //     });
                        //   },
                        // ),
                        const SizedBox(height: 55.0),
                        SizedBox(
                          height: 55.0,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xffD90429))),
                            child: const Text(
                              'SEND REQUEST',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);

                                await DatabaseService(uid: email)
                                    .requestUserData(
                                  email,
                                  'test1234',
                                  firstName,
                                  lastName,
                                  club,
                                  // dateOfBirth,
                                  // gender == "" ? dropdownValue : gender,
                                  isUser,
                                  isCoach,
                                  isClubAdmin,
                                  isSuperAdmin,
                                  false,
                                );
                                // sendEmail();
                                // sendRequestEmailToSuperAdmin(
                                //     clubAdminEmail: email);

                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Register Request'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'Successfully request to register a club was sent'),
                                            Text(
                                                'You will recieve an email about confirmation within 3-5 business days. \nThank you for connecting with us!.'),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            navigator!.pop(context);
                                            navigator!.pop(context);
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
