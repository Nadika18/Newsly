import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/services.dart';
// import 'dart:convert';
import 'news_detailed.dart';
import 'dart:async' show Future;
import 'models/1.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

String language = 'EN'; // NP or EN

class _HomeState extends State<Home> {
  int currentPage = 1;

  List<Widget> _widgetOptions = <Widget>[
    Text('Summary'),
    Text('Home'),
  ];

  @override
  void initState() {
    super.initState();
    SaveJson().fetchJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // The first text is to add even gap in the left as well
            Text(
              "EN",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.fromLTRB(0, 300, 0, 300),
              child: Text('Newsly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Kalam',
                    fontSize: 35,
                    color: Colors.white,
                  )),
            )),
            InkWell(
              onTap: () {
                setState(() {
                  if (language == 'NP')
                    language = 'EN';
                  else
                    language = 'NP';
                });
              },
              child: Text(language, style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        // toolbarHeight: 90,
        // backgroundColor: Colors.grey[300],
        bottom: const TabBar(
            isScrollable: true,
            padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Color.fromARGB(255, 255, 255, 255),
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              // Other flags
              // indicatorRadius: 1,
              // insets: EdgeInsets.all(1),
              // padding: EdgeInsets.all(10)
            ),
            tabs: [
              Tab(text: "All News"),
              Tab(text: "Popular"),
              Tab(text: "Politics"),
              Tab(text: "Tech"),
              Tab(text: "Sports"),
              Tab(text: "Entertainment"),
              Tab(text: "World"),
              Tab(text: "Business"),
              // Tab(text: "Health"),
              // Tab(text: "Literature"),
            ]),
      ),
      body: TabBarView(
        children: [
          ElevatedCard(category: 'all'),
          ElevatedCard(category: 'popular'),
          ElevatedCard(category: 'politics'),
          ElevatedCard(category: 'tech'),
          ElevatedCard(category: 'sports'),
          ElevatedCard(category: 'entertainment'),
          ElevatedCard(category: 'world'),
          ElevatedCard(category: 'business'),
          // ElevatedCard(category: 'health'),
          // ElevatedCard(category: 'literature'),
        ],
      ),
    );
  }
}

class NewsLoading {
  Future<List<News>> loadNews() async {
    // var url = Uri.parse('https://newsly.asaurav.com.np/api/news/');
    // var response = await http.get(url);
    // var jsonString = response.body;
    // final file = File('${directory.path}/2.json');
    // final contents = await file.readAsString();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/2.json');
    if (!file.existsSync()) await SaveJson().fetchJson();
    final jsonString = await file.readAsString();

    final jsonResponse = json.decode(jsonString);
    List<News> newsList = [];
    for (var news in jsonResponse) {
      News newsObj = News.fromJson(news);
      List<String> categoriesList = newsObj.categories.split(",");
      newsObj.categoriesList = categoriesList;
      newsList.add(newsObj);
    }
    return newsList;
  }

  Future<List<News>> loadSummary() async {
    // var url = Uri.parse('https://newsly.asaurav.com.np/api/news/');
    // var response = await http.get(url);
    // var jsonString = response.body;
    // final file = File('${directory.path}/2.json');
    // final contents = await file.readAsString();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/summary.json');
    if (!file.existsSync()) await SaveJson().fetchJsonSummary();
    final jsonString = await file.readAsString();

    final jsonResponse = json.decode(jsonString);
    List<News> newsList = [];
    for (var news in jsonResponse) {
      News newsObj = News.fromJson(news);
      List<String> categoriesList = newsObj.categories.split(",");
      newsObj.categoriesList = categoriesList;
      newsList.add(newsObj);
    }
    return newsList.sublist(1, 7);
  }
}

class ElevatedCard extends StatefulWidget {
  String category = "all";
  ElevatedCard({super.key, required String category}) {
    this.category = category;
  }

  @override
  State<ElevatedCard> createState() => _ElevatedCardState();
}

class _ElevatedCardState extends State<ElevatedCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: NewsLoading().loadNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //initialize newslist
            List<News>? newsList = snapshot.data;
            List<News>? newsListFiltered = snapshot.data
                ?.where((itm) =>
                    itm.language == language &&
                    (itm.categoriesList.contains(widget.category) ||
                        widget.category == 'all'))
                .toList();

            return Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                final directory = await getApplicationDocumentsDirectory();
                final file = File('${directory.path}/2.json');
                await SaveJson().fetchJson();
                final jsonString = await file.readAsString();

                final jsonResponse = json.decode(jsonString);
                List<News> data = [];
                for (var news in jsonResponse) {
                  News newsObj = News.fromJson(news);
                  List<String> categoriesList = newsObj.categories.split(",");
                  newsObj.categoriesList = categoriesList;
                  data.add(newsObj);
                }

                setState(() {
                  newsList = data;
                  newsListFiltered = data
                      .where((itm) =>
                          itm.language == language &&
                          (itm.categoriesList.contains(widget.category) ||
                              widget.category == 'all'))
                      .toList();
                  print(newsListFiltered);
                });
              },
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: newsListFiltered!.length,
                  itemBuilder: (context, index) {
                    News news = newsListFiltered![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailedView(news: news)));
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                //return news.title
                                title: Text(
                                  news.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(news.author),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: CachedNetworkImage(
                                            imageUrl: news.imagePath,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    'assets/image_failed.png'),
                                          ),
                                        )),
                                    const SizedBox(height: 20),
                                    Text(
                                        '${news.description.characters.take(200)}...'),
                                    const SizedBox(height: 20),
                                  ])),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
