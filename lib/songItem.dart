import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_animation/song.dart';

class SongItem extends StatefulWidget {
  Song song;
  int count;
  bool delayAimation;

  SongItem(this.song, this.count, this.delayAimation);

  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> with TickerProviderStateMixin {
  Song song;
  GlobalKey containerKey = GlobalKey();
  Postion fromPostion;
  AnimationController moveController;
  AnimationController cdCotroller;

  @override
  void initState() {
    song = widget.song;
    moveController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fromPostion = getPositionFromKey(containerKey);
        if (widget.count == 1) {
          cdCotroller.forward();
        }
      }
    });

    cdCotroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    super.initState();
  }

  @override
  void dispose() {
    moveController.dispose();
    cdCotroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.delayAimation) {
      moveController.forward(from: 0);
    } else {
      cdCotroller.reverse();
    }

    return Container(
      key: containerKey,
      child: AnimatedBuilder(
          animation: moveController,
          builder: (context, snapshot) {
            double x = 0, y = 0;
            Postion currentPosition;
            if (containerKey.currentContext.findRenderObject() != null &&
                fromPostion != null) {
              currentPosition = getPositionFromKey(containerKey);
              x = fromPostion.x - currentPosition.x;
              y = fromPostion.y - currentPosition.y;
            }
            if (song.index!=0&&fromPostion != null &&
                fromPostion.x == currentPosition.x &&
                fromPostion.y == currentPosition.y &&
                moveController.status != AnimationStatus.completed) {
              return Container();
            }

            return Stack(
              children: <Widget>[
                Transform.translate(
                    offset: Offset(x * (1 - moveController.value),
                        y * (1 - moveController.value)),
                    child: buildImage()),
                buildTexts(x, y)
              ],
            );
          }),
    );
  }

  Widget buildImage() {
    double imageSize = 120;
    double cdSize = 100;
    double cdAnimation = 0;

    if (widget.count == 1) {
      imageSize = 120 + 40 * moveController.value;
      cdSize = 100 + 40 * moveController.value;
    } else {
      imageSize = 120 + 40 * (1 - moveController.value);
      cdSize = 100 + 40 * (1 - moveController.value);
      cdAnimation = moveController.value;
    }
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: 5,
          child: Image.asset(
            song.image,
            height: imageSize,
            width: imageSize,
          ),
        ),
        AnimatedBuilder(
            animation: cdCotroller,
            builder: (context, snapshot) {
              if (widget.count == 1) {
                cdAnimation = moveController.status == AnimationStatus.completed
                    ? cdCotroller.value
                    : 1 - moveController.value;
              }
              return Positioned(
                top: 10,
                left: (imageSize - cdSize / 1.7) * cdAnimation,
                child: Image.asset(
                  'images/cd.png',
                  width: cdSize,
                  height: cdSize,
                ),
              );
            }),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              width: imageSize,
              height: imageSize + 20,
              child: Image.asset(
                song.image,
                height: imageSize,
                width: imageSize,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildTexts(double x, double y) {
    double textsHeight = widget.count == 1
        ? 120 - 30 * (moveController.value)
        : 90 + 30 * moveController.value;
    return Transform.translate(
      offset: Offset(x * (1 - moveController.value),
          y * (1 - moveController.value) + textsHeight),
      //      top: textsHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              song.name,
              style: TextStyle(
                  color: widget.count == 1 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              song.by,
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class Postion {
  double x;
  double y;

  Postion(this.x, this.y);
}

Postion getPositionFromKey(GlobalKey key) {
  RenderBox box = key.currentContext.findRenderObject();
  Offset position = box.localToGlobal(Offset.zero);
  return Postion(position.dx, position.dy);
}
