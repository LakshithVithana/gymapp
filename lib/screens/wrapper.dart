import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'authenticate/authenticate.dart';
import 'home/clubAdmin/clubAdminHome.dart';
import 'home/coach/coachHome.dart';
import 'home/user/home.dart';
import 'home/superAdmin/superAdminHome.dart';
import '../services/database.dart';
import '../shared/loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //declare user from provider
    final user = Provider.of<OurUser?>(context);

    //return either Home or Authentication widget
    if (user == null) {
      return Authenticate();
    } else {
      return StreamBuilder<UserDetails>(
        stream: DatabaseService(uid: user.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails userDetails = snapshot.data!;
            if (userDetails.isUser!) {
              return Home();
            }
            if (userDetails.isCoach!) {
              return CoachHome();
            }
            if (userDetails.isClubAdmin!) {
              return ClubAdminHome();
            } else {
              return SuperAdminHome();
            }
          } else {
            return Loading();
          }
        },
      );
    }
  }
}
