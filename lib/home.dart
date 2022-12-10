import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:newsportal/article.dart';
import 'dart:convert';
import 'dart:async' show Future;
// import 'news.dart';
import 'models/1.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 1;

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
        bottom: const TabBar(tabs: [
          Tab(text: "For You"),
          Tab(text: "Popular"),
          Tab(text: "Saved"),
          Tab(text: "Tech")
        ]),
      ),
      body: TabBarView(
        children: [
          ElevatedCard(category: 'all'),
          ElevatedCard(category: 'popular'),
          ElevatedCard(category: 'saved'),
          ElevatedCard(category: 'tech'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.summarize_outlined), label: 'Summary'),
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}

Future<String> _loadData() async {
  return await rootBundle.loadString('assets/1.json');
}

class NewsLoading {
  Future<List<News>> loadNews() async {
    String jsonString = await _loadData();
    final jsonResponse = json.decode(jsonString);
    List<News> newsList = [];
    for (var news in jsonResponse) {
      News newsObj = News.fromJson(news);
      List<String> categoriesList = newsObj.categories.split(" ");
      newsObj.categoriesList = categoriesList;
      newsList.add(newsObj);
    }
    return newsList;
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
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewsDetailedView()));
        },
        child: FutureBuilder(
            future: NewsLoading().loadNews(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //initialize newslist
                List<News>? newsList = snapshot.data;
                List<News>? newsListFiltered = snapshot.data
                    ?.where((itm) =>
                        itm.categoriesList.contains(widget.category) ||
                        widget.category == 'all')
                    .toList();

                return Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: newsListFiltered!.length,
                        itemBuilder: (context, index) {
                          News news = newsListFiltered[index];
                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  //return news.title
                                  title: Text(news.title),
                                  subtitle: Text(news.author),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image(
                                              image:
                                                  AssetImage(news.imagePath))),
                                      const SizedBox(height: 20),
                                      Text(news.description)
                                    ])),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('READ'),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NewsDetailedView()));
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      child: const Text('SAVE'),
                                      onPressed: () {
                                        // setState(() {
                                        //   _saved.add(pair);
                                        // });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class NewsDetailedView extends StatefulWidget {
  const NewsDetailedView({super.key});

  @override
  State<NewsDetailedView> createState() => _NewsDetailedViewState();
}

class _NewsDetailedViewState extends State<NewsDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Newsly")), body: Text('Insider'));
  }
}
