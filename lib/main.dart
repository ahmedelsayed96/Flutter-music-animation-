import 'package:flutter/material.dart';
import 'package:music_animation/song.dart';
import 'package:music_animation/songItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 2;

  bool delayAimation =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[buildToolBar(), buildGrid()],
    );
  }

  Widget buildToolBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Text(
              'Albums',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            InkWell(
                onTap: ()  async {
                  setState(() {
                    delayAimation=count ==1 ?true:false;
                  });
                  if(count==1){
                    await Future.delayed(Duration(milliseconds: 400));

                  }
                  setState(() {
                    delayAimation =false;
                    count == 1 ? count = 2 : count = 1;
                  });
                },
                child: Image.asset(count==1?'images/icon.png':'images/list_icon.png')),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget buildGrid() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.count(
        crossAxisCount: count,
        childAspectRatio: count ==2 ?150/170 :150/75,
        children: getSongs().map((e) => SongItem(e,count,delayAimation)).toList(),
      ),
    ));
  }

  List<Song> getSongs() {
    List<Song> songs = [];
    songs.add(Song(0, 'Starboy', 'by Daft Punk', 'images/starboy.png'));
    songs.add(
        Song(1, 'Girls Like You', 'by Maroon 5', 'images/girl_like_you.png'));
    songs.add(Song(2, 'Senorit', 'by Camila & Shawn', 'images/senorit.png'));
    songs.add(Song(3, 'Love me like you do', 'by Ellie Goulding',
        'images/love_me_like.png'));
    songs.add(Song(4, 'Happier', 'by Marshmello', 'images/happier.png'));
    songs.add(
        Song(5, 'Shape of you', 'by Ed Sheeran', 'images/shape_of_you.png'));

    return songs;
  }
}
