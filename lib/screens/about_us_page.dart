import 'package:bet_hint/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutUsPage extends StatefulWidget {
  static const routeName = "/AboutUsPage";

  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final String _markDownData = """
# About Our Bet Bot
---
### The **BetHint** app is borne out of passion for **more efficient ways of predicting soccer outcomes**.

### We have modelled a **bet Calculator** that takes in account the following data set based on teams **averaged last 5** and **10** matches:**win** , **lose**, **both teams to score**, **score 1**, **score 2+**, **conceed 1**, **conceded 2+**, **scored 1st** and  **finally cleansheet**. 

### This **algorithm** runs series of **differential calculations** and returns **relative Ratios** based on both teams playing. Ratios such as **attack ratio**, **attack ratio**, **score ratio**, **conceed ratio**, **halftime/fulltime dominance ratio**. Upon which a **series of complex logical statements** is implored to predict **specific outcomes**
.

### This model has been tested for **over 9months** and has a strike rate of about **70%**. 

### In the grand scheme of football anything can happen nonetheless we are constantly working to see how we can improve on this results. 

### **The goal is to beat the bookies in their own game stay with us, win with us**.

### **Bet responsibily** ✌️

""";
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text('Abous Us'),
          ],
        ),
      ),
      body: SafeArea(child: Markdown(data: _markDownData)),
    );
  }
}
