class Album {
  final List<Song> songs = List<Song>();
  final List<String> songNames;
  final String artUrl;
  final Set<Set<int>> pairs = Set<Set<int>>();
  final List<Set<int>> possiblePairs = List<Set<int>>();
  int index = 0;

  Album(this.songNames, {this.artUrl = ''}) {
    for (var i = 0; i < songNames.length; i++) {
      songs.add(Song(songNames[i]));
      for (var j = i + 1; j < songNames.length; j++) {
        possiblePairs.add([i, j].toSet());
      }
    }
    possiblePairs.shuffle();
  }

  void build() {
    songs.clear();
    possiblePairs.clear();
    pairs.clear();
    for (var i = 0; i < songNames.length; i++) {
      songs.add(Song(songNames[i]));
      for (var j = i + 1; j < songNames.length; j++) {
        possiblePairs.add([i, j].toSet());
      }
    }
    possiblePairs.shuffle();
  }

  double get progress {
    return pairs.length / possiblePairs.length;
  }

  List<Song> get topList {
    List<Song> list = List<Song>();
    list.addAll(songs);
    list.sort((a, b) => ((b.score - a.score) * 100).round());
    return list;
  }

  void combat(int ind1, int ind2, bool winnerIsFirst) {
    Song.combat(songs[ind1], songs[ind2], winnerIsFirst);
    Set newPair = [ind1, ind2].toSet();
    pairs.add(newPair);
    if (winnerIsFirst)
      print(songNames[ind1] + ' won against ' + songNames[ind2]);
    else
      print(songNames[ind2] + ' won against ' + songNames[ind1]);
  }

  Set<int> get nextCombat {
    return possiblePairs[index];
  }

  void runNextCombat(bool winnerIsFirst) {
    int ind1 = nextCombat.first;
    int ind2 = nextCombat.last;
    combat(ind1, ind2, winnerIsFirst);
    if (index < possiblePairs.length - 1) {
      index++;
    } else {
      index = 0;
      possiblePairs.shuffle();
    }
    print('Combat on screen is: ' +
        songNames[nextCombat.first] +
        ' vs ' +
        songNames[nextCombat.last]);
  }
}

class Song {
  final String name;
  final Map<Song, Tally> contests = Map<Song, Tally>();

  Song(this.name);

  addCombat(Song song, bool won) {
    if (contests.containsKey(song)) {
      contests[song].total++;
    } else {
      contests[song] = Tally();
      contests[song].total = 1;
    }
    if (won) contests[song].wins++;
  }

  double get score {
    var keys = contests.keys;
    var result = 0.0;
    for (var i = 0; i < keys.length; i++) {
      result = result + contests[keys.toList()[i]].score;
    }
    if (keys.length > 0)
      return result / keys.length;
    else
      return result;
  }

  static combat(Song s1, Song s2, bool winnerIsFirst) {
    s1.addCombat(s2, winnerIsFirst);
    s2.addCombat(s1, !winnerIsFirst);
  }

  @override
  String toString() {
    return name;
  }
}

class Tally {
  int total = 0;
  int wins = 0;
  double get score {
    if (total > 0)
      return wins / total;
    else
      return 0;
  }
}
