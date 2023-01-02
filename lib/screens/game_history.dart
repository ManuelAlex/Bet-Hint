import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/services/ad_helper.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/outcome_widgets.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class GameHistory extends StatefulWidget {
  static const routeName = "/GameHistory";
  const GameHistory({Key? key}) : super(key: key);

  @override
  State<GameHistory> createState() => _GameHistoryState();
}

class _GameHistoryState extends State<GameHistory> {
  final _inLineAdIndex = 2;
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
        adUnitId: AdHelper.getAndroidGameHistoryPageBannerAddUnit,
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
    List myGameHistory =
        gameFeedCardProvider.fetchGameHistory().reversed.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleSpacing: 30,
          title: TextWidget(
            text: 'Game performance History ',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final gameProvider =
                      Provider.of<GameFeedProviders>(context, listen: false);
                  await gameProvider.fetchgame();
                },
                child: myGameHistory.isEmpty
                    ? const Material(
                        child: Center(
                          child: Text(
                            "Stay Tunned games are still updating",
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: myGameHistory.length +
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
                            return ChangeNotifierProvider<
                                GameFeedProviders>.value(
                              value: myGameHistory[_getListViewItemIdex(index)],
                              child: const OutcomeWidget(),
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
