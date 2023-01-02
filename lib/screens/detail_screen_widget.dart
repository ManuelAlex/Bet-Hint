import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/m_providers/bookings_provider.dart';
import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/services/ad_helper.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailScreenWidget extends StatefulWidget {
  const DetailScreenWidget({Key? key}) : super(key: key);

  @override
  State<DetailScreenWidget> createState() => _DetailScreenWidgetState();
}

class _DetailScreenWidgetState extends State<DetailScreenWidget> {
  late BannerAd _bottomBannerAd;

  bool isBottomBannerAdLoaded = false;

  void createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: AdHelper.getAndroidDetailedPageBannerAddUnit,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              isBottomBannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    createBottomBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();

    super.dispose();
  }

  int buttonUpCount = 0;
  int buttonDownCount = 0;
  bool ispressdThumbsUp = false;
  bool ispressdThumbsDown = false;
  final User? user = authInstance.currentUser;

  @override
  Widget build(BuildContext context) {
    final gameFeedCardProvider = Provider.of<GameFeedProviders>(context);
    final gameFeedProviders = Provider.of<GameFeedProviders>(context);

    final gameDetailId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentGamedetail =
        gameFeedCardProvider.findGameDetailsById(gameDetailId);
    // final theme = Utils(context).getTheme;
    // Size size = Utils(context).getscreenSize;
    Color color = Utils(context).color;

    // Color thumbCountColor = Colors.blue;
    final bookingsProvider = Provider.of<BookingsProvider>(context);
    // bool? isInBookinds =
    //     bookingsProvider.getBookingsItems.containsKey(getCurrentGamedetail.id);
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextWidget(
                text: getCurrentGamedetail.team1Title,
                color: color,
                textSize: 20,
                isTitle: true,
              ),
              TextWidget(text: "vs ", color: Colors.cyan, textSize: 15),
              TextWidget(
                text: getCurrentGamedetail.team2Title,
                color: color,
                textSize: 20,
                isTitle: true,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text: getCurrentGamedetail.gameDate +
                '' +
                getCurrentGamedetail.gameTime,
            color: color,
            textSize: 15,
          ),
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text: getCurrentGamedetail.eventToOccur,
            color: color,
            textSize: 16,
            isTitle: true,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                TextWidget(
                  text: "Odd:",
                  color: color,
                  textSize: 15,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                  text: getCurrentGamedetail.odd.toString(),
                  color: color,
                  textSize: 15,
                  isTitle: true,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextWidget(
                text: DateFormat('d MMM ').format(DateTime.now()).toString(),
                color: color,
                textSize: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextWidget(
                    text:
                        DateFormat('d MMM ').format(DateTime.now()).toString(),
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
                        icon: getCurrentGamedetail.thumbsUpM.contains(user?.uid)
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
                              getCurrentGamedetail.thumbsUpM.length.toString(),
                          color: color,
                          textSize: 12),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              if (user != null) {
                // bookingsProvider.addGamesToBookings(
                //     gameDetailsId: gameFeedCardModels.id);
                await GlobalMethods.addToBookings(
                    gameDetailsId: getCurrentGamedetail.id, context: context);
                await bookingsProvider.fetchBookings();
              } else if (user == null) {
                GlobalMethods.errorDialog(
                    subtitle: 'No user found please login', context: context);
                return;
              }
            },
            child: TextWidget(
                text: bookingsProvider.getBookingsItems
                        .containsKey(getCurrentGamedetail.id)
                    ? 'In Bookings'
                    : "Add game",
                color: bookingsProvider.getBookingsItems
                        .containsKey(getCurrentGamedetail.id)
                    ? Colors.blue
                    : Colors.red,
                textSize: 15),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: _bottomBannerAd.size.height.toDouble(),
            width: _bottomBannerAd.size.width * 1.2.toDouble(),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: AdWidget(ad: _bottomBannerAd)),
          )
        ]),
      ),
    );
  }
}
