import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'userCard.dart';
import '../../../shared/loading.dart';

class CoachProfile extends StatefulWidget {
  CoachProfile({Key? key, this.club}) : super(key: key);
  final String? club;

  @override
  _CoachProfileState createState() => _CoachProfileState();
}

class _CoachProfileState extends State<CoachProfile> {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff154c79),
      appBar: AppBar(
        backgroundColor: Color(0xff133957),
        title: Text('Coach Profiles'.toUpperCase()),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: userCollection
            .where('isCoach', isEqualTo: true)
            .where('club', isEqualTo: widget.club)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!.docs.toList();
            return ListView.builder(
              itemCount: users.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return UserCard(userProfile: users[index]);
              },
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
