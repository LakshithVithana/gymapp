import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../models/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  ///user collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  ///this is created to get userDetail from snapshot
  UserDetails _userDetailsFromSnapshot(DocumentSnapshot snapshot) {
    return UserDetails(
      uid: uid,
      email: (snapshot.data() as dynamic)['email'],
      password: (snapshot.data() as dynamic)['password'],
      firstName: (snapshot.data() as dynamic)['firstName'],
      lastName: (snapshot.data() as dynamic)['lastName'],
      club: (snapshot.data() as dynamic)['club'],
      // dateOfBirth: (snapshot.data() as dynamic)['dateOfBirth'],
      // gender: (snapshot.data() as dynamic)['gender'],
      isUser: (snapshot.data() as dynamic)['isUser'],
      isCoach: (snapshot.data() as dynamic)['isCoach'],
      isClubAdmin: (snapshot.data() as dynamic)['isClubAdmin'],
      isSuperAdmin: (snapshot.data() as dynamic)['isSuperAdmin'],
      isDeleting: (snapshot.data() as dynamic)['isDeleting'],
      isPreQuestionAnswered:
          (snapshot.data() as dynamic)['isPreQuestionAnswered'],
      problems: (snapshot.data() as dynamic)['problems'],
      sleepProblemAnswers: (snapshot.data() as dynamic)['sleepProblemAnswers'],
      energyLevelsProblemAnswers:
          (snapshot.data() as dynamic)['energyLevelsProblemAnswers'],
      lessOfMotivationProblemAnswers:
          (snapshot.data() as dynamic)['lessOfMotivationProblemAnswers'],
      closedOffProblemAnswers:
          (snapshot.data() as dynamic)['closedOffProblemAnswers'],
      stressProblemAnswers:
          (snapshot.data() as dynamic)['stressProblemAnswers'],
      sadnessProblemAnswers:
          (snapshot.data() as dynamic)['sadnessProblemAnswers'],
      supportPersonName: (snapshot.data() as dynamic)['supportPersonName'],
      unreadMessages: (snapshot.data() as dynamic)['unreadMessages'],
      newMessageSent: (snapshot.data() as dynamic)['newMessageSent'],
    );
  }

  //get user doc stream
  Stream<UserDetails> get userDetails {
    return userCollection.doc(uid).snapshots().map(_userDetailsFromSnapshot);
  }

  //all users
  ///this is created to get usersDetail from snapshot
  List<UserDetails> _allUsersDetailsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserDetails(
        uid: uid,
        email: (doc.data() as dynamic)['email'],
        password: (doc.data() as dynamic)['password'],
        firstName: (doc.data() as dynamic)['firstName'],
        lastName: (doc.data() as dynamic)['lastName'],
        club: (doc.data() as dynamic)['club'],
        // dateOfBirth: (doc.data() as dynamic)['dateOfBirth'],
        // gender: (doc.data() as dynamic)['gender'],
        isUser: (doc.data() as dynamic)['isUser'],
        isCoach: (doc.data() as dynamic)['isCoach'],
        isClubAdmin: (doc.data() as dynamic)['isClubAdmin'],
        isSuperAdmin: (doc.data() as dynamic)['isSuperAdmin'],
        isDeleting: (doc.data() as dynamic)['isDeleting'],
        problems: (doc.data() as dynamic)['problems'],
      );
    }).toList();
  }

  //all users
  ///get all users stream
  Stream<List<UserDetails>> get allUsers {
    return userCollection.snapshots().map(_allUsersDetailsFromSnapshot);
  }

  ///club admin request collection reference
  final CollectionReference clubAdminRequestCollection =
      FirebaseFirestore.instance.collection('clubAdminRequests');

  ///club admin request collection reference
  final CollectionReference clubAdminRequestConfirmedCollection =
      FirebaseFirestore.instance.collection('users_registrations');

  ///get request doc stream
  Stream<UserDetails> get clubAdminRequestDetails {
    return clubAdminRequestCollection
        .doc(uid)
        .snapshots()
        .map(_userDetailsFromSnapshot);
  }

  //update user data
  Future updateUserData(
    String email,
    String password,
    String firstName,
    String lastName,
    String? club,
    // String? dateOfBirth,
    // String? gender,
    bool isUser,
    bool isCoach,
    bool isClubAdmin,
    bool isSuperAdmin,
    bool isDeleting,
    String currentDate,
  ) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'club': club,
      // 'dateOfBirth': dateOfBirth,
      // 'gender': gender,
      'isUser': isUser,
      'isCoach': isCoach,
      'isClubAdmin': isClubAdmin,
      'isSuperAdmin': isSuperAdmin,
      'isDeleting': isDeleting,
      'currentDate': currentDate,
      'isPreQuestionAnswered': false,
      'unreadMessages': false,
      'newMessageSent': false,
    });
  }

  //request user data
  Future requestUserData(
    String email,
    String password,
    String firstName,
    String lastName,
    String club,
    // String? dateOfBirth,
    // String? gender,
    bool isUser,
    bool isCoach,
    bool isClubAdmin,
    bool isSuperAdmin,
    bool isDeleteing,
  ) async {
    return await clubAdminRequestCollection.doc(email).set({
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'club': club,
      // 'dateOfBirth': dateOfBirth,
      // 'gender': gender,
      'isUser': isUser,
      'isCoach': isCoach,
      'isClubAdmin': isClubAdmin,
      'isSuperAdmin': isSuperAdmin,
      'isDeleteing': isDeleteing,
    });
  }

  //request user data
  Future requestUserDataConfirmed(
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? club,
    // String? dateOfBirth,
    // String? gender,
    bool isUser,
    bool isCoach,
    bool isClubAdmin,
    bool isSuperAdmin,
    bool isDeleting,
  ) async {
    // //send a email when super admin accepted the club
    // sendAcceptedEmail({email, randomPassword}) async {
    //   String username = 'speakupemailing@gmail.com';
    //   String password = 'AbCd1234';

    //   // final smtpServer = gmail(username, password);
    //   // Use the SmtpServer class to configure an SMTP server:
    //   final smtpServer =
    //       SmtpServer('smtp.gmail.com', username: username, password: password);
    //   // See the named arguments of SmtpServer for further configuration
    //   // options.

    //   // Create our message.
    //   final message = Message()
    //     ..from = Address(username, 'SpeakUp')
    //     ..recipients.add(email)
    //     ..subject = 'Request Approved'
    //     ..text = 'Your request has been aproved.'
    //     ..html =
    //         "<h1>Register Request Approved</h1>\n<p>You can now log in to your account by using this password: $randomPassword . Please reset the password when you are login";

    //   try {
    //     final sendReport = await send(message, smtpServer);
    //     print('Message sent: ' + sendReport.toString());
    //   } on MailerException catch (e) {
    //     print('Message not sent.');

    //     for (var p in e.problems) {
    //       print('Problem: ${p.code}: ${p.msg}');
    //     }
    //   }
    //   // DONE
    // }

    // sendAcceptedEmail(email: email, randomPassword: password);

    return await clubAdminRequestConfirmedCollection.doc(email).set({
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'club': club,
      // 'dateOfBirth': dateOfBirth,
      // 'gender': gender,
      'isUser': isUser,
      'isCoach': isCoach,
      'isClubAdmin': isClubAdmin,
      'isSuperAdmin': isSuperAdmin,
      'isDeleting': isDeleting,
    });
  }

  //delete request user data
  Future deleteRequestUserData(String? email) async {
    return await clubAdminRequestCollection.doc(email).delete();
  }
}
