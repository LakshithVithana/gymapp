import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase
  OurUser? _userFromFirebaseuser(User? user) {
    return user != null ? OurUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<OurUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseuser);
  }

  //create user object based on firebase
  UserRequest? _userRequest(User? user) {
    return user != null ? UserRequest(email: user.email) : null;
  }

  //auth change userRequest stream
  Stream<UserRequest?> get userRequest {
    return _auth.authStateChanges().map(_userRequest);
  }

  // register with email and password
  Future registerWithEmailAndPassword(
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
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await DatabaseService(uid: user.uid).updateUserData(
        email,
        password,
        firstName,
        lastName,
        club,
        // dateOfBirth,
        // gender,
        isUser,
        isCoach,
        isClubAdmin,
        isSuperAdmin,
        isDeleting,
        currentDate,
      );
      print('uid: ' + user.uid.toString());
      return _userFromFirebaseuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      print('uid: ' + user.uid.toString());
      return _userFromFirebaseuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
