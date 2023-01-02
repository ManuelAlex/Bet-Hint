import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/models/game_model.dart';
import 'package:bet_hint/screens/bet_list_widget.dart';
import 'package:bet_hint/screens/bookings/empty_booking_page.dart';
import 'package:bet_hint/services/ad_helper.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HotEventsScreen extends StatefulWidget {
  const HotEventsScreen({Key? key}) : super(key: key);

  @override
  State<HotEventsScreen> createState() => _HotEventsScreenState();
}

class _HotEventsScreenState extends State<HotEventsScreen> {
  final _inLineAdIndex = 4;
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
        adUnitId: AdHelper.getAndroidHotEventPageBannerAddUnit,
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
    Color color = Utils(context).color;
    final gameFeedCardProvider = Provider.of<GameFeedProviders>(context);
    List<GameModels> myLikeList = gameFeedCardProvider.sortLikes();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleSpacing: 30,
          title: TextWidget(
            text: 'Hot ',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final gameProvider =
                      Provider.of<GameFeedProviders>(context, listen: false);
                  await gameProvider.fetchgame();
                },
                child: myLikeList.isEmpty
                    ? const EmptyScreen()
                    : ListView.builder(
                        itemCount: myLikeList.length +
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
                              value: myLikeList[_getListViewItemIdex(index)],
                              child: const BetListWidget(),
                            );
                          }
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
