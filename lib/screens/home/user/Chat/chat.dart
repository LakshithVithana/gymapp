import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/screens/home/user/Chat/chatRoom.dart';
import 'package:gymapp/services/database.dart';
import 'package:gymapp/shared/loading.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key, this.club}) : super(key: key);
  final String? club;

  @override
  _ChatState createState() => _ChatState();
}

CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');

final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

final CollectionReference chat = FirebaseFirestore.instance.collection('chat');

class _ChatState extends State<Chat> {
  String userUID = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser?>(context);
    return user == null
        ? const Loading()
        : StreamBuilder<UserDetails>(
            stream: DatabaseService(uid: user.uid).userDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserDetails? userDetails = snapshot.data;
                return Scaffold(
                  backgroundColor: const Color(0xff154c79),
                  appBar: AppBar(
                    backgroundColor: const Color(0xff133957),
                    title: Text('Chat'.toUpperCase()),
                  ),
                  body: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 56.0,
                          child: TabBar(tabs: [
                            Tab(child: Text('USERS')),
                            Tab(child: Text('COACH')),
                          ]),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 160.0,
                          child: TabBarView(
                            children: [
                              FutureBuilder<QuerySnapshot>(
                                future: userCollection
                                    .where('isUser', isEqualTo: true)
                                    .where('club', isEqualTo: widget.club)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final users = snapshot.data!.docs.toList();
                                    print(users.toString());
                                    users.removeWhere((element) =>
                                        element['email'] == userDetails!.email);
                                    return ListView.builder(
                                      itemCount: users.length,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: ((users[index] as dynamic)[
                                                      'newMessageSent'] ==
                                                  true)
                                              ? Colors.white
                                              : ((users[index] as dynamic)[
                                                          'isCoach'] ==
                                                      true)
                                                  ? const Color(0xff430414)
                                                  : Colors.black,
                                          child: ListTile(
                                            title: Text(
                                              (users[index]
                                                      as dynamic)['firstName'] +
                                                  ' ' +
                                                  (users[index]
                                                      as dynamic)['lastName'],
                                              style: const TextStyle(
                                                color: Color(0xffD90429),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: () async {
                                              setState(() {
                                                userUID = userDetails!.uid!;
                                              });
                                              print(userDetails!.uid! +
                                                  users[index].id);
                                              final snapshot = await chat
                                                  .doc(getChatRoomID(
                                                      userUID, users[index].id))
                                                  .get();
                                              if (!snapshot.exists) {
                                                chat
                                                    .doc(getChatRoomID(userUID,
                                                        users[index].id))
                                                    .set({
                                                  'chatID': getChatRoomID(
                                                      userUID, users[index].id),
                                                  userUID:
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'message': '',
                                                      'timestamp': 0,
                                                      'sentBy': userUID,
                                                    }
                                                  ]),
                                                  users[index].id:
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'message': '',
                                                      'timestamp': 0,
                                                      'sentBy': users[index].id,
                                                    }
                                                  ]),
                                                });
                                              }
                                              Future.delayed(
                                                  const Duration(seconds: 1));
                                              Get.to(
                                                () => ChatRoom(
                                                  chatRoomID: getChatRoomID(
                                                      userUID, users[index].id),
                                                  myID: userUID,
                                                  recipeintID: users[index].id,
                                                  recipeintName: users[index]
                                                      ['firstName'],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Loading();
                                  }
                                },
                              ),
                              FutureBuilder<QuerySnapshot>(
                                future: userCollection
                                    .where('isCoach', isEqualTo: true)
                                    .where('club', isEqualTo: widget.club)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final users = snapshot.data!.docs.toList();
                                    print(users.toString());
                                    users.removeWhere((element) =>
                                        element['email'] == userDetails!.email);
                                    return ListView.builder(
                                      itemCount: users.length,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: ((users[index] as dynamic)[
                                                      'newMessageSent'] ==
                                                  true)
                                              ? Colors.white
                                              : ((users[index] as dynamic)[
                                                          'isCoach'] ==
                                                      true)
                                                  ? const Color(0xff430414)
                                                  : Colors.black,
                                          child: ListTile(
                                            title: Text(
                                              (users[index]
                                                      as dynamic)['firstName'] +
                                                  ' ' +
                                                  (users[index]
                                                      as dynamic)['lastName'],
                                              style: const TextStyle(
                                                color: Color(0xffD90429),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: () async {
                                              setState(() {
                                                userUID = userDetails!.uid!;
                                              });
                                              print(userDetails!.uid! +
                                                  users[index].id);
                                              final snapshot = await chat
                                                  .doc(getChatRoomID(
                                                      userUID, users[index].id))
                                                  .get();
                                              if (!snapshot.exists) {
                                                chat
                                                    .doc(getChatRoomID(userUID,
                                                        users[index].id))
                                                    .set({
                                                  'chatID': getChatRoomID(
                                                      userUID, users[index].id),
                                                  userUID:
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'message': '',
                                                      'timestamp': 0,
                                                      'sentBy': userUID,
                                                    }
                                                  ]),
                                                  users[index].id:
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'message': '',
                                                      'timestamp': 0,
                                                      'sentBy': users[index].id,
                                                    }
                                                  ]),
                                                });
                                              }
                                              Future.delayed(
                                                  const Duration(seconds: 1));
                                              Get.to(
                                                () => ChatRoom(
                                                  chatRoomID: getChatRoomID(
                                                      userUID, users[index].id),
                                                  myID: userUID,
                                                  recipeintID: users[index].id,
                                                  recipeintName: users[index]
                                                      ['firstName'],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Loading();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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

///create chatroom ID by both chat participents
getChatRoomID(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "${b}_$a";
  } else {
    return "${a}_$b";
  }
}
