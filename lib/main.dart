import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:percent_indicator/percent_indicator.dart';

Album harryStyles = Album(title: 'Harry Styles', songNames: <String>[
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

Album fineLine = Album(title: 'Fine Line', songNames: <String>[
  "Golden",
  "Watermelon Sugar",
  "Adore You",
  "Lights Up",
  "Cherry",
  "Falling",
  "To Be So Lonely",
  "She",
  "Sunflower, Vol. 6",
  "Canyon Moon",
  "Treat People with Kindness",
  "Fine Line"
]);

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

  double gutters = 16;
  double margins = 16;
  double tabMargins = 0;
  bool isLandscape = false;

  Function onEnd = () => {};

  Album album = harryStyles;

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
    if (MediaQuery.of(context).size.width > 600) {
      setState(() {
        tabMargins = (MediaQuery.of(context).size.width - 600) / 2;
      });
      if (MediaQuery.of(context).size.width > 720) {
        setState(() {
          margins = 24;
        });
        if (MediaQuery.of(context).size.width > 1000)
          setState(() {
            gutters = 72;
          });
      }
    }
    if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height)
      setState(() {
        isLandscape = true;
      });
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        drawer: buildDrawer(),
        appBar: AppBar(
          backwardsCompatibility: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black54,
          brightness: Brightness.light,
          actions: [
            IconButton(
                color: Colors.black54,
                icon: Icon(Icons.undo),
                onPressed: () => setState(() {
                      album.build();
                    }))
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: gutters, right: tabMargins * 2 - gutters),
                  child: TabBar(
                    labelStyle: Theme.of(context)
                        .textTheme
                        .button
                        .apply(fontWeightDelta: 1),
                    labelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: EdgeInsets.only(bottom: 8),
                    tabs: [
                      Tab(
                        text: 'Contests',
                      ),
                      Tab(text: 'Ranking')
                    ],
                  ),
                ),
                LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width,
                    lineHeight: 4,
                    padding: EdgeInsets.zero,
                    curve: Curves.fastOutSlowIn,
                    linearStrokeCap: LinearStrokeCap.butt,
                    percent: album.progress,
                    animateFromLastPercent: true,
                    animation: true,
                    animationDuration: 250,
                    backgroundColor: Colors.pinkAccent.withOpacity(0.3),
                    progressColor: Colors.pinkAccent)
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: gutters, right: gutters),
              child: buildComparePage(),
            ),
            Padding(
              padding: EdgeInsets.only(left: gutters, right: gutters),
              child: buildRankPage(),
            )
          ],
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

  Drawer buildDrawer() => Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose album',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: Colors.white),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            buildAlbumTile(harryStyles),
            buildAlbumTile(fineLine),
          ],
        ),
      );

  ListTile buildAlbumTile(Album album) {
    return ListTile(
        title: Text(album.title),
        onTap: () {
          setState(() {
            this.album = album;
          });
        });
  }

  Widget buildComparePage() {
    List<Widget> children = <Widget>[
      SongCard(
        name: album.songNames[album.nextCombat.first],
        onTap: onTapFirst,
      ),
      SizedBox(
        height: margins,
        width: margins,
      ),
      SongCard(
        name: album.songNames[album.nextCombat.last],
        onTap: onTapSecond,
      ),
    ];

    return Padding(
      padding: EdgeInsets.only(top: margins, bottom: margins),
      child: AnimatedOpacity(
          curve: Curves.easeOutSine,
          opacity: cardOpacity,
          onEnd: onEnd,
          duration: Duration(milliseconds: 250),
          child: isLandscape
              ? Row(
                  children: children,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: children)),
    );
  }

  Widget buildRankPage() {
    return Padding(
      padding: EdgeInsets.only(top: margins),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        margin: EdgeInsets.zero,
        child: ListView(
          children: buildRankTiles(),
        ),
      ),
    );
  }

  List<Widget> buildRankTiles() {
    var result = <Widget>[];
    if (album.progress > 0.3) {
      for (var i = 0; i < album.songs.length; i++) {
        result.add(RankTile(
            index: i,
            title: album.topList[i].name,
            score: album.topList[i].score));
      }
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
      // dense: true,
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
      // subtitle: Text((score * 100).round().toString()),
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
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          // splashColor: Colors.greenAccent,
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
