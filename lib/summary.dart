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
bool isBusy = false;
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

  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    void playNews() async {
      if (!isPlaying) {
        if (!(currentIndex == newsList!.length - 1)) {
          setState(() {
            isBusy = true;
          });
          await player.play(UrlSource(newsList![currentIndex].summaryTts));
          setState(() {
            isBusy = false;
            isPlaying = true;
          });

          player.onPlayerComplete.listen((instance) {
            setState(() {
              isPlaying = false;
              // currentIndex++;
              // playNews();
              // buttonCarouselController.nextPage();
              // player.dispose();
            });
          });
        }
      } else {
        setState(() {
          isPlaying = false;
        });
        player.pause();
      }
    }

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
            Text('Flash News',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            Center(
                child: FutureBuilder(
                    future: NewsLoading().loadSummary(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //initialize newslist
                        newsList = snapshot.data;

                        return CarouselSlider(
                          carouselController: buttonCarouselController,
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
                            onPageChanged: (index, reason) {
                              currentIndex = index;
                              player.dispose();
                              isPlaying = false;
                              setState(() {});
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          items: newsList?.toList().sublist(0, 6).map((news) {
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
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
            ElevatedButton.icon(
              onPressed: playNews,
              icon: isBusy
                  ? Icon(Icons.arrow_downward, size: 24.0, color: Colors.white)
                  : !isPlaying
                      ? Icon(Icons.play_arrow, size: 24.0, color: Colors.white)
                      : Icon(Icons.pause, size: 24.0, color: Colors.white),
              label: Text('Hear News',
                  style: TextStyle(color: Colors.white)), // <-- Text
            )
          ],
        ));
  }
}
