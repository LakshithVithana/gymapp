import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  bool readOnly = true;

  //text field state
  String email = '';
  String password = '';
  String club = '';
  String firstName = '';
  String lastName = '';
  String? dateOfBirth;
  String gender = '';
  String confirmPassword = '';
  bool isUser = true;
  bool isCoach = false;
  bool isClubAdmin = false;
  bool isSuperAdmin = false;
  // TextEditingController txt = TextEditingController(text: "a");
  String error = '';
  String? dropdownValue = 'Male';

  DateTime selectedDate = DateTime.now();
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

  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser?>(context);

    return StreamBuilder<UserDetails>(
        stream: DatabaseService(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails userDetails = snapshot.data!;
            return Scaffold(
              backgroundColor: Color(0xff154c79),
              appBar: AppBar(
                backgroundColor: Color(0xff133957),
                title: Text('PROFILE'),
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
                          initialValue: userDetails.club,
                          readOnly: true,
                          style: TextStyle(color: Color(0xffEDF2F4)),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter a Club' : null,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'club',
                            labelText: 'Club:',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              club = val;
                            });
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          initialValue: userDetails.firstName,
                          readOnly: readOnly,
                          style: TextStyle(color: Color(0xffEDF2F4)),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter First Name' : null,
                          decoration: readOnly
                              ? textInputDecoration.copyWith(
                                  hintText: 'first name',
                                  labelText: 'first name:',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                )
                              : textInputDecoration.copyWith(
                                  hintText: 'first name',
                                  labelText: 'first name:',
                                ),
                          onChanged: (val) {
                            setState(() {
                              firstName = val;
                            });
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          initialValue: userDetails.lastName,
                          readOnly: readOnly,
                          style: TextStyle(color: Color(0xffEDF2F4)),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Last Name' : null,
                          decoration: readOnly
                              ? textInputDecoration.copyWith(
                                  hintText: 'last name',
                                  labelText: 'last name:',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                )
                              : textInputDecoration.copyWith(
                                  hintText: 'last name',
                                  labelText: 'last name:',
                                ),
                          onChanged: (val) {
                            setState(() {
                              lastName = val;
                            });
                          },
                        ),
                        SizedBox(height: 15.0),
                        // TextFormField(
                        //   initialValue: userDetails.dateOfBirth,
                        //   // controller: txt,
                        //   readOnly: true,
                        //   style: TextStyle(color: Color(0xffEDF2F4)),
                        //   decoration: readOnly
                        //       ? textInputDecoration.copyWith(
                        //           hintText: 'date of birth',
                        //           labelText: 'date of birth:',
                        //           enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.grey, width: 2.0),
                        //             borderRadius: BorderRadius.circular(7.0),
                        //           ),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.grey, width: 2.0),
                        //             borderRadius: BorderRadius.circular(7.0),
                        //           ),
                        //         )
                        //       : textInputDecoration.copyWith(
                        //           hintText: 'date of birth',
                        //           labelText: 'date of birth:',
                        //           suffixIcon: IconButton(
                        //             icon: Icon(Icons.date_range),
                        //             onPressed: () {
                        //               _selectDate(context);
                        //               // txt.text = "${selectedDate.toLocal()}"
                        //               //     .split(' ')[0];
                        //               setState(() {
                        //                 dateOfBirth =
                        //                     "${selectedDate.toLocal()}"
                        //                         .split(' ')[0];
                        //               });
                        //             },
                        //           ),
                        //         ),
                        //   onTap: () {},
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
                        //       userDetails.dateOfBirth ??
                        //           "${selectedDate.toLocal()}".split(' ')[0],
                        //       style: TextStyle(
                        //         color: Color(0xffEDF2F4),
                        //         fontSize: 18.0,
                        //       ),
                        //     ),
                        //     SizedBox(width: 10.0),
                        //     readOnly
                        //         ? Container()
                        //         : Container(
                        //             decoration: BoxDecoration(
                        //                 color: Color(0xff8D99AE),
                        //                 borderRadius:
                        //                     BorderRadius.circular(5.0)),
                        //             child: IconButton(
                        //               icon: Icon(Icons.date_range, size: 30.0),
                        //               onPressed: () {
                        //                 _selectDate(context);
                        //                 dateOfBirth =
                        //                     "${selectedDate.toLocal()}"
                        //                         .split(' ')[0];
                        //               },
                        //             ),
                        //           ),
                        //   ],
                        // ),
                        // SizedBox(height: 15.0),
                        // TextFormField(
                        //   initialValue: userDetails.gender,
                        //   readOnly: true,
                        //   style: TextStyle(color: Color(0xffEDF2F4)),
                        //   decoration: readOnly
                        //       ? textInputDecoration.copyWith(
                        //           hintText: 'gender',
                        //           labelText: 'gender:',
                        //           enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.grey, width: 2.0),
                        //             borderRadius: BorderRadius.circular(7.0),
                        //           ),
                        //           focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //                 color: Colors.grey, width: 2.0),
                        //             borderRadius: BorderRadius.circular(7.0),
                        //           ),
                        //         )
                        //       : textInputDecoration.copyWith(
                        //           hintText: 'gender',
                        //           labelText: 'gender:',
                        //         ),
                        // ),
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
                        //     Container(
                        //       child: DropdownButton<String>(
                        //         dropdownColor: Colors.black,
                        //         value: userDetails.gender,
                        //         icon: const Icon(
                        //           Icons.arrow_downward,
                        //         ),
                        //         iconEnabledColor: Color(0xffD90429),
                        //         iconSize: 24,
                        //         elevation: 16,
                        //         style:
                        //             const TextStyle(color: Color(0xffEDF2F4)),
                        //         underline: Container(
                        //           height: 2,
                        //           color: Color(0xffD90429),
                        //         ),
                        //         onChanged: readOnly
                        //             ? null
                        //             : (String? newValue) {
                        //                 setState(() {
                        //                   dropdownValue = newValue;
                        //                 });
                        //               },
                        //         items: <String>[
                        //           'Male',
                        //           'Female'
                        //         ].map<DropdownMenuItem<String>>((String value) {
                        //           return DropdownMenuItem<String>(
                        //             value: value,
                        //             child: Text(
                        //               value,
                        //               style: TextStyle(
                        //                 fontSize: 18.0,
                        //               ),
                        //             ),
                        //           );
                        //         }).toList(),
                        //       ),
                        //     ),
                        //     SizedBox(width: 30.0),
                        //   ],
                        // ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          readOnly: true,
                          initialValue: userDetails.email,
                          style: TextStyle(color: Color(0xffEDF2F4)),
                          decoration: textInputDecoration.copyWith(
                            hintText: 'email',
                            labelText: 'email:',
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter an Email' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                              dateOfBirth = selectedDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0];
                            });
                          },
                        ),
                        SizedBox(height: 35.0),
                        readOnly == true
                            ? Container(
                                height: 55.0,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xffD90429))),
                                  child: Text(
                                    'EDIT',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      readOnly = false;
                                    });
                                  },
                                ),
                              )
                            : Container(
                                height: 55.0,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xffD90429))),
                                  child: Text(
                                    'SAVE',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      readOnly = true;
                                    });
                                    userRef.doc(user.uid).update({
                                      'firstName': firstName == ""
                                          ? userDetails.firstName
                                          : firstName,
                                      'lastName': lastName == ""
                                          ? userDetails.lastName
                                          : lastName,
                                      // 'dateOfBirth': dateOfBirth ??
                                      //     userDetails.dateOfBirth,
                                      // 'gender': gender == ""
                                      //     ? userDetails.gender
                                      //     : gender,
                                    });
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
