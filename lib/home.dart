import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:newsportal/article.dart';
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
        title: const Text("Newsly"),
        bottom: const TabBar(tabs: [
          Tab(text: "For You"),
          Tab(text: "Popular"),
          Tab(text: "Saved"),
          Tab(text: "Tech")
        ]),
      ),
      body: TabBarView(
        children: [
          ListView(
            children: const <Widget>[
              ElevatedCard(),
              ElevatedCard(),
              ElevatedCard(),
              ElevatedCard(),
            ],
          ),
          const Text("Popular"),
          const Text("Saved"),
          const Text("Tech")
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
class NewsLoading{
  Future<News> loadNews() async{
    String jsonString=await _loadData();
    final jsonResponse=json.decode(jsonString);
    News news=News.fromJson(jsonResponse);
    return news;
  }
}

class ElevatedCard extends StatefulWidget {
  const ElevatedCard({super.key});

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
            builder: (context, AsyncSnapshot<News> snapshot) {
              if (snapshot.hasData) {
               //initialize news
                News? news = snapshot.data;
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                     ListTile(
                        //return news.title
                        title: Text(news!.title),
                        subtitle: Text(news.author),
                      ),
                      Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                    image: AssetImage(news.imagePath))),
                            const SizedBox(height: 20),
                            Text(
                                news.description)
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
        appBar: AppBar(title: const Text("Newsly")), body: ElevatedCard());
  }
}
