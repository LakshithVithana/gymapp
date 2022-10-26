import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/auth.dart';
import '../../../shared/constants.dart';
import '../../../shared/loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  Register({Key? key, this.toggleView}) : super(key: key);
  final Function? toggleView;

  @override
  _RegisterState createState() => _RegisterState();
}

enum Gender { male, female }

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _isObsecure = true;

  //text field state
  String email = '';
  String password = '';
  String club = '';
  String firstName = '';
  String lastName = '';
  // String? dateOfBirth;
  // String gender = '';
  String confirmPassword = '';
  String accessCode = '';

  bool isUser = true;
  bool isCoach = false;
  bool isClubAdmin = false;
  bool isSuperAdmin = false;
  String? dropdownValue = 'Male';
  String? dropdownClub =
      ' '; // dont't remove this space; it is linked with the doc id "hR2qKitKUYCNmFtn7vXG" in clubs collection

  String error = '';

  DateTime selectedDate = DateTime.now();

  DateTime _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('dd');
  final _monthFormatter = DateFormat('MM');
  final _yearFormatter = DateFormat("yyyy");
  String _calculatedDate = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  final CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');
  final CollectionReference newUserAccessCodeCollection =
      FirebaseFirestore.instance.collection('newUserAccessCode');

  @override
  Widget build(BuildContext context) {
    _calculatedDate = _yearFormatter.format(_currentDate).toString() +
        _monthFormatter.format(_currentDate).toString() +
        _dayFormatter.format(_currentDate).toString();

    print(_calculatedDate);

    if (accessCode.length == 6) {
      setState(() {
        clubCollection
            .where("accessCode", isEqualTo: accessCode)
            .get()
            .then((clubs) {
          if (clubs.docs.isNotEmpty) {
            club = (clubs.docs.first.data() as dynamic)["name"];
          }
        });
      });
    }
    return StreamBuilder<QuerySnapshot>(
        stream: clubCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final clubs = snapshot.data!.docs;
            List<String?> clubList = [];
            //add clubs from stream into list
            for (var club in clubs) {
              final clubi = club['name'];
              clubList.add(clubi);
            }
            clubList.sort();

            return Scaffold(
              backgroundColor: Color(0xff154c79),
              appBar: AppBar(
                backgroundColor: Color(0xff133957),
                title: Text(
                  'USER REGISTRATION',
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
                        SizedBox(height: 20.0),
                        TextFormField(
                          style: TextStyle(color: Color(0xffEDF2F4)),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Access Code' : null,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Access Code'),
                          onChanged: (val) {
                            print(val.length.toString());
                            setState(() {
                              accessCode = val;
                            });
                          },
                        ),
                        SizedBox(height: 15.0),
                        club != ''
                            ? Row(
                                children: [
                                  Text(
                                    ' Club',
                                    style: TextStyle(
                                      color: Color(0xff8d99ae),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    club,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
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
                        //     DropdownButton<String?>(
                        //       hint: Text(
                        //         'select a club',
                        //         style: TextStyle(color: Color(0xff8d99ae)),
                        //       ),
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
                        //       onChanged: (String? newValue) {
                        //         setState(() {
                        //           dropdownClub = newValue;
                        //         });
                        //       },
                        //       items: <String?>[
                        //         for (String? clubName in clubList) clubName
                        //       ].map<DropdownMenuItem<String>>((String? value) {
                        //         return DropdownMenuItem<String>(
                        //           value: value,
                        //           child: Text(
                        //             value!,
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

                        SizedBox(height: 15.0),
                        TextFormField(
                          style: TextStyle(color: Color(0xffEDF2F4)),
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
                        SizedBox(height: 15.0),
                        TextFormField(
                          style: TextStyle(color: Color(0xffEDF2F4)),
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
                        SizedBox(height: 15.0),
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
                        //   children: [
                        //     SizedBox(width: 5.0),
                        //     Text(
                        //       'Date of Birth',
                        //       style: TextStyle(
                        //         color: Color(0xffEDF2F4),
                        //         fontSize: 16.0,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     SizedBox(width: 20.0),
                        //     Text(
                        //       "${selectedDate.toLocal()}".split(' ')[0],
                        //       style: TextStyle(
                        //         color: Color(0xffEDF2F4),
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
                        SizedBox(height: 15.0),
                        TextFormField(
                          style: TextStyle(color: Color(0xffEDF2F4)),
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
                        SizedBox(height: 15.0),
                        TextFormField(
                          style: TextStyle(color: Color(0xffEDF2F4)),
                          obscureText: _isObsecure,
                          validator: (value) => value!.length < 6
                              ? 'Enter a password of 6 or more charactors long'
                              : null,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'password',
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
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          style: TextStyle(color: Color(0xffEDF2F4)),
                          obscureText: _isObsecure,
                          validator: (value) => value != password
                              ? 'Password Does Not Match'
                              : null,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'confirm password',
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
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 35.0),
                        Container(
                          height: 55.0,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xffD90429))),
                            child: loading == false
                                ? Text(
                                    'REGISTER',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : CircularProgressIndicator(
                                    backgroundColor: Color(0xffD90429),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                            onPressed: () async {
                              // newUserAccessCodeCollection
                              //     .where("email", isEqualTo: email)
                              //     .get()
                              //     .then((value) async {
                              // if (value.docs[0]['access code'] ==
                              //     accessCode) {
                              //   if (value.docs[0]['type'] == 'Player') {
                              //     if (value.docs[0]['club'] == club) {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                  email,
                                  password,
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
                                  _calculatedDate,
                                );
                                // newUserAccessCodeCollection
                                //     .doc(value.docs[0].id)
                                //     .delete();
                                Navigator.pop(context);
                                // print('result user ' + result.uid);
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Can Not Register With Those Credentials';
                                    loading = false;
                                  });
                                }
                                _auth.signOut();
                              }
                              //     } else {
                              //       setState(() {
                              //         error = "You selected a wrong club";
                              //       });
                              //     }
                              //   } else {
                              //     setState(() {
                              //       error =
                              //           "You're on Player Registration Page!";
                              //     });
                              //   }
                              // } else {
                              //   setState(() {
                              //     error = 'Invalid Access Code!';
                              //   });
                              // }
                              // }).catchError((err) {
                              //   setState(() {
                              //     error = 'Entered email is incorrect';
                              //   });
                              // });
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
        });
  }
}
