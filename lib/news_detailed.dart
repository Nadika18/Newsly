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
  bool isSaved = false; // true when news is saved
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
          // title: Text('${widget.news.title}'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          // toolbarHeight: 90,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Card(
                child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(2.0),
          ),
          ListTile(
            title: Text(
              widget.news.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(widget.news.imagePath, fit: BoxFit.cover),
              )),
          const SizedBox(height: 20),
          // subtitle
          ListTile(
            subtitle: Text('Author: ' +
                widget.news.author +
                ' \nPublished at: ' +
                widget.news.created),
            trailing: Wrap(
              spacing: 0,
              children: <Widget>[
                IconButton(
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
                  },
                ),
                IconButton(
                    icon: isSaved
                        ? Icon(Icons.bookmark)
                        : Icon(Icons.bookmark_outline),
                    onPressed: () {
                      if (!isSaved) {
                        setState(() {
                          isSaved = true;
                        });
                      } else {
                        setState(() {
                          isSaved = false;
                        });
                      }
                    }),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(widget.news.description)),
        ]))));
  }
}
