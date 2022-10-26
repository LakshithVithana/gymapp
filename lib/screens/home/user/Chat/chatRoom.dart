import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gymapp/services/chatService.dart';
import 'package:gymapp/shared/loading.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom(
      {Key? key,
      this.chatRoomID,
      this.myID,
      this.recipeintID,
      this.recipeintName})
      : super(key: key);
  final String? chatRoomID;
  final String? myID;
  final String? recipeintID;
  final String? recipeintName;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final CollectionReference chat =
      FirebaseFirestore.instance.collection('chat');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  String message = '';
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool sendButtonLoading = false;

  @override
  void initState() {
    userCollection.doc(widget.myID).update({
      'unreadMessages': false,
    });
    userCollection.doc(widget.recipeintID).update({
      'newMessageSent': false,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: ChatService(
                chatRoomID: widget.chatRoomID,
                myID: widget.myID,
                recipientID: widget.recipeintID)
            .chatRoomDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ChatRoomModel chatRoom = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text(
                  '${widget.recipeintName}',
                ),
                toolbarHeight: 80.0,
                backgroundColor: const Color(0xff133957),
                iconTheme: const IconThemeData(color: Color(0xffD90429)),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: FutureBuilder(
                          future: chat
                              .where('chatID', isEqualTo: widget.chatRoomID)
                              .get(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              // final myMessages =
                              //     snapshot.data.docs.toList() ?? [];
                              List myMessages = snapshot.data.docs.toList()[0]
                                      [widget.myID] ??
                                  [];
                              List recipientMessages = snapshot.data.docs
                                      .toList()[0][widget.recipeintID] ??
                                  [];
                              myMessages.removeWhere(
                                  (element) => element['message'] == '');
                              recipientMessages.removeWhere(
                                  (element) => element['message'] == '');

                              List allMessages = List.from(myMessages)
                                ..addAll(recipientMessages);
                              allMessages.sort((a, b) {
                                int aTimestamp = a['timestamp'];
                                int bTimestamp = b['timestamp'];

                                return aTimestamp.compareTo(bTimestamp);
                              });
                              Timer(
                                  const Duration(milliseconds: 1),
                                  () => _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease));
                              print(allMessages.length);
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: allMessages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      allMessages[index]['sentBy'] ==
                                              widget.recipeintID
                                          ? Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                9.0),
                                                        topRight:
                                                            Radius.circular(
                                                                9.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                9.0),
                                                      ),
                                                      color: Colors
                                                          .redAccent[400]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      allMessages[index]
                                                              ['message']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 20.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                9.0),
                                                        topRight:
                                                            Radius.circular(
                                                                9.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                9.0),
                                                      ),
                                                      color: Colors.blue[800]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      allMessages[index]
                                                              ['message']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color:
                                                              Colors.grey[200]),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: SpinKitThreeBounce(
                                  color: Color(0xffD90429),
                                  size: 50.0,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          // color: Colors.grey[900],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue[800]!,
                                        width: 2.0,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue[600]!,
                                        width: 2.0,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                controller: _controller,
                                onChanged: (value) {
                                  setState(() {
                                    message = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: IconButton(
                                icon: sendButtonLoading == true
                                    ? const CircularProgressIndicator(
                                        backgroundColor: Color(0xffD90429),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      )
                                    : Icon(
                                        Icons.send,
                                        color: Colors.blue[800],
                                        size: 30.0,
                                      ),
                                onPressed: message != ''
                                    ? () async {
                                        setState(() {
                                          sendButtonLoading = true;
                                        });
                                        await chat
                                            .doc(widget.chatRoomID)
                                            .update({
                                          widget.myID!: FieldValue.arrayRemove([
                                            {
                                              'message': '',
                                              'timestamp': 0,
                                              'sentBy': widget.myID,
                                            }
                                          ])
                                        });
                                        await chat
                                            .doc(widget.chatRoomID)
                                            .update({
                                          widget.myID!: FieldValue.arrayUnion([
                                            {
                                              'message': message,
                                              'timestamp': DateTime.now()
                                                  .microsecondsSinceEpoch,
                                              'sentBy': widget.myID,
                                            }
                                          ])
                                        });
                                        await userCollection
                                            .doc(widget.recipeintID)
                                            .update({
                                          'unreadMessages': true,
                                        });
                                        await userCollection
                                            .doc(widget.myID)
                                            .update({
                                          'newMessageSent': true,
                                        });
                                        Timer(
                                            const Duration(milliseconds: 1),
                                            () => _scrollController.animateTo(
                                                _scrollController
                                                    .position.maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.ease));
                                        _controller.clear();
                                        message = '';
                                        setState(() {
                                          sendButtonLoading = false;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: SpinKitThreeBounce(
                color: Color(0xffD90429),
                size: 50.0,
              ),
            );
          }
        });
  }
}
