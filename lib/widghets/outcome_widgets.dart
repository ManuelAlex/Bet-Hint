import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/m_providers/bookings_provider.dart';
import 'package:bet_hint/models/game_model.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OutcomeWidget extends StatefulWidget {
  const OutcomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<OutcomeWidget> createState() => _OutcomeWidgetState();
}

class _OutcomeWidgetState extends State<OutcomeWidget> {
  bool ispressdThumbsUp = false;
  bool ispressdThumbsDown = false;
  final User? user = authInstance.currentUser;

  // @override
  // void initState() {
  //
  //   final gameProvider = Provider.of<GameFeedProviders>(context, listen: false);
  //   gameProvider.fetchgame();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final gameFeedCardModels = Provider.of<GameModels>(context);
    final bookingsProvider = Provider.of<BookingsProvider>(context);

    bookingsProvider.getBookingsItems.containsKey(gameFeedCardModels.id);
    Color color = Utils(context).color;

    return Card(
      elevation: 5,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: gameFeedCardModels.team1Title,
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget(text: "vs ", color: Colors.cyan, textSize: 15),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget(
                    text: gameFeedCardModels.team2Title,
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                text: gameFeedCardModels.gameDate +
                    '' +
                    gameFeedCardModels.gameTime,
                color: color,
                textSize: 15,
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                text: gameFeedCardModels.eventToOccur,
                color: color,
                textSize: 16,
                isTitle: true,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  TextWidget(
                    text: "Odd:",
                    color: color,
                    textSize: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget(
                    text: gameFeedCardModels.odd.toString(),
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidget(
                text: gameFeedCardModels.eventOutCome,
                color: gameFeedCardModels.eventOutCome.length.isEven
                    ? Colors.red
                    : Colors.blue,
                textSize: 16,
                isTitle: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
