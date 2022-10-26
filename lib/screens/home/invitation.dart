import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class InvitePlayers extends StatefulWidget {
  InvitePlayers({Key? key, this.title, this.club}) : super(key: key);
  final String? title;
  final String? club;

  @override
  _InvitePlayersState createState() => _InvitePlayersState();
}

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference newUserAccessCodeCollection =
    FirebaseFirestore.instance.collection('newUserAccessCode');
final CollectionReference clubCollection =
    FirebaseFirestore.instance.collection('clubs');

class _InvitePlayersState extends State<InvitePlayers> {
  String? email = '';
  String? error = '';
  Color? errorColor = Colors.red;
  String? accessCodeNumber = '';

  bool? isLoading = false;

  @override
  void initState() {
    String? accessCode({club}) {
      clubCollection.where("name", isEqualTo: club).get().then((club) {
        // print(((club.docs.first.data() as dynamic)["accessCode"].toString()));
        setState(() {
          accessCodeNumber =
              (club.docs.first.data() as dynamic)["accessCode"].toString();
        });
      });
    }

    accessCode(club: widget.club);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.club);
    String? accesCodeGenerator() {
      var rng = new Random();
      int randomNumber = rng.nextInt(99999) + 99999;
      return randomNumber.toString();
    }

    sendEmail({email, String? club}) async {
      String username = 'speakupemailing@gmail.com';
      String password = 'AbCd1234';

      // final smtpServer = gmail(username, password);
      // Use the SmtpServer class to configure an SMTP server:
      final smtpServer =
          SmtpServer('smtp.gmail.com', username: username, password: password);
      // See the named arguments of SmtpServer for further configuration
      // options.

      // Create our message.
      final message = Message()
        ..from = Address(username, 'SpeakUp')
        ..recipients.add(email)
        ..subject = '${widget.title} Register Request'
        ..text = 'You can register in our club using following access code.'
        ..html =
            "<h1>Register Request</h1>\n<p>You can register in our club using following access code.</p>\n<h3>$accessCodeNumber<h3>";

      try {
        setState(() {
          error = '';
        });
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());

        newUserAccessCodeCollection.doc().set({
          'email': email,
          'access code': accessCodeNumber,
          'type': widget.title,
          'club': widget.club,
        });
        setState(() {
          errorColor = Colors.green;
          error = 'Email sent successfully';
          isLoading = false;
        });
      } on MailerException catch (e) {
        print('Message not sent.');
        setState(() {
          errorColor = Colors.red;
          error = 'Email not sent';
          isLoading = false;
        });
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      // DONE
    }

    return Scaffold(
      backgroundColor: Color(0xff154c79),
      appBar: AppBar(
        backgroundColor: Color(0xff133957),
        title: Text('Invite ${widget.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                SizedBox(height: 100.0),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      error = '';
                    });
                  },
                ),
                Text(
                  error!,
                  style: TextStyle(color: errorColor),
                ),
                SizedBox(height: 100.0),
                Container(
                  height: 55.0,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xffD90429),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        error = '';
                        isLoading = true;
                      });
                      usersCollection
                          .where("email", isNotEqualTo: email)
                          .get()
                          .then((value) async {
                        await sendEmail(
                          email: email,
                          club: widget.club,
                        );
                      }).catchError((onError) {
                        setState(() {
                          errorColor = Colors.red;
                          error =
                              'This email already exists! Can not send a new request';
                          isLoading = false;
                        });
                      });
                    },
                    child: isLoading == true
                        ? CircularProgressIndicator(
                            backgroundColor: Color(0xffD90429),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          )
                        : Text(
                            'Invite',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
