import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/screens/home/clubAdmin/playerProfile.dart';
import 'package:gymapp/screens/home/coach/sharedDocuments.dart';
import 'package:gymapp/screens/home/user/Chat/chat.dart';
import '../invitation.dart';
import '../../../models/user.dart';
import '../../drawerPages/changePassword.dart';
import '../../drawerPages/profile.dart';
import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../shared/loading.dart';
import 'package:gymapp/shared/text.dart';

class CoachHome extends StatefulWidget {
  const CoachHome({Key? key}) : super(key: key);

  @override
  _CoachHomeState createState() => _CoachHomeState();
}

class _CoachHomeState extends State<CoachHome> {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference userDeletionCollection =
      FirebaseFirestore.instance.collection('userDeletion');

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
                title: const Text('HOME'),
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
                              'Coach View',
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
                        //           Icons.assignment,
                        //           size: 70.0,
                        //           color: Color(0xffD90429),
                        //         ),
                        //         Text(
                        //           'Select Activities',
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
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.group_add,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                TextBox(
                                  textValue: 'Invite Players',
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
                            Get.to(() => InvitePlayers(
                                  title: 'Player',
                                  club: userDetails!.club,
                                ));
                          },
                        ),
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
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cloud_upload,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                TextBox(
                                  textValue: 'Upload Documents',
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
                                () => UploadDocuments(club: userDetails!.club));
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
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.group,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                TextBox(
                                  textValue: 'Player Profiles',
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
                            Get.to(() => PlayerProfile(club: userDetails.club));
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
