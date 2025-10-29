
import 'package:intl/intl.dart';

String getTimeFromTimeStamp(String timeStamp) {
  DateTime dateTime = DateTime.parse(timeStamp);
  return DateFormat("hh:mm a").format(dateTime);
}