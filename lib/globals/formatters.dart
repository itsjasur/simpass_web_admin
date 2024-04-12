import 'package:intl/intl.dart';

class CustomFormat {
  String? formatDate(String dateTimeString) {
    //  the input format matching the structure including milliseconds
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm");

    // parsing the string into a DateTime object
    DateTime dateTime = inputFormat.parse(dateTimeString);

    //  output format for a more readable date and time
    DateFormat outputFormat = DateFormat("yyyy-mm-dd h:mm a");

    //  the DateTime object using the output format
    String formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }
}
