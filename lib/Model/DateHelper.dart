import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateHepler {
  String getDate(String time) {
    initializeDateFormatting();
    int timeInt = int.tryParse(time);
    DateTime now = DateTime.now();
    DateTime datePost = DateTime.fromMillisecondsSinceEpoch(timeInt);
    DateFormat format;
    if (now.difference(datePost).inDays > 0) {
      format = new DateFormat.yMMMd("fr_FR");
    } else {
      format = new DateFormat.Hm("fr_FR");
    }
    return format.format(datePost).toString();
  }
}
