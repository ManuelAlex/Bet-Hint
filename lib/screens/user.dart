import 'package:bet_hint/const/firebase_consts.dart';
import 'package:bet_hint/m_providers/bookings_provider.dart';
import 'package:bet_hint/provider/dark_theme_provider.dart';
import 'package:bet_hint/screens/about_us_page.dart';
import 'package:bet_hint/screens/auth/forgot_password.dart';
import 'package:bet_hint/screens/auth/login.dart';
import 'package:bet_hint/screens/game_history.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final User? user = authInstance.currentUser;
  bool isLoading = false;
  String? _email;
  String? _userName;
  @override
  void initState() {
    getUserdata();
    super.initState();
  }

  Future<void> getUserdata() async {
    setState(() {
      isLoading = true;
    });
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _userName = userDoc.get('userName');
        //     _userName = userDoc.get('thumbs');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 20, bottom: 8, right: 8, left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(
                      text: "Hi,  ",
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: _userName == null ? 'User' : _userName!,
                            style: TextStyle(
                              color: color,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {}),
                      ],
                    )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextWidget(
                    text: _email == null
                        ? '  myemail@Example.com'
                        : '  ' + _email!,
                    color: color,
                    textSize: 18,
                    isTitle: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // _listTiles(
                  //     title: "Game Of The Day",
                  //     subtitle: "Find todays gamees here ",
                  //     icon: IconlyLight.game,
                  //     color: color,
                  //     onpressed: () {}),
                  //
                  _listTiles(
                      title: "About ",
                      subtitle: "Know more about our betting AI",
                      icon: IconlyLight.paperPlus,
                      color: color,
                      onpressed: () {
                        GlobalMethods().navigateTo(
                            ctx: context, routeName: AboutUsPage.routeName);
                      }),
                  _listTiles(
                      title: "Bet Performance ",
                      subtitle: "track our bet performance",
                      icon: IconlyLight.paperPlus,
                      color: color,
                      onpressed: () {
                        GlobalMethods().navigateTo(
                            ctx: context, routeName: GameHistory.routeName);
                      }),
                  // _listTiles(
                  //     title: "My Subscriptions",
                  //     icon: IconlyLight.profile,
                  //     color: color,
                  //     onpressed: () {}),
                  // _listTiles(
                  //     title: "share this app",
                  //     icon: IconlyLight.send,
                  //     color: color,
                  //     onpressed: () {}),
                  // _listTiles(
                  //     title: "Rate this app",
                  //     icon: IconlyLight.heart,
                  //     color: color,
                  //     onpressed: () {}),
                  SwitchListTile(
                    title: TextWidget(
                      text:
                          themeState.getDarkTheme ? "Dark Mode" : "Light Mode",
                      color: color,
                      textSize: 18,
                      isTitle: false,
                    ),
                    secondary: Icon(
                      themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                  ),
                  _listTiles(
                      title: "Forgot Password",
                      icon: IconlyLight.password,
                      color: color,
                      onpressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen()));
                      }),
                  _listTiles(
                      title: user == null ? 'login' : "Log Out",
                      icon:
                          user == null ? IconlyLight.login : IconlyLight.logout,
                      color: color,
                      onpressed: () {
                        //final User? user = authInstance.currentUser;
                        if (user != null) {
                          // authInstance.signOut();
                          //
                          _showLogOutDialogue();

                          return;
                        } else if (user == null) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                          return;
                        }
                      }),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogOutDialogue() async {
    final bookingsFetchProvider =
        Provider.of<BookingsProvider>(context, listen: false);
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
                const Text('logOut'),
              ],
            ),
            content: const Text("Do you want to logout ?"),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.cyan,
                  text: "Cancel",
                  textSize: 15,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await authInstance.signOut();
                  bookingsFetchProvider.clearLocalBooking();
                  Fluttertoast.showToast(
                      msg: "You are logged out",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey.shade600,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.red,
                  text: "Ok",
                  textSize: 15,
                ),
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onpressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18,
        isTitle: false,
      ),
      subtitle: TextWidget(
        text: subtitle ?? "",
        color: color,
        textSize: 13,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onpressed();
      },
    );
  }
}
