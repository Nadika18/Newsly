import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'models/1.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

final player = AudioPlayer();
bool isPlaying = false;
Duration duration = Duration.zero;
Duration position = Duration.zero;

List<int> savedNewsID = [];

void writeFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/saved.json');
  file.writeAsBytes(savedNewsID);
}

class NewsDetailedView extends StatefulWidget {
  dynamic news = '';
  NewsDetailedView({super.key, required News news}) {
    this.news = news;
  }

  @override
  State<NewsDetailedView> createState() => _NewsDetailedViewState();
}

class _NewsDetailedViewState extends State<NewsDetailedView>
    with TickerProviderStateMixin {
  final player = AudioPlayer();
  bool isPlaying = false; // true when media is playing
  bool isBusy = false; // true when we're awaiting media
  bool isSaved = false; // true when news is saved
  bool isFullNews = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    Future<http.Response> createAlbum(String title) {
      return http.post(
        Uri.parse('https://newsly.asaurav.com.np/api/interactions/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'news': widget.news.id,
          'user': 'aabhusan',
        }),
      );
    }

    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    @override
    void StatefulPause() {
      setState(() {
        isPlaying = false;
      });
    }

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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(2.0),
              ),
              ListTile(
                title: Text(
                  widget.news.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: CachedNetworkImage(
                      imageUrl: widget.news.imagePath,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )),
              const SizedBox(height: 20),
              // subtitle
              ListTile(
                subtitle: Text('Author: ' +
                    widget.news.author +
                    ' \nPublished on: ' +
                    widget.news.created),
                trailing: Wrap(
                  spacing: 0,
                  children: <Widget>[
                    StatefulBuilder(
                      builder: (context, setState) => IconButton(
                        icon: isBusy
                            ? Icon(Icons.arrow_downward)
                            : !isPlaying
                                ? Icon(Icons.play_arrow)
                                : Icon(Icons.pause),
                        onPressed: () async {
                          if (!isBusy) {
                            if (!isPlaying && !isFullNews) {
                              setState(() {
                                isBusy = true;
                              });
                              await player
                                  .play(UrlSource(widget.news.summaryTts));
                              player.onPlayerComplete.listen((instance) {
                                isPlaying = false;
                                setState(() {});
                              });
                              setState(() {
                                isBusy = false;
                              });
                            } else if (!isPlaying && isFullNews) {
                              setState(() {
                                isBusy = true;
                              });
                              await player
                                  .play(UrlSource(widget.news.fullBodyTts));

                              player.onPlayerComplete.listen((instance) {
                                isPlaying = false;
                                setState(() {});
                              });
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
                    ),

                    StatefulBuilder(
                      builder: (context, setState) => IconButton(
                          icon: isSaved
                              ? Icon(Icons.bookmark)
                              : Icon(Icons.bookmark_outline),
                          onPressed: () {
                            if (!isSaved) {
                              setState(() {
                                savedNewsID.add(widget.news.id);
                                writeFile();
                                isSaved = true;
                              });
                            } else {
                              setState(() {
                                savedNewsID.remove(widget.news.id);
                                writeFile();
                                isSaved = false;
                              });
                            }
                          }),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.all(12.0),
                    // ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 45,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: StatefulBuilder(
                          builder: (BuildContext context, setState) => TabBar(
                            onTap: (int index) {
                              setState(() {
                                if (isPlaying) {
                                  player.pause();
                                }
                                index == 0
                                    ? isFullNews = true
                                    : isFullNews = false;
                              });
                            },
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).primaryColor,
                            ),
                            controller: tabController,
                            isScrollable: true,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 30),
                            // ignore: prefer_const_literals_to_create_immutables
                            tabs: [
                              const Tab(
                                child: Text(
                                  "Full News",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const Tab(
                                child: Text(
                                  "Summary",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        ListView.builder(
                          // scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                child: Text(widget.news.description));
                          },
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              child: Text(widget.news.summary),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
