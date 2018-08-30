import 'package:intl/intl.dart';

String dateFormatter(){
  var now = DateTime.now();

  var formatter = DateFormat("EEE, MMM d, yyyy");

  String formatted = formatter.format(now);

  return formatted;
}