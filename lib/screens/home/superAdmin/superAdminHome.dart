import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../services/database.dart';
import '../../authenticate/register/clubAdminRegister.dart';
import '../../../services/auth.dart';
import '../../../shared/loading.dart';

class SuperAdminHome extends StatefulWidget {
  const SuperAdminHome({Key? key}) : super(key: key);

  @override
  _SuperAdminHomeState createState() => _SuperAdminHomeState();
}

class _SuperAdminHomeState extends State<SuperAdminHome> {
  final AuthService _auth = AuthService();
  final CollectionReference userRequest =
      FirebaseFirestore.instance.collection('clubAdminRequests');

  List requestList = [];

  @override
  Widget build(BuildContext context) {
    //send a email when super admin rejected the club
    sendRejectedEmail({email}) async {
      String username = 'gymappemailing@gmail.com';
      String password = 'AbCd1234';

      // final smtpServer = gmail(username, password);
      // Use the SmtpServer class to configure an SMTP server:
      final smtpServer =
          SmtpServer('smtp.gmail.com', username: username, password: password);
      // See the named arguments of SmtpServer for further configuration
      // options.

      // Create our message.
      final message = Message()
        ..from = Address(username, 'gymapp')
        ..recipients.add(email)
        ..subject = 'Club Registration Request Rejected'
        ..text = 'Your club register request has been rejected.'
        ..html = "<h1>Your Club Register Request has been rejected.";

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: $sendReport');
      } on MailerException catch (e) {
        print('Message not sent.');

        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      // DONE
    }

    return StreamBuilder<QuerySnapshot>(
      stream: userRequest.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // userRequest.get().then((QuerySnapshot querySnapshot) {
          //   querySnapshot.docs.forEach((doc) {
          //     // print(doc);
          //     requestList.add(doc);
          //   });
          // });
          return Scaffold(
            backgroundColor: const Color(0xff154c79),
            appBar: AppBar(
              backgroundColor: const Color(0xff133957),
              title: const Text('REQUESTS'),
            ),
            drawer: Drawer(
              child: Container(
                color: const Color(0xff154c79),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    DrawerHeader(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'GymApp',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Color(0xffedf2f4),
                            ),
                          ),
                          Text(
                            'Super Admin View',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xff8d99ae),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.group_add,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      title: const Text(
                        'Requests',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xffedf2f4),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    // SizedBox(height: 10.0),
                    // ListTile(
                    //   leading: Icon(
                    //     Icons.lock,
                    //     color: Color(0xffD90429),
                    //     size: 35.0,
                    //   ),
                    //   title: Text(
                    //     'Change Password',
                    //     style: TextStyle(
                    //       fontSize: 18.0,
                    //       color: Color(0xffedf2f4),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     Get.to(() => ChangePassword());
                    //   },
                    // ),
                    // SizedBox(height: 10.0),
                    // ListTile(
                    //   leading: Icon(
                    //     Icons.delete,
                    //     color: Color(0xffD90429),
                    //     size: 35.0,
                    //   ),
                    //   title: Text(
                    //     'Remove Account',
                    //     style: TextStyle(
                    //       fontSize: 18.0,
                    //       color: Color(0xffedf2f4),
                    //     ),
                    //   ),
                    //   onTap: () {},
                    // ),
                    // SizedBox(height: 10.0),
                    // ListTile(
                    //   title: Text(
                    //     'Privacy Policy & TOS',
                    //     style: TextStyle(
                    //       fontSize: 18.0,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    //   onTap: () {},
                    // ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Color(0xffD90429),
                        size: 35.0,
                      ),
                      onTap: () async {
                        await _auth.signOut();
                      },
                      title: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xffedf2f4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    color: Colors.black54,
                    elevation: 2.0,
                    child: ExpansionTile(
                      title: Text(
                        (document.data() as dynamic)['firstName'] +
                            ' ' +
                            (document.data() as dynamic)['lastName'],
                        style: const TextStyle(
                          color: Color(0xffedf2f4),
                        ),
                      ),
                      subtitle: Text(
                        (document.data() as dynamic)['email'],
                        style: const TextStyle(color: Color(0xff8d99ae)),
                      ),
                      trailing: const Icon(
                        Icons.arrow_downward,
                        color: Color(0xffD90429),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 17.0,
                            right: 17.0,
                            bottom: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => ClubAdminRegister(
                                          firstName: (document.data()
                                              as dynamic)['firstName'],
                                          lastName: (document.data()
                                              as dynamic)['lastName'],
                                          club: (document.data()
                                              as dynamic)['club'],
                                          // datOfBirth: (document.data()
                                          //     as dynamic)['dateOfBirth'],
                                          // gender: (document.data()
                                          //     as dynamic)['gender'],
                                          email: (document.data()
                                              as dynamic)['email'],
                                        ));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xffD90429),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    sendRejectedEmail(
                                        email: (document.data()
                                            as dynamic)['email']);
                                    DatabaseService(
                                            uid: (document.data()
                                                as dynamic)['email'])
                                        .deleteRequestUserData((document.data()
                                            as dynamic)['email']);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xff8d99ae),
                                    ),
                                  ),
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
