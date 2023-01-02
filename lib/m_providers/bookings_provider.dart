import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/models/bookings_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

class BookingsProvider with ChangeNotifier {
  //list to add to
  final Map<String, BookingsModel> _bookingsItems = {};

// getter
  Map<String, BookingsModel> get getBookingsItems {
    return _bookingsItems;
  }

// func to add

  // void addGamesToBookings({required String gameDetailsId}) {
  //   _bookingsItems.putIfAbsent(
  //       gameDetailsId,
  //       () => BookingsModel(
  //           id: DateTime.now().toString(), gameDetailsId: gameDetailsId));
  //   notifyListeners();
  // }

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchBookings() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (user == null) {
      return;
    }

    final leng = userDoc.get('bookings').length;
    for (int i = 0; i < leng; i++) {
      _bookingsItems.putIfAbsent(
          userDoc.get('bookings')[i]['gameDetailsId'],
          () => BookingsModel(
              id: userDoc.get('bookings')[i]['bookingsId'],
              gameDetailsId: userDoc.get('bookings')[i]['gameDetailsId']));
    }
    notifyListeners();
  }

  Future<void> removeOneItem({
    required String bookingsId,
    required String gameDetailsId,
  }) async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'bookings': FieldValue.arrayRemove([
        {
          'bookingsId': bookingsId,
          'gameDetailsId': gameDetailsId,
        }
      ])
    });

    _bookingsItems.remove(gameDetailsId);
    await fetchBookings();
    notifyListeners();
  }

  Future<void> clearOnLineBooking() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user?.uid).update({
      'bookings': [],
    });
    _bookingsItems.clear();
    notifyListeners();
  }

  void clearLocalBooking() {
    _bookingsItems.clear();
    notifyListeners();
  }
}
