import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/screens/home/clubAdmin/removeAccount.dart';
import 'coachProfile.dart';
import 'playerProfile.dart';
import '../invitation.dart';
import '../../../models/user.dart';
import '../../drawerPages/changePassword.dart';
import '../../drawerPages/profile.dart';
import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../shared/loading.dart';

class ClubAdminHome extends StatefulWidget {
  const ClubAdminHome({Key? key}) : super(key: key);

  @override
  _ClubAdminHomeState createState() => _ClubAdminHomeState();
}

class _ClubAdminHomeState extends State<ClubAdminHome> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser?>(context);
    return StreamBuilder<UserDetails>(
        stream: DatabaseService(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;
            if (userDetails != null) print(userDetails.club!);
            return Scaffold(
              backgroundColor: const Color(0xff154c79),
              appBar: AppBar(
                backgroundColor: const Color(0xff133957),
                title: const Text('HOME'),
                // actions: [
                //   TextButton.icon(
                //     icon: Icon(Icons.logout),
                //     label: Text('logout'),
                //     onPressed: () {
                //       _auth.signOut();
                //     },
                //   )
                // ],
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
                              'Club Admin View',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xff8d99ae),
                              ),
                            ),
                            // if (userDetails!.club == null)
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
                          'Delete Club',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Get.to(() => RemoveAccount(
                                club: userDetails!.club,
                                userId: user.uid,
                              ));
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
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.group_add,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                Text(
                                  'Invite Players',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
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
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.group_add,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                Text(
                                  'Invite Coaches',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(() => InvitePlayers(
                                  title: 'Coach',
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
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.group,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                Text(
                                  'Player Profiles',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(
                                () => PlayerProfile(club: userDetails!.club));
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
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.group,
                                  size: 70.0,
                                  color: Color(0xffD90429),
                                ),
                                Text(
                                  'Coach Profiles',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(() => CoachProfile(club: userDetails!.club));
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
