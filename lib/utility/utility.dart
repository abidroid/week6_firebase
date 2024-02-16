
import 'package:intl/intl.dart';

class Utility {

  static String getHumanReadableDate( int timestamp){

    DateFormat dateFormat = DateFormat('dd-MMM-yyyy HH:mm:ss');

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return dateFormat.format(dateTime);

  }
}