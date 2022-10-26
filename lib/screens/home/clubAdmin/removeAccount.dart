import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/services/auth.dart';
import 'package:gymapp/shared/loading.dart';

class RemoveAccount extends StatefulWidget {
  const RemoveAccount({Key? key, this.club, this.userId}) : super(key: key);
  final String? club;
  final String? userId;

  @override
  _RemoveAccountState createState() => _RemoveAccountState();
}

class _RemoveAccountState extends State<RemoveAccount> {
  CollectionReference clubCollection =
      FirebaseFirestore.instance.collection('clubs');
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference userDeletionCollection =
      FirebaseFirestore.instance.collection('userDeletion');
  CollectionReference clubDeletionCollection =
      FirebaseFirestore.instance.collection('clubDeletion');

  bool? isLoading = false;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color(0xff154c79),
            appBar: AppBar(
              backgroundColor: const Color(0xff133957),
              title: Text('Remove Account'.toUpperCase()),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(height: 200.0),
                    Container(
                      height: 258.0,
                      width: MediaQuery.of(context).size.width - 30.0,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 30.0,
                            height: 50.0,
                            color: const Color(0xffD90429),
                            child: const Center(
                              child: Text(
                                "Attention!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 30.0,
                            height: 160.0,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'This action will DELETE - \n    1. Your Account, \n    2. Your Club, \n    3. Coaches in your Club, \n    4. Players in your Club, \npermanently.',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0.0),
                                ),
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                            'Deletion of the Account'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'This process is irreversible!'),
                                              Text(
                                                  'Would you like to continue this process?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'DELETE',
                                              style: TextStyle(
                                                  color: Color(0xffD90429)),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              setState(() {
                                                isLoading = true;
                                              });
                                              userCollection
                                                  .doc(widget.userId)
                                                  .update({
                                                "isDeleting": true,
                                              });
                                              await clubCollection
                                                  .where("name",
                                                      isEqualTo: widget.club)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      querySnapshot) {
                                                for (var doc
                                                    in querySnapshot.docs) {
                                                  clubDeletionCollection.add({
                                                    "uid":
                                                        FieldValue.arrayUnion(
                                                            [doc.id])
                                                  });
                                                }
                                              });

                                              await userCollection
                                                  .where("club",
                                                      isEqualTo: widget.club)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      querySnapshot) {
                                                for (var doc
                                                    in querySnapshot.docs) {
                                                  print(doc.id);
                                                  userDeletionCollection.add({
                                                    "uid":
                                                        FieldValue.arrayUnion(
                                                            [doc.id])
                                                  });
                                                }
                                              });

                                              await _auth.signOut();
                                              // setState(() {
                                              //   isLoading = false;
                                              // });
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Decline'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width -
                                          30.0) /
                                      2,
                                  height: 48.0,
                                  color: const Color(0xffD90429),
                                  child: const Center(
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0.0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width -
                                          30.0) /
                                      2,
                                  height: 48.0,
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
