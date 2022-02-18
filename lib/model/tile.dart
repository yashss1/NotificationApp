import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Tile extends StatefulWidget {
  const Tile({Key? key, required this.photo, required this.name})
      : super(key: key);

  final String photo, name;

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          depth: 8,
          lightSource: LightSource.topLeft,
          color: Colors.white),
      child: Container(
        width: deviceWidth * .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Hero(
                    tag: 'profile',
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(100, 94, 94, 1),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.photo),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.name,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
