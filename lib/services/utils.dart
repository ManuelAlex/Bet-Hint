import 'package:bet_hint/provider/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;
  Color get color => getTheme ? Colors.white : Colors.black;
  Color get getColor2 => getTheme ? Colors.black : Colors.white;

  Size get getscreenSize => MediaQuery.of(context).size;
}
