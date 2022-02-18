import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithGoogle() async {
    late final bool isNewUser;
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
        isNewUser = userCredential.additionalUserInfo!.isNewUser;
      }
      if (isNewUser) {
        storeUserDetails();
      }
      return;
    } catch (e) {
      return e;
    }
  }

  Future<void> storeUserDetails() async {
    final CollectionReference usercollection =
    FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String email = auth.currentUser!.email.toString();
    User? user = auth.currentUser;

    usercollection.doc(uid).set({
      "Info":{
        "Name": user!.displayName,
        "PhoneNumber": user.phoneNumber,
        "Email": email,
        "ProfilePhotoUrl": user.photoURL,
        "Uid": user.uid,
        "isAdmin": false,
        "Token" : "token",
      }
    }, SetOptions(merge: true));

    return;
  }

  //Store Token
  Future<void> storeToken(token) async {
    final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection
        .doc(uid)
        .set({
      "Info": {
        "Token": token,
      }
    }, SetOptions(merge: true))
        .then((value) => print("User Token Updated"))
        .catchError((error) => print("Failed to Update Token: $error"));

    return;
  }

  // Future<bool> saveAsLoggedIn() async {
  //   final CollectionReference usercollection =
  //   FirebaseFirestore.instance.collection('AlreadyLoggedIn');
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   String uid = auth.currentUser!.uid.toString();
  //   String email = "DummyMail";
  //   email = auth.currentUser!.email.toString();
  //   User? user = auth.currentUser;
  //
  //   var _doc = await usercollection.doc(email).get();
  //   bool docstatus = _doc.exists;
  //   if (docstatus == true) return false;
  //
  //   usercollection.doc(email).set({
  //     "Email": email,
  //     "Uid": user!.uid,
  //   }, SetOptions(merge: true));
  //
  //   return true;
  // }

  Future<void> removeFromLogIn() async {
    final CollectionReference usercollection =
    FirebaseFirestore.instance.collection('AlreadyLoggedIn');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String email = "DummyMail";
    email = auth.currentUser!.email.toString();
    User? user = auth.currentUser;

    await usercollection.doc(email).delete();
  }
}
