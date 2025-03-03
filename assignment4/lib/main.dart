import 'package:assignment4/songs.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(Display());
}

class Display extends StatelessWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: DisplayScreen(),
    );
  }
}

class DisplayScreen extends StatefulWidget {
  DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  late AudioPlayer player;
  int Currindex = -1;
  List<Songs> songs = [
    Songs(
        title: "Only",
        songAsset: "asset/audio/only.mp3",
        img: "asset/image/lehi.jpg",
        author: "LeeHi"),
    Songs(
        title: "Fallin'",
        songAsset: "asset/audio/fall.mp3",
        img: "asset/image/fall.jpg",
        author: "Isaac Hong"),
    Songs(
        title: "Tell Me It's Not a dream",
        songAsset: "asset/audio/tell.mp3",
        img: "asset/image/tell.jpg",
        author: "10CM"),
    Songs(
        title: "Hold Me Back",
        songAsset: "asset/audio/hold.mp3",
        img: "asset/image/hold.jpg",
        author: "Heize"),
    Songs(
        title: "Love You With All My Heart",
        songAsset: "asset/audio/love.mp3",
        img: "asset/image/love.jpg",
        author: "Crush")
  ];

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.playerStateStream.listen((playerState) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5DE2DB),
        foregroundColor: Colors.black,
        title: Text(
          "My Songs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                var song = songs[index];
                bool isPlaying = Currindex == index && player.playing;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          song.title,
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          song.author,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(song.img))),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            if (isPlaying) {
                              await player.pause();
                              Currindex = -1;
                            } else {
                              if (Currindex != index) {
                                await player.stop();
                                await player.setAsset(song.songAsset);
                                Currindex = index;
                              }
                              await player.play();
                            }
                            setState(() {});
                          },
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                    ),
                    if (isPlaying) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: StreamBuilder<Duration>(
                          stream: player.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = player.duration ?? Duration.zero;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Slider(
                                  activeColor: Color(0xFF5DE2DB),
                                  value: position.inSeconds.toDouble(),
                                  min: 0.0,
                                  max: duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    final seekPosition =
                                        Duration(seconds: value.toInt());
                                    player.seek(seekPosition);
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.skip_previous),
                                      onPressed: () {

                                        final previousPosition = position -
                                            Duration(
                                                seconds:
                                                    10); 
                                        player.seek(previousPosition);
                                      },
                                    ),
                                    Text(
                                      position.toString().split('.').first +
                                          " / " +
                                          duration.toString().split('.').first,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.skip_next),
                                      onPressed: () {

                                        final nextPosition = position +
                                            Duration(
                                                seconds:
                                                    10); 
                                        player.seek(nextPosition);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
