import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPlayerProfile extends StatefulWidget {
  const ViewPlayerProfile({Key? key, this.userProfile}) : super(key: key);
  final QueryDocumentSnapshot? userProfile;

  @override
  _ViewPlayerProfileState createState() => _ViewPlayerProfileState();
}

class _ViewPlayerProfileState extends State<ViewPlayerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff154c79),
      appBar: AppBar(
        backgroundColor: const Color(0xff133957),
        title: (widget.userProfile!.data() as dynamic)['isUser']
            ? Text('Player Profile'.toUpperCase())
            : Text('Coach Profile'.toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset('assets/images/profile.png'),
              ),
            ),
            const SizedBox(height: 25.0),
            Text(
              (widget.userProfile!.data() as dynamic)['firstName'] +
                  ' ' +
                  (widget.userProfile!.data() as dynamic)['lastName'],
              style: const TextStyle(
                color: Color(0xffD90429),
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const Text(
                    'Club: ',
                    style: TextStyle(
                      color: Color(0xff8d99ae),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    (widget.userProfile!.data() as dynamic)['club'],
                    style: const TextStyle(
                      color: Color(0xffedf2f4),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Row(
            //     children: [
            //       Text(
            //         'DoB: ',
            //         style: TextStyle(
            //           color: Color(0xff8d99ae),
            //           fontSize: 16.0,
            //         ),
            //       ),
            //       Text(
            //         (widget.userProfile!.data() as dynamic)['dateOfBirth'],
            //         style: TextStyle(
            //           color: Color(0xffedf2f4),
            //           fontSize: 16.0,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
