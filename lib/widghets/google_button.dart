import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/fetch_screen.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool isLoading = false;
  Future<void> _googleSignIn(context) async {
    setState(() {
      isLoading = true;
    });
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance
              .signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));
          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'userName': authResult.user!.displayName,
              'fullName': authResult.user!.displayName,
              'email': authResult.user!.email,
              'bookings': [],
              'subscription': false,
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
          setState(() {
            isLoading = false;
          });
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
          setState(() {
            isLoading = false;
          });
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
          setState(() {
            isLoading = false;
          });
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                'lib/screens/auth/images/google-1762248_1280.png',
                width: 40,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            TextWidget(
                text: 'Sign in with google', color: Colors.white, textSize: 16)
          ],
        ),
      ),
    );
  }
}
