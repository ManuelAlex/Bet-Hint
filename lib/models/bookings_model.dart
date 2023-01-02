import 'package:flutter/cupertino.dart';

class BookingsModel with ChangeNotifier {
  final String id, gameDetailsId;

  BookingsModel({required this.id, required this.gameDetailsId});
}
