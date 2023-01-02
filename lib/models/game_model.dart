import 'package:flutter/cupertino.dart';

class GameModels with ChangeNotifier {
  final String id,
      team1Title,
      team2Title,
      gameDate,
      gameTime,
      eventToOccur,
      eventOutCome,
      odd;

  // ignore: prefer_typing_uninitialized_variables
  final thumbsUpM;
  // ignore: prefer_typing_uninitialized_variables
  final thumbsDownM;
  bool isHistory;

  GameModels({
    required this.id,
    required this.team1Title,
    required this.team2Title,
    required this.gameDate,
    required this.gameTime,
    required this.eventToOccur,
    required this.eventOutCome,
    required this.odd,
    this.thumbsUpM,
    this.thumbsDownM,
    required this.isHistory,
  });
}
