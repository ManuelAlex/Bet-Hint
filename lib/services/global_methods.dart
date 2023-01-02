import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class GlobalMethods {
  navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'lib/screens/assets/images/sign-42530_1280.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 8),
                const SizedBox(height: 8),
                Text(title),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                    text: 'Cancel', color: Colors.cyan, textSize: 18),
              ),
              TextButton(
                onPressed: () {
                  fct;
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(text: 'Ok', color: Colors.cyan, textSize: 18),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'lib/screens/assets/images/sign-42530_1280.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 8),
                const SizedBox(height: 8),
                const Text('An Error Occured'),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(text: 'Ok', color: Colors.cyan, textSize: 18),
              ),
            ],
          );
        });
  }

  static Future<void> addToBookings({
    required String gameDetailsId,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final bookingsId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'bookings': FieldValue.arrayUnion([
          {
            'bookingsId': bookingsId,
            'gameDetailsId': gameDetailsId,
          }
        ])
      });
      Fluttertoast.showToast(
          msg: "game has been added to bookings",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey.shade600,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }
}
