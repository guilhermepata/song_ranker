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

Album upAllNight = Album(title: 'Up All Night', songNames: [
  "What Makes You Beautiful",
  "Gotta Be You",
  "One Thing",
  "More Than This",
  "Up All Night",
  "I Wish",
  "Tell Me a Lie",
  "Taken",
  "I Want",
  "Everything About You",
  "Same Mistakes",
  "Save You Tonight",
  "Stand Up",
  "Moments",
  "Another World",
  "Na Na Na",
  "I Should Have Kissed You",
]);

Album takeMeHome = Album(title: 'Take Me Home', songNames: [
  "Live While We're Young",
  "Kiss You",
  "Little Things",
  "C'mon, C'mon",
  "Last First Kiss",
  "Heart Attack",
  "Rock Me",
  "Change My Mind",
  "I Would",
  "Over Again",
  "Back for You",
  "They Don't Know About Us"
]);

Album midnightMemories = Album(title: 'Midnight Memories', songNames: [
  "Best Song Ever",
  "Story of My Life",
  "Diana",
  "Midnight Memories",
  "You & I",
  "Don't Forget Where You Belong",
  "Strong",
  "Happily",
  "Right Now",
  "Little Black Dress",
  "Through The Dark",
  "Something Great",
  "Little White Lies",
  "Better Than Words",
]);

Album four = Album(title: 'Four', songNames: [
  "Steal My Girl",
  "Ready to Run",
  "Where Do Broken Hearts Go",
  "18",
  "Girl Almighty",
  "Fool's Gold",
  "Night Changes",
  "No Control",
  "Fireproof",
  "Spaces",
  "Stockholm Syndrome",
  "Clouds"
]);

Album madeInTheAm = Album(title: 'Made In The AM', songNames: [
  "Hey Angel",
  "Drag Me Down",
  "Perfect",
  "Infinity",
  "End of the Day",
  "If I Could Fly",
  "Long Way Down",
  "Never Enough",
  "Olivia",
  "What a Feeling",
  "Love You Goodbye",
  "I Want to Write You a Song",
  "History"
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
  int albumIndex = 0;

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

  void onUndo() {
    setState(() {
      onEnd = () => {
            setState(() {
              album.undoLastCombat();
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
    } else {
      setState(() {
        tabMargins = 0;
        margins = 16;
        gutters = 16;
      });
    }
    if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height)
      setState(() {
        isLandscape = true;
      });
    else
      setState(() {
        isLandscape = false;
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
              onPressed: onUndo,
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Column(
              children: [
                Padding(
                  padding: tabMargins > 0
                      ? EdgeInsets.only(
                          left: gutters, right: tabMargins * 2 - gutters)
                      : EdgeInsets.zero,
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
            buildRankPage()
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
            buildAlbumTile(harryStyles, 0),
            buildAlbumTile(fineLine, 1),
            buildAlbumTile(upAllNight, 2),
            buildAlbumTile(takeMeHome, 3),
            buildAlbumTile(midnightMemories, 4),
            buildAlbumTile(four, 5),
            buildAlbumTile(madeInTheAm, 6),
          ],
        ),
      );

  ListTile buildAlbumTile(Album album, index) {
    return ListTile(
        selected: index == albumIndex,
        title: Text(album.title),
        onTap: () {
          setState(() {
            this.album = album;
            albumIndex = index;
          });
          Navigator.of(context).pop();
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
    return ListView(
      children: [
        SizedBox(height: margins),
        Padding(
          padding: EdgeInsets.only(left: gutters, right: gutters),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              children: buildRankTiles(),
            ),
          ),
        ),
        SizedBox(height: margins),
      ],
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
