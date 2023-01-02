import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/m_providers/bookings_provider.dart';
import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/models/bookings_model.dart';
import 'package:bet_hint/screens/details_screen.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingsWidget extends StatefulWidget {
  static const routeName = "/BookingsWidget";
  const BookingsWidget({Key? key}) : super(key: key);

  @override
  State<BookingsWidget> createState() => _BookingsWidgetState();
}

class _BookingsWidgetState extends State<BookingsWidget> {
  final User? user = authInstance.currentUser;
  int buttonUpCount = 0;
  int buttonDownCount = 0;

  @override
  Widget build(BuildContext context) {
    // final theme = Utils(context).getTheme;
    // Size size = Utils(context).getscreenSize;
    Color color = Utils(context).color;

    // GlobalMethods globalMethods = GlobalMethods();
    final gameFeedProviders = Provider.of<GameFeedProviders>(context);
    final gameFeedCardProvider = Provider.of<GameFeedProviders>(context);
    final bookingsModel = Provider.of<BookingsModel>(context);

    final bookingsProvider = Provider.of<BookingsProvider>(context);

    final getCurrentGamedetail =
        gameFeedCardProvider.findGameDetailsById(bookingsModel.gameDetailsId);

    return Card(
      elevation: 5,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
          onTap: () {
            // Navigator.pushNamed(context, DetailsScreen.routeName);
            Navigator.pushNamed(context, DetailsScreen.routeName,
                arguments: getCurrentGamedetail.id);
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
                      text: getCurrentGamedetail.team1Title,
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
                      text: getCurrentGamedetail.team2Title,
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
                  text: getCurrentGamedetail.gameDate +
                      '' +
                      getCurrentGamedetail.gameTime,
                  color: color,
                  textSize: 15,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                  text: getCurrentGamedetail.eventToOccur,
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
                      text: getCurrentGamedetail.odd.toString(),
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
                                  await gameFeedProviders.thumbsDownFunc(
                                    getCurrentGamedetail.id,
                                    user!.uid,
                                    getCurrentGamedetail.thumbsUpM,
                                    getCurrentGamedetail.thumbsDownM,
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
                              icon: getCurrentGamedetail.thumbsDownM
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
                                text: getCurrentGamedetail.thumbsDownM.length
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
                                getCurrentGamedetail.id,
                                user!.uid,
                                getCurrentGamedetail.thumbsUpM,
                                getCurrentGamedetail.thumbsDownM,
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
                          icon:
                              getCurrentGamedetail.thumbsUpM.contains(user?.uid)
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
                            text: getCurrentGamedetail.thumbsUpM.length
                                .toString(),
                            color: color,
                            textSize: 12),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    await bookingsProvider.removeOneItem(
                        bookingsId: bookingsModel.id,
                        gameDetailsId: bookingsModel.gameDetailsId);
                  },
                  child: TextWidget(
                      text: "remove game", color: Colors.red, textSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
