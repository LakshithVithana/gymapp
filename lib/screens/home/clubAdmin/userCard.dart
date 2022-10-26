import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'viewProfile.dart';

class UserCard extends StatefulWidget {
  UserCard({Key? key, this.userProfile}) : super(key: key);
  final QueryDocumentSnapshot? userProfile;

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  CollectionReference userDeletionCollection =
      FirebaseFirestore.instance.collection('userDeletion');

  bool? isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.black,
        child: ListTile(
          title: Text(
            (widget.userProfile!.data() as dynamic)['firstName'] +
                ' ' +
                (widget.userProfile!.data() as dynamic)['lastName'],
            style: TextStyle(
              color: Color(0xffD90429),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            (widget.userProfile!.data() as dynamic)['club'],
            style: TextStyle(
              color: Color(0xff8d99ae),
            ),
          ),
          trailing: isLoading == true
              ? CircularProgressIndicator(
                  backgroundColor: Color(0xffD90429),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    userDeletionCollection.add({
                      "uid": FieldValue.arrayUnion([widget.userProfile!.id]),
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
        ),
      ),
      onTap: () {
        Get.to(() => ViewPlayerProfile(userProfile: widget.userProfile));
      },
    );
  }
}
