import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/models/game_model.dart';
import 'package:bet_hint/screens/bet_list_widget.dart';
import 'package:bet_hint/services/ad_helper.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ViewAllScreen extends StatefulWidget {
  static const routeName = "/ViewAllScreenState";
  const ViewAllScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
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
        adUnitId: AdHelper.getAndroidAllGamePageBannerAddUnit,
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

  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextfocusNode = FocusNode();
  List<GameModels> listGameSearch = [];
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchTextController!.dispose();
    _searchTextfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    final gameFeedCardProvider = Provider.of<GameFeedProviders>(context);
    List<GameModels> allGameFeedCard = gameFeedCardProvider.getGameModels;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleSpacing: 30,
          title: TextWidget(
            text: 'All Games',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              // height: size.height * 0.33,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: kBottomNavigationBarHeight,
                  child: TextField(
                    controller: _searchTextController,
                    focusNode: _searchTextfocusNode,
                    onChanged: (valuee) {
                      setState(() {
                        listGameSearch =
                            GameFeedProviders.searchGameQuery(valuee);
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.greenAccent,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.greenAccent,
                          width: 1,
                        ),
                      ),
                      hintText: "Search games",
                      prefixIcon: const Icon(Icons.search),
                      suffix: IconButton(
                        onPressed: () {
                          _searchTextController?.clear();
                          _searchTextfocusNode.unfocus();
                        },
                        icon: const Icon(Icons.close),
                        color:
                            _searchTextfocusNode.hasFocus ? Colors.red : color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final gameProvider =
                      Provider.of<GameFeedProviders>(context, listen: false);
                  await gameProvider.fetchgame();
                },
                child: _searchTextController!.text.isNotEmpty &&
                        listGameSearch.isEmpty
                    ? const Material(
                        child: Center(child: Text('No result found')),
                      )
                    : ListView.builder(
                        itemCount: _searchTextController!.text.isNotEmpty
                            ? listGameSearch.length
                            : allGameFeedCard.length +
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
                              value: _searchTextController!.text.isNotEmpty
                                  ? listGameSearch[index]
                                  : allGameFeedCard[
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
