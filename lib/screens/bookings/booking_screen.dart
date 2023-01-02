import 'package:bet_hint/m_providers/bookings_provider.dart';
import 'package:bet_hint/m_providers/game_feed_provider.dart';
import 'package:bet_hint/screens/bookings/empty_booking_page.dart';
import 'package:bet_hint/screens/bookings_screen_widget.dart';
import 'package:bet_hint/services/utils.dart';
import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  get routeName => null;

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    final bookingsProvider = Provider.of<BookingsProvider>(context);
    final bookingsItemList =
        bookingsProvider.getBookingsItems.values.toList().reversed.toList();
    Color color = Utils(context).color;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: "Bookings(${bookingsItemList.length.toString()})",
            color: color,
            textSize: 22,
            isTitle: true,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () async {
                    await bookingsProvider.clearOnLineBooking();
                    bookingsProvider.clearLocalBooking();
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  )),
            )
          ],
        ),
        body: bookingsItemList.isEmpty
            ? const Center(
                child: EmptyScreen(),
              )
            : Column(
                children: [
                  _placeBet(context: context),
                  Expanded(
                    child: ListView.builder(
                        itemCount: bookingsItemList.length,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                            value: bookingsItemList[index],
                            child: const BookingsWidget(),
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _placeBet({required BuildContext context}) {
    final bookingsProvider = Provider.of<BookingsProvider>(context);
    final gameFeedCardProvider = Provider.of<GameFeedProviders>(context);

    double total = 0.0;
    bookingsProvider.getBookingsItems.forEach((key, value) {
      final getCurrentGamedetail =
          gameFeedCardProvider.findGameDetailsById(value.gameDetailsId);
      total += double.parse(getCurrentGamedetail.odd);
    });

    Size size = Utils(context).getscreenSize;
    Color color = Utils(context).color;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.only(right: 30, left: 12),
        child: Row(
          children: [
            Material(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child:
                      TextWidget(text: "Place Bet", color: color, textSize: 20),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                  text: "Total Odds: ${total.toStringAsFixed(2)}",
                  isTitle: true,
                  color: color,
                  textSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
