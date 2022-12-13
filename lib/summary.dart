import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'home.dart';
import '/models/1.dart';
import 'news_detailed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

final player = AudioPlayer();
bool isPlaying = false;
Duration duration = Duration.zero;
Duration position = Duration.zero;
int currentIndex = 0;
List<News>? newsList;

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void playNews() async {
    if (!isPlaying) {
      if (!(currentIndex == newsList!.length - 1)) {
        setState(() {
          isPlaying = true;
        });
        await player.play(UrlSource(newsList![currentIndex].summaryTts));
        player.onPlayerComplete.listen((instance) {
          isPlaying = false;
          currentIndex += 1;
          playNews();
        });
      }
    } else {
      setState(() {
        isPlaying = false;
      });
      player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Padding(
            padding: EdgeInsets.fromLTRB(0, 300, 0, 300),
            child: Text('Newsly',
                style: TextStyle(
                  fontFamily: 'Kalam',
                  fontSize: 35,
                  color: Colors.white,
                )),
          )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Placeholder invisible text for better alignment of other sibling items',
                style: TextStyle(color: Colors.black.withOpacity(0))),
            Center(
                child: FutureBuilder(
                    future: NewsLoading().loadNews(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //initialize newslist
                        newsList = snapshot.data;

                        return Carousel(
                            newsList: snapshot.data as List<News>?
                        ); 
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
            ElevatedButton.icon(
              onPressed: playNews,
              icon: Icon(
                  // <-- Icon
                  isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined,
                  size: 24.0,
                  color: Colors.white),
              label: Text('Hear News',
                  style: TextStyle(color: Colors.white)), // <-- Text
            )
          ],
        ));
  }
}

class Carousel extends StatelessWidget {
  final List<News>? newsList;
  const Carousel({super.key, this.newsList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
                          options: CarouselOptions(
                            height: 500,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay: false,
                            // autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            // onPageChanged: callbackFunction,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: newsList?.toList().map((news) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailedView(news: news)));
                                  },
                                  child: SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          height: max(500, 1000)),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                          child: Card(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
                                                  //return news.title
                                                  title: Text(
                                                    '${news.title}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  subtitle:
                                                      Text('${news.author}'),
                                                ),
                                                Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 10, 0),
                                                    child: Column(children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: AspectRatio(
                                                            aspectRatio: 16 / 9,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: news
                                                                  .imagePath,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                      '/assets/image_failed.png'),
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                          height: 20),
                                                      Text('${news.summary}')
                                                    ])),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
  }
}