import 'package:bet_hint/screens/btm_bar.dart';
import 'package:bet_hint/services/global_methods.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatefulWidget {
  static const routeName = "/EmptyScreen";

  const EmptyScreen({Key? key}) : super(key: key);

  @override
  State<EmptyScreen> createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getscreenSize;
    Color color = Utils(context).color;
    GlobalMethods globalMethods = GlobalMethods();
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/screens/assets/images/landing/shopping-cart-g2ba252da4_1280.png',
                fit: BoxFit.contain,
                height: size.height * 0.3,
                width: double.infinity,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Whoops",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "No games added yet,\n add games!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    globalMethods.navigateTo(
                        ctx: context, routeName: BottomBarScreen.routeName);
                  },
                  child: TextWidget(
                    color: theme ? Colors.grey.shade300 : Colors.grey.shade800,
                    text: 'Add game',
                    textSize: 18,
                    isTitle: true,
                  ))
            ],
          )),
    ));
  }
}
