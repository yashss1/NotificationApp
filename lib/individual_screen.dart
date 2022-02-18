import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({Key? key, this.snap, this.index}) : super(key: key);

  final snap, index;

  @override
  _IndividualScreenState createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  TextEditingController msg = TextEditingController();

  Future<void> getToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;

    var _doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.snap[widget.index]['Info']['Uid'])
        .get();
    var _doc1 =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    bool docStatus = _doc.exists;
    bool docStatus1 = _doc1.exists;
    if (docStatus == true && docStatus1 == true) {
      callOnFcmApiSendPushNotifications(
          [_doc['Info']['Token']], msg.text, _doc1['Info']['Name']);
      msg.clear();
    }
  }

  callOnFcmApiSendPushNotifications(
      List<String> userToken, String msg, String name) async {
    print("Notification : ${userToken[0]} ${msg} - ${name}");

    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": userToken,
      "collapse_key": "type_a",
      "notification": {
        "title": name,
        "body": msg,
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'Bearer 	AAAAxkegXuw:APA91bEAli9UzNE9IcqlM815UksVaU8c-18zEOLSMssEy2pYvPrIe1wH-zj-3e_oA7AZwiIXD8WzNKzyHa3MCHSHGrotegZMIPN2EqHnBr2XydMXZsIcR7IXBKxB5g1bf83uCT1ltQLS'
    };

    try {
      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        // on success do sth
        print('test ok push CFM');
        return true;
      } else {
        print(' CFM error${response.reasonPhrase}');
        // on failure do sth
        return false;
      }
    } catch (e) {
      print('exception$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: deviceHeight,
          width: deviceWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * .1,
                ),
                Hero(
                  tag: 'profile',
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(100, 94, 94, 1),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(widget
                              .snap[widget.index]['Info']['ProfilePhotoUrl']),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  widget.snap[widget.index]['Info']['Name'],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 40),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: deviceWidth * .8,
                      child: TextField(
                        controller: msg,
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter the Notification",
                        ),
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.4699999988079071),
                            fontFamily: 'Lato',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: ()async{
                    getToken();
                  },
                  child: Container(
                    width: 107,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xffFEC37B),
                          Color(0xffFF4184),
                        ],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Send',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 20,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
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
