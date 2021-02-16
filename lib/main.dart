import 'package:flutter/material.dart';
import 'classes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double cardOpacity = 1;

  int pageIndex = 0;

  Function onEnd = () => {};

  Album album = Album(<String>[
    'Meet Me in the Hallway',
    'Sign of the Times',
    'Carolina',
    'Two Ghosts',
    'Sweet Creature',
    'Only Angel',
    'Kiwi',
    'Ever Since New York',
    'Woman',
    'From the Dining Table'
  ]);

  void onTapFirst() {
    setState(() {
      onEnd = () => {
            setState(() {
              album.runNextCombat(true);
              onEnd = () => {};
              cardOpacity = 1;
            })
          };

      cardOpacity = 0;
    });
  }

  void onTapSecond() {
    setState(() {
      onEnd = () => {
            setState(() {
              album.runNextCombat(false);
              onEnd = () => {};
              cardOpacity = 1;
            })
          };

      cardOpacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.undo),
                onPressed: () => setState(() {
                      album.build();
                    }))
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'CONTESTS',
              ),
              Tab(text: 'RANKING')
            ],
          ),
        ),
        body: TabBarView(
          children: [buildComparePage(), buildRankPage()],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   showUnselectedLabels: false,
        //   onTap: (index) => {
        //     setState(() {
        //       pageIndex = index;
        //     })
        //   },
        //   currentIndex: pageIndex,
        //   items: [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.compare_arrows_rounded), label: 'Constests'),
        //     BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Ranking')
        //   ],
        // ),
      ),
    );
  }

  AnimatedOpacity buildComparePage() {
    return AnimatedOpacity(
        curve: Curves.easeOutSine,
        opacity: cardOpacity,
        onEnd: onEnd,
        duration: Duration(milliseconds: 250),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SongCard(
              name: album.songNames[album.nextCombat.first],
              onTap: onTapFirst,
            ),
            SongCard(
              name: album.songNames[album.nextCombat.last],
              onTap: onTapSecond,
            ),
          ],
        ));
  }

  Stack buildRankPage() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
              ),
            )
          ],
        ),
        SingleChildScrollView(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: buildRankTiles(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildRankTiles() {
    var result = <Widget>[];
    for (var i = 0; i < album.songs.length; i++) {
      if (album.topList[i].contests.length > album.songs.length / 2)
        result.add(RankTile(
            index: i,
            title: album.topList[i].name,
            score: album.topList[i].score));
    }
    return result;
  }
}

class RankTile extends StatelessWidget {
  final int index;
  final String title;
  final double score;

  const RankTile({
    Key key,
    @required this.index,
    @required this.title,
    this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: 24,
          child: Text(
            (index + 1).toString(),
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.right,
          ),
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.subtitle1),
      subtitle: Text((score * 100).round().toString()),
    );
  }
}

class SongCard extends StatelessWidget {
  final String name;
  final Function onTap;

  const SongCard({
    Key key,
    this.name = 'Song title',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          // splashColor: Colors.greenAccent,
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(name,
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.left),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
