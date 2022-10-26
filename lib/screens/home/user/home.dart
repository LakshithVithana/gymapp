import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/screens/home/user/Chat/chat.dart';
import 'package:gymapp/screens/home/user/trainingMonitorNew.dart';
import 'package:gymapp/screens/home/user/viewDocuments.dart';
import 'package:gymapp/services/database.dart';
import 'package:gymapp/shared/loading.dart';
import '../../drawerPages/changePassword.dart';
import '../../drawerPages/profile.dart';
import '../../../services/auth.dart';
import 'package:gymapp/shared/text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference userDeletionCollection =
      FirebaseFirestore.instance.collection('userDeletion');

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser?>(context);
    return StreamBuilder<UserDetails>(
        stream: DatabaseService(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            return Scaffold(
              backgroundColor: const Color(0xff154c79),
              appBar: AppBar(
                backgroundColor: const Color(0xff133957),
                title: Text('HOME', style: GoogleFonts.baiJamjuree()),
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
                                color: Color(0xff8d99ae),
                              ),
                            ),
                            Text(
                              'User View',
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
                          Icons.person,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        title: const Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Get.to(() => Profile());
                        },
                      ),
                      const SizedBox(height: 10.0),
                      ListTile(
                        leading: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        title: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Get.to(() => ChangePassword());
                        },
                      ),
                      const SizedBox(height: 10.0),
                      ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        title: const Text(
                          'Remove Account',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('Deletion of the Account'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text('This process is irreversible!'),
                                      Text(
                                          'Would you like to continue this process?'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await userDeletionCollection.add({
                                        "uid": FieldValue.arrayUnion([user.uid])
                                      });
                                      Navigator.of(context).pop();
                                      userCollection.doc(user.uid).update({
                                        "isDeleting": true,
                                      });
                                      _auth.signOut();
                                    },
                                    child: const Text("Delete"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10.0),
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: CustomScrollView(
                primary: false,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(30),
                    sliver: SliverGrid.count(
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      crossAxisCount: 2,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: const Color(0xffD90429),
                                width: 3.0,
                              ),
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.poll,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                TextBox(
                                  textValue: 'Training Monitor',
                                  textSize: 4,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.center,
                                  captionAlign: TextAlign.center,
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Get.to(() => TrainingMonitor(uid: user.uid));
                            Get.to(() => TrainingMonitor(uid: user.uid));
                          },
                        ),
                        // GestureDetector(
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(15.0),
                        //       border: Border.all(
                        //         style: BorderStyle.solid,
                        //         color: Color(0xffD90429),
                        //         width: 3.0,
                        //       ),
                        //       color: Colors.black,
                        //     ),
                        //     padding: const EdgeInsets.all(8),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Icon(
                        //           Icons.directions_run,
                        //           size: 70.0,
                        //           color: Color(0xffD90429),
                        //         ),
                        //         Text(
                        //           'Activities',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 16.0,
                        //           ),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: const Color(0xffD90429),
                                width: 3.0,
                              ),
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.library_books,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                TextBox(
                                  textValue: 'Shared Documents',
                                  textSize: 4,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.center,
                                  captionAlign: TextAlign.center,
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(
                                () => ViewDocuments(club: userDetails!.club));
                          },
                        ),
                        GestureDetector(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    color: const Color(0xffD90429),
                                    width: 3.0,
                                  ),
                                  color: Colors.black,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.chat,
                                      size: 70.0,
                                      color: Color(0xffD90429),
                                    ),
                                    TextBox(
                                      textValue: 'Chat',
                                      textSize: 4,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.center,
                                      captionAlign: TextAlign.center,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              userDetails!.unreadMessages == true
                                  ? Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white),
                                    )
                                  : Container(),
                            ],
                          ),
                          onTap: () {
                            Get.to(() => Chat(club: userDetails.club));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
