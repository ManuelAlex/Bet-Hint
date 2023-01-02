import 'package:bet_hint/models/game_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GameFeedProviders with ChangeNotifier {
  static List<GameModels> _gamesCardList = [];

  List<GameModels> get getGameModels {
    return _gamesCardList
        .where((element) => element.isHistory == false)
        .toList();
  }

  //fetch data from firebase
  Future<void> fetchgame() async {
    try {
      final gameFeedDoc =
          await FirebaseFirestore.instance.collection('games').get();
      if (gameFeedDoc.docs.isEmpty) {
        return;
      } else {
        await FirebaseFirestore.instance
            .collection('games')
            .get()
            .then((QuerySnapshot gameSnapshot) {
          _gamesCardList = [];
          for (var element in gameSnapshot.docs) {
            _gamesCardList.insert(
                0,
                GameModels(
                  id: element.get('id'),
                  team1Title: element.get('team1Title'),
                  team2Title: element.get('team2Title'),
                  gameDate: element.get('gameDate'),
                  gameTime: element.get('gameTime'),
                  eventToOccur: element.get('eventToOccur'),
                  odd: element.get('odd'),
                  eventOutCome: element.get('eventOutCome'),
                  thumbsDownM: element.get('thumbsDown'),
                  thumbsUpM: element.get('thumbsUp'),
                  isHistory: element.get('isHistory'),
                ));
          }
        });
        notifyListeners();
      }
    } catch (error) {
      //
    }
  }

  GameModels findGameDetailsById(String gameModelId) {
    return _gamesCardList.firstWhere((element) => element.id == gameModelId);
  }

  List<GameModels> sortLikes() {
    List<GameModels> likeList =
        _gamesCardList.where((element) => element.isHistory == false).toList();
    likeList.sort(((a, b) => b.thumbsUpM.length.compareTo(a.thumbsUpM.length)));

    // _gamesCardList
    //     .where(((element) => element.thumbsUpM.length > 1))
    //     .toList()
    //     .reversed
    //     .toList();

    return likeList;
  }

  static List<GameModels> searchGameQuery(String searchText) {
    List<GameModels> searchTitle1List = _gamesCardList
        .where((element) =>
            element.team1Title.toLowerCase().contains(searchText.toLowerCase()))
        .toList()
        .reversed
        .toList();

    List<GameModels> searchTitle2List = _gamesCardList
        .where((element) =>
            element.team2Title.toLowerCase().contains(searchText.toLowerCase()))
        .toList()
        .reversed
        .toList();

    return searchTitle1List + searchTitle2List;
  }

  List<GameModels> fetchGameHistory() {
    List<GameModels> gameHistory =
        _gamesCardList.where((element) => element.isHistory == true).toList();
    // _gameWin.where((element) => element.eventOutCome == 'Win').toList();

    // List<GameModels> _gameLose =
    //     _gamesCardList;
    // _gameLose.where((element) => element.eventOutCome == 'Lose').toList();

    return gameHistory;
  }

  Future<void> thumbsUpFunc(
      String gameDetailsId, String uid, List thumbsUp, List thumbsDown) async {
    try {
      if (thumbsDown.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('games')
            .doc(gameDetailsId)
            .update({
          'thumbsDown': FieldValue.arrayRemove([uid]),
        });
      }
      if (!thumbsUp.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('games')
            .doc(gameDetailsId)
            .update({
          'thumbsUp': FieldValue.arrayUnion([uid]),
        });

        await fetchgame();
      } else {
        await FirebaseFirestore.instance
            .collection('games')
            .doc(gameDetailsId)
            .update({
          'thumbsUp': FieldValue.arrayRemove([uid]),
        });

        await fetchgame();
        notifyListeners();
      }
    } catch (error) {
      // print(
      //   error.toString(),
      // );
    }
  }

  Future<void> thumbsDownFunc(
      String gameDetailsId, String uid, List thumbsUp, List thumbsDown) async {
    try {
      if (thumbsUp.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('games')
            .doc(gameDetailsId)
            .update({
          'thumbsUp': FieldValue.arrayRemove([uid]),
        });
      }

      if (!thumbsDown.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('games')
            .doc(gameDetailsId)
            .update({
          'thumbsDown': FieldValue.arrayUnion([uid]),
        });
        await fetchgame();
      } else {
        await FirebaseFirestore.instance
            .collection('games')
            .doc(gameDetailsId)
            .update({
          'thumbsDown': FieldValue.arrayRemove([uid])
        });

        await fetchgame();
        notifyListeners();
      }
    } catch (error) {
      // print(
      //   error.toString(),
      // );
    }
  }

  // static final List<GameModels> _GamesCardList = [
  //   // GameModels(
  //       id: '123a',
  //       team1Title: 'Arsenal',
  //       team2Title: 'Leichester',
  //       gameDateTime: '15 Sep,7:30 PM',
  //       eventToOccur: 'A lacazette to score for Arseal',
  //       odd: 1.85),
  //   GameModels(
  //       id: '1234ab',
  //       team1Title: 'Arsenal',
  //       team2Title: 'Leichester',
  //       gameDateTime: '15 Sep,9:30 PM',
  //       eventToOccur: 'Over 1.5',
  //       odd: 1.2),
  //   GameModels(
  //       id: '12345abc',
  //       team1Title: 'Maimoe FF',
  //       team2Title: 'Kalmar FF',
  //       gameDateTime: '15 Sep,7:30 PM',
  //       eventToOccur: '1 & Over 2.5',
  //       odd: 2.05),
  //   GameModels(
  //       id: '123456abcd',
  //       team1Title: 'Nice',
  //       team2Title: 'Troyes',
  //       gameDateTime: '15 Sep,7:30 PM',
  //       eventToOccur: 'Over 1.5 goals',
  //       odd: 1.29),
  //   GameModels(
  //       id: '1234567abcde',
  //       team1Title: 'Chelsea',
  //       team2Title: 'salspurs',
  //       gameDateTime: '15 Sep,7:30 PM',
  //       eventToOccur: 'Under 1.5',
  //       odd: 2.08),
  //   GameModels(
  //       id: '12345678abcdef',
  //       team1Title: 'Liverpool',
  //       team2Title: 'Manchester City',
  //       gameDateTime: '15 Sep,7:30 PM',
  //       eventToOccur: 'M Sala to Score for Liverpool',
  //       odd: 1.75),
  // ];
}
