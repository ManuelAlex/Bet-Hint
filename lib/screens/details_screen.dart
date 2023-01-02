import 'package:bet_hint/screens/detail_screen_widget.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = "/DetailsScreen";
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int buttonUpCount = 0;
  int buttonDownCount = 0;
  @override
  Widget build(BuildContext context) {
    // GlobalMethods globalMethods = GlobalMethods();
    Color color = Utils(context).color;
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
            text: 'Game  details',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: const DetailScreenWidget(),
      ),
    );
  }
}
