import 'package:badges/badges.dart';
import 'package:bet_hint/m_providers/bookings_provider.dart';
import 'package:bet_hint/provider/dark_theme_provider.dart';
import 'package:bet_hint/screens/game_history.dart';
import 'package:bet_hint/screens/home_screen.dart';
import 'package:bet_hint/screens/hot_events.dart';
import 'package:bet_hint/screens/user.dart';
import 'package:bet_hint/services/ad_helper.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
// ignore: undefined_hidden_name
import 'package:flutter/material.dart ' hide Badge;
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'bookings/booking_screen.dart';

const int maxfailedLoadAttempt = 3;

class BottomBarScreen extends StatefulWidget {
  static const routeName = "/BottomBarScreen";

  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempt = 0;
  int _selectedIndex = 0;
  final List _pages = [
    const HomeScreen(),
    const HotEventsScreen(),
    const BookingsScreen(),
    const GameHistory(),
    const UserScreen(),
  ];
  void _selectedPage(int index) {
    if (index == 2) {
      _showInsterstitalAdd();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  late BannerAd _bottomBannerAd;

  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.getAndroidBtmBarBannerAddUnit,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isBottomBannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());
    _bottomBannerAd.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.getInterstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempt = 0;
        }, onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempt += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempt >= maxfailedLoadAttempt) {
            _createInterstitialAd();
          }
        }));
  }

  void _showInsterstitalAdd() {
    if (_interstitialAd != null) {
      _createInterstitialAd();
      _interstitialAd!.fullScreenContentCallback ==
          FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _createInterstitialAd();
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              ad.dispose();
              _createInterstitialAd();
            },
          );
      _interstitialAd?.show();
    }
  }

  @override
  void initState() {
    _createBottomBannerAd();
    _createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeState.getDarkTheme;

    return Scaffold(
      bottomSheet: _isBottomBannerAdLoaded
          ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width * 1.2.toDouble(),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AdWidget(ad: _bottomBannerAd)),
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _selectedPage,
        unselectedItemColor: isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: isDark ? Colors.lightBlue.shade200 : Colors.black87,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 1 ? IconlyBold.star : IconlyLight.star),
              label: "Hot"),
          BottomNavigationBarItem(
              icon: Consumer<BookingsProvider>(builder: (_, myBookPro, ch) {
                return Badge(
                    toAnimate: true,
                    shape: BadgeShape.circle,
                    badgeColor: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    position: BadgePosition.topEnd(top: -17, end: -7),
                    badgeContent: FittedBox(
                        child: TextWidget(
                            text: myBookPro.getBookingsItems.length.toString(),
                            color: Colors.white,
                            textSize: 12)),
                    child: Icon(_selectedIndex == 2
                        ? IconlyBold.buy
                        : IconlyLight.buy));
              }),
              label: "User"),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3
                  ? IconlyBold.infoSquare
                  : IconlyLight.infoSquare),
              label: "User"),
          BottomNavigationBarItem(
              icon: Icon(
                  _selectedIndex == 4 ? IconlyBold.user2 : IconlyLight.user2),
              label: "History"),
        ],
      ),
    );
  }
}
