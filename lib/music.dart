import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MusicHome extends StatefulWidget {
  const MusicHome({super.key});

  @override
  State<MusicHome> createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {
  final player = AudioPlayer();
  int selectedindex = 0;
  List<String> bandNames = [
    'Imagine Dragons',
    'ODESZA',
    'ERICA REKINOS',
    'Riot Games',
  ];
  List<String> musicPoster = [
    'assets/Origins.png',
    'assets/moment.png',
    'assets/monster.png',
    'assets/valorant.png',
  ];
  List<String> musicNames = [
    'Origin',
    'Moment',
    'Monster',
    'Valorant',
  ];
  List<String> audioNames = [
    'believer.mp3',
    'moment.mp3',
    'shortwave.mp3',
    'valorant.mp3',
  ];
  IconData iconData = Icons.arrow_circle_right; // Initial icon
  int starting = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double slides = 0.0;
  bool isPlayed = false;
  bool isRepeated = false;
  final fontText = GoogleFonts.josefinSans(
      textStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20));
  final text = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  @override
  void initState() {
    super.initState();
    changingState();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  void changingState() {
    player.onDurationChanged.listen((Duration d) {
      setState(() {
        // if(isPlayed){
        duration = d;
        // }
        // else {
        duration = d;
        //}
      });
    });
    player.onPositionChanged.listen((Duration p) {
      setState(() {
        //if(isPlayed){
        position = p;

        //}
        //else {
        position = p;
        //}
      });
    });
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlayed = state == PlayerState.playing;
      });
    });
    player.onPlayerComplete.listen((event) {
      setState(() {
        isRepeated = false;
        stopRepeatedMusic();
        player.seek(Duration.zero); // Reset playback position
        player.stop(); // Stop playback
        iconData = Icons.arrow_circle_right; // Update icon
      });
    });
  }

  String formatTime(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    String formatDuration = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return formatDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Music',
          style: fontText,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: musicPoster.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: SizedBox(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              musicPoster[index],
                            ))),
                    subtitle: Text(bandNames[index]),
                    title: Text(
                      musicNames[index],
                      style: fontText,
                    ),
                    onTap: () {
                      setState(() {
                        selectedindex = index;
                        isPlayed = true;
                        playSound(selectedindex);
                      });
                    },
                  );
                }),
          ),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Column(
              children: [
                SliderTheme(
                  data: const SliderThemeData(
                      trackHeight: 2,
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 0.0)),
                  child: Slider(
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          final newPosition = Duration(seconds: value.toInt());
                          //move to specific position
                          player.seek(newPosition);
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position)),
                    Text(formatTime(duration - position)),
                    // Text('1'),
                    // Text('2')
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            height: 80,
                            width: 70,
                            child: Image.asset(musicPoster[selectedindex])),
                        Column(
                          children: [
                            Text(
                              musicNames[selectedindex],
                              style: fontText,
                            ),
                            Text(bandNames[selectedindex])
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isPlayed = !isPlayed;
                              if (isPlayed) {
                                playSound(selectedindex);
                              } else {
                                pauseSound();
                              }
                            });
                          },
                          icon: isPlayed == true
                              ? const Icon(Icons.pause)
                              : Icon(iconData),
                          iconSize: 45,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (selectedindex >0 && selectedindex < audioNames.length) {
                                  selectedindex--;
                                  //specify the current audio playing or which audio should be playing
                                } else  {
                                  selectedindex = audioNames.length - 1; //reset to last song
                                }
                                  player.setSource(
                                      AssetSource(audioNames[selectedindex]));
                                
                              });
                            },
                            icon: const Icon(Icons.arrow_back)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isRepeated = !isRepeated;
                                if (isRepeated) {
                                  repeatMusic();
                                } else {
                                  stopRepeatedMusic();
                                }
                              });
                            },
                            icon: isRepeated == false
                                ? const Icon(Icons.repeat)
                                : const Icon(Icons.repeat_on_outlined)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (selectedindex >= 0 &&
                                    selectedindex < audioNames.length - 1) {
                                  selectedindex++;
                                } else {
                                  selectedindex =
                                      0; // Reset to the first song when the end of the list is reached
                                }
                                player.setSource(
                                    AssetSource(audioNames[selectedindex]));
                              });
                            },
                            icon: const Icon(Icons.arrow_forward_outlined)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> playSound(int index) async {
    await player.play(AssetSource(audioNames[index]));
  }

  void pauseSound() {
    player.pause();
  }

  void repeatMusic() {
    player.setReleaseMode(ReleaseMode.loop);
  }

  void stopRepeatedMusic() {
    player.setReleaseMode(ReleaseMode.stop);
  }
}
