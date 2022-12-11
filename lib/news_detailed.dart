import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'models/1.dart';

final player = AudioPlayer();
bool isPlaying = false;
Duration duration = Duration.zero;
Duration position = Duration.zero;

class NewsDetailedView extends StatefulWidget {
  dynamic news = '';
  NewsDetailedView({super.key, required News news}) {
    this.news = news;
  }

  @override
  State<NewsDetailedView> createState() => _NewsDetailedViewState();
}

class _NewsDetailedViewState extends State<NewsDetailedView> {
  final player = AudioPlayer();
  bool isPlaying = false; // true when media is playing
  bool isBusy = false; // true when we're awaiting media
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.news.title}'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
            child: IconButton(
                icon: isBusy
                    ? Icon(Icons.arrow_downward)
                    : isPlaying
                        ? Icon(Icons.pause)
                        : Icon(Icons.play_arrow),
                onPressed: () async {
                  if (!isBusy) {
                    if (!isPlaying) {
                      setState(() {
                        isBusy = true;
                      });
                      await player.play(UrlSource(widget.news.fullBodyTts));
                      setState(() {
                        isBusy = false;
                      });
                    } else {
                      await player.pause();
                    }
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  }
                })));
  }
}
