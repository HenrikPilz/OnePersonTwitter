import 'package:intl/intl.dart';

class Utility {
  String getFormattedDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }
}
