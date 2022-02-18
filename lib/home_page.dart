import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:notification_app/individual_screen.dart';
import 'package:notification_app/services/authentication_helper.dart';
import 'package:notification_app/verification_screens/login_page.dart';

import 'model/tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: deviceWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 90),
                      Container(
                        height: deviceHeight * .85,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .snapshots(),
                            builder: (ctx, AsyncSnapshot snaps) {
                              if (snaps.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final _snap = snaps.data!.docs;
                              // print(_snap[0]['Info']['ProfilePhotoUrl']);
                              return _snap.length == 0
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "WE'RE SORRY",
                                          ),
                                          Center(
                                            child: Text(
                                              "There is Nothing here...",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: _snap.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return IndividualScreen(
                                                    snap: _snap,
                                                    index: index,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Tile(
                                                photo: _snap[index]['Info']
                                                    ['ProfilePhotoUrl'],
                                                name: _snap[index]['Info']
                                                    ['Name'],
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: 80,
                  color: Colors.white,
                  width: deviceWidth,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Users',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 27,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                              height: 1.1),
                        ),
                        InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              headerAnimationLoop: false,
                              title: 'Logout?',
                              desc: 'Do you really want to logout?',
                              btnOkOnPress: () async {
                                await AuthHelper().removeFromLogIn();
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const LoginPage()),
                                    (route) => false);
                              },
                              btnCancelOnPress: () {
                                // Navigator.of(context).pop();
                              },
                              dismissOnTouchOutside: false,
                            ).show();
                          },
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(20)),
                                depth: 8,
                                lightSource: LightSource.topLeft,
                                color: Colors.white),
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xffFEC37B),
                                      Color(0xffFF4184),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  'Log Out',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                      height: 1.1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
