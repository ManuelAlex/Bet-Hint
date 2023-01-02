import 'package:bet_hint/const/theme_data.dart';
import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/provider/dark_theme_provider.dart';
import 'package:bet_hint/screens/about_us_page.dart';
import 'package:bet_hint/screens/auth/forgot_password.dart';
import 'package:bet_hint/screens/auth/login.dart';
import 'package:bet_hint/screens/bookings_screen_widget.dart';
import 'package:bet_hint/screens/btm_bar.dart';
import 'package:bet_hint/screens/details_screen.dart';
import 'package:bet_hint/screens/game_history.dart';
import 'package:bet_hint/screens/loading_manage.dart';
import 'package:bet_hint/screens/view_all_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'fetch_screen.dart';
import 'm_providers/bookings_provider.dart';
import 'screens/auth/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getcurrenAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getcurrenAppTheme();

    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: '',
          appId: '1:819948447216:android:05a3f374aa543bf9c1a935',
          messagingSenderId: '',
          projectId: ''));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: LoadingManager(isLoading: true, child: Text('')),
                ),
              ),
            );
            //Text('An Error Occured ${snapshot.error}'),
          } else if (snapshot.hasData) {
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('An Error Occured ${snapshot.error}'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => GameFeedProviders(),
              ),
              ChangeNotifierProvider(
                create: (_) => BookingsProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                //home: const LoginScreen(),
                home: const FetchScreen(),
                routes: {
                  DetailsScreen.routeName: (ctx) => const DetailsScreen(),
                  ViewAllScreen.routeName: (ctx) => const ViewAllScreen(),
                  BookingsWidget.routeName: (ctx) => const BookingsWidget(),
                  BottomBarScreen.routeName: (ctx) => const BottomBarScreen(),
                  LoginScreen.routeName: (ctx) => const LoginScreen(),
                  AboutUsPage.routeName: (ctx) => const AboutUsPage(),
                  GameHistory.routeName: (ctx) => const GameHistory(),
                  RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                  ForgotPasswordScreen.routeName: (ctx) =>
                      const ForgotPasswordScreen(),
                },
              );
            }),
          );
        });
  }
}
