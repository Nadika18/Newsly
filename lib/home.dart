import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:newsportal/article.dart';
import 'models/1.dart';
import 'dart:async' show Future;

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

class ElevatedCard extends StatefulWidget {
  const ElevatedCard({super.key});

  @override
  State<ElevatedCard> createState() => _ElevatedCardState();
}

// Future<String> _loadData() async {
//   return await rootBundle.loadString('assets/1.json');
// }

class _ElevatedCardState extends State<ElevatedCard> {
  // Future loadData() async {
  //   String jsonString = await _loadData();
  //   final jsonResponse = json.decode(jsonString);
  //   News news = News.fromJson(jsonResponse);
  //   print('${news.title}');
  // }

  // void initState() {
  //   super.initState();
  //   loadData();
  // }

  @override

  // final growableList= <NewsCategory>[]

  Widget build(BuildContext context) {
    // return Container(
    //   child:Column(children:[
    //   Text('${news.title}'),
    return GestureDetector(
      onTap:(){
        Navigator.push(
          context,
        MaterialPageRoute(builder:(context)=> const NewsDetailedView()));
      },
      child:Card(
      
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Author | Published Date'),
          ),
          Container(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: const Image(image: AssetImage("assets/image1.png"))),
                const SizedBox(height: 20),
                const Text(
                    "Some quick example text to build on the card Some quick example text to build on the card Some quick example text to build on the card Some quick example text to build on the card")
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('READ'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const Article();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('LISTEN'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    ));
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
      appBar:AppBar(title: const Text("Newsly")) ,
    body:ElevatedCard()
    );
  }
}