import 'dart:io';
import 'package:bet_hint/const/constss.dart';
import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/screens/btm_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'm_providers/bookings_provider.dart';
import 'm_providers/game_feed_provider.dart';
import 'package:upgrader/upgrader.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final List<String> _images = Constss.authImagesPaths;
  @override
  void initState() {
    _images.shuffle();

    Future.delayed(const Duration(microseconds: 5), () async {
      final gameProvider =
          Provider.of<GameFeedProviders>(context, listen: false);

      final User? user = authInstance.currentUser;
      if (user == null) {
        await gameProvider.fetchgame();
        final bookingsFetchProvider =
            Provider.of<BookingsProvider>(context, listen: false);

        bookingsFetchProvider.clearLocalBooking();
      } else {
        final bookingsFetchProvider =
            Provider.of<BookingsProvider>(context, listen: false);
        await gameProvider.fetchgame();

        await bookingsFetchProvider.fetchBookings();
      }

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomBarScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(
          durationUntilAlertAgain: const Duration(days: 3),
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          canDismissDialog: true,
          showReleaseNotes: false,
          shouldPopScope: () => true,
        ),
        child: Stack(
          children: [
            Image.asset(
              _images[0],
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            const Center(
              child: SpinKitFadingFour(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
