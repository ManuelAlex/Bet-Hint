import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/m_providers/bookings_provider.dart';
import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/models/game_model.dart';
import 'package:bet_hint/screens/details_screen.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BetListWidget extends StatefulWidget {
  const BetListWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BetListWidget> createState() => _BetListWidgetState();
}

class _BetListWidgetState extends State<BetListWidget> {
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
    final gameFeedProviders = Provider.of<GameFeedProviders>(context);
    bool? isInBookinds =
        bookingsProvider.getBookingsItems.containsKey(gameFeedCardModels.id);
    Color color = Utils(context).color;

    // final gameFeedCardProvider = Provider.of<GameFeedProviders>(context);

    // int buttonDownCount = 0;
    // int buttonUpCount = 0;

    return Card(
      elevation: 5,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed(context, DetailsScreen.routeName);
            Navigator.pushNamed(context, DetailsScreen.routeName,
                arguments: gameFeedCardModels.id);
          },
          borderRadius: BorderRadius.circular(12),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextWidget(
                      text: DateFormat('d MMM ')
                          .format(DateTime.now())
                          .toString(),
                      color: color,
                      textSize: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (user != null) {
                                  ispressdThumbsUp = true;
                                  await gameFeedProviders.thumbsDownFunc(
                                    gameFeedCardModels.id,
                                    user!.uid,
                                    gameFeedCardModels.thumbsUpM,
                                    gameFeedCardModels.thumbsDownM,
                                  );
                                  // setState(() {
                                  //   // buttonUpCount = 1;
                                  //   gameFeedCardModels.thumbsDownM.length;
                                  // });

                                  //ispressdThumbsDown = false;
                                } else if (user == null) {
                                  GlobalMethods.errorDialog(
                                      subtitle: 'No user found please login',
                                      context: context);
                                  return;
                                }
                              },
                              icon: gameFeedCardModels.thumbsDownM
                                      .contains(user?.uid)
                                  ? const Icon(
                                      Icons.thumb_down_off_alt_outlined,
                                      size: 22,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.thumb_down_off_alt_outlined,
                                      size: 22,
                                    ),
                            ),
                            TextWidget(
                                text: gameFeedCardModels.thumbsDownM.length
                                    .toString(),
                                color: color,
                                textSize: 12)
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () async {
                            // ispressdThumbsUp = true;
                            if (user != null) {
                              await gameFeedProviders.thumbsUpFunc(
                                gameFeedCardModels.id,
                                user!.uid,
                                gameFeedCardModels.thumbsUpM,
                                gameFeedCardModels.thumbsDownM,
                              );

                              // setState(() {
                              //   // buttonUpCount = 1;
                              //   gameFeedCardModels.thumbsUpM.length;
                              // });
                              //ispressdThumbsDown = false;
                            } else if (user == null) {
                              GlobalMethods.errorDialog(
                                  subtitle: 'No user found please login',
                                  context: context);
                              return;
                            }
                          },
                          icon: gameFeedCardModels.thumbsUpM.contains(user?.uid)
                              ? const Icon(
                                  Icons.thumb_up_off_alt_outlined,
                                  size: 22,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  Icons.thumb_up_off_alt_outlined,
                                  size: 22,
                                ),
                        ),
                        TextWidget(
                            text:
                                gameFeedCardModels.thumbsUpM.length.toString(),
                            color: color,
                            textSize: 12),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    // bookingsProvider.addGamesToBookings(
                    //  gameDetailsId: gameFeedCardModels.id);
                    if (user != null) {
                      // bookingsProvider.addGamesToBookings(
                      //     gameDetailsId: gameFeedCardModels.id);
                      await GlobalMethods.addToBookings(
                          gameDetailsId: gameFeedCardModels.id,
                          context: context);
                      await bookingsProvider.fetchBookings();
                    } else if (user == null) {
                      GlobalMethods.errorDialog(
                          subtitle: 'No user found please login',
                          context: context);
                      return;
                    }
                  },
                  child: TextWidget(
                      text: isInBookinds ? 'In Bookings' : 'Add game',
                      color: isInBookinds ? Colors.blue : Colors.red,
                      textSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
