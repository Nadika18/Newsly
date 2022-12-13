import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'home.dart';
import '/models/1.dart';
import 'news_detailed.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
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
        body: Center(
            child: FutureBuilder(
                future: NewsLoading().loadNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //initialize newslist
                    List<News>? newsList = snapshot.data;

                    return Corousel(newsList: newsList);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })));
  }
}

class Corousel extends StatelessWidget {
  final List<News>? newsList;
  const Corousel({super.key, required this.newsList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 450,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: true,
        // autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                          builder: (context) => NewsDetailedView(news: news)));
                },
                child: SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              //return news.title
                              title: Text(
                                '${news.title}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text('${news.author}'),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                            '${news.imagePath}',
                                            fit: BoxFit.cover),
                                      )),
                                  const SizedBox(height: 20),
                                  Text(
                                      '${news.summary.characters.take(300)}...')
                                ])),
                          ],
                        ),
                      )),
                ));
          },
        );
      }).toList(),
    );
    ;
  }
}
