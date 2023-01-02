import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/models/game_model.dart';
import 'package:bet_hint/screens/bet_list_widget.dart';
import 'package:bet_hint/screens/view_all_screen.dart';
import 'package:bet_hint/services/ad_helper.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/DetailsScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _offerImages = [
    {
      'image': 'lib/screens/auth/ball-2680595_1280.jpg',
      'text': 'Beat the bookies in their own game',
    },
    {
      'image': 'lib/screens/assets/images/landing/football2.JPG',
      'text': 'Bet  Like never before',
    },
    {
      'image': 'lib/screens/assets/images/landing/football4.JPG',
      'text': 'Bet like a Pro',
    },
    {
      'image': 'lib/screens/auth/images/soccer-1448551_1280.png',
      'text': 'Have an Edge over all odds',
    },
  ];
  final _inLineAdIndex = 5;
  bool _isInLineBannerAdLoaded = false;
  late BannerAd _inLineBannerAd;
  int _getListViewItemIdex(int index) {
    if (index >= _inLineAdIndex && _isInLineBannerAdLoaded == true) {
      return index - 1;
    }
    return index;
  }

  void createInLineBarrnerAd() {
    _inLineBannerAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: AdHelper.getAndroidHomeBannerAddUnit,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isInLineBannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());
    _inLineBannerAd.load();
  }

  @override
  void initState() {
    createInLineBarrnerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameFeedCardProvider = Provider.of<GameFeedProviders>(context);
    List<GameModels> allGameFeedCard = gameFeedCardProvider.getGameModels;

    bool _isEmpty = false;
    final Utils utils = Utils(context);
    // final themeState = utils.getTheme;
    Color color = utils.color;
    Color color2 = utils.getColor2;
    Size size = utils.getscreenSize;
    GlobalMethods globalMethods = GlobalMethods();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          _offerImages[index]['image'],
                          fit: BoxFit.fill,
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: TextWidget(
                            //text: index ? "hello ${index}",
                            // i want to have a switch that compares the value of index to get different text
                            text: _offerImages[index]['text'],
                            color: color2,
                            textSize: 30,
                            isTitle: true,
                          ))
                    ],
                  );
                },
                itemCount: _offerImages.length,
                layout: SwiperLayout.STACK,
                itemWidth: size.width * 0.89,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Colors.red)),
                // control: const SwiperControl(
                /// color: Colors.black,
                //),
                autoplay: true,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            TextButton(
              onPressed: () {
                globalMethods.navigateTo(
                    ctx: context, routeName: ViewAllScreen.routeName);
              },
              child: TextWidget(
                  text: "view All",
                  maxLines: 1,
                  color: Colors.blue,
                  textSize: 20),
            ),
            Expanded(
              child: _isEmpty
                  // ignore: dead_code
                  ? Center(
                      child: TextWidget(
                          text: "No games at the moment \n stay tunned",
                          color: color,
                          isTitle: true,
                          textSize: 30),
                    )
                  // ignore: dead_code
                  : RefreshIndicator(
                      onRefresh: () async {
                        final gameProvider = Provider.of<GameFeedProviders>(
                            context,
                            listen: false);
                        await gameProvider.fetchgame();
                      },
                      child: ListView.builder(
                          itemCount: allGameFeedCard.length +
                              (_isInLineBannerAdLoaded ? 1 : 0),
                          itemBuilder: (ctx, index) {
                            if (_isInLineBannerAdLoaded &&
                                index == _inLineAdIndex) {
                              return Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                width: _inLineBannerAd.size.width.toDouble(),
                                height: _inLineBannerAd.size.height.toDouble(),
                                child: AdWidget(ad: _inLineBannerAd),
                              );
                            } else {
                              return ChangeNotifierProvider.value(
                                value: allGameFeedCard[
                                    _getListViewItemIdex(index)],
                                child: const BetListWidget(),
                              );
                            }
                          }),
                    ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
