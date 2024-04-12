import 'package:flutter/services.dart';
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

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('-', '');
    if (newText.length > 11) {
      newText = newText.substring(0, 11);
    }

    int cursorPosition = newValue.selection.end;
    int offset = 0; // keeping track of number of spaces added before the cursor

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if ((i == 3 || i == 7) && i != 0) {
        buffer.write('-');
        offset++;
      }
      buffer.write(newText[i]);
    }

    int newCursorPosition = cursorPosition + offset;
    // ensuring the cursor remains within the bounds of the text
    newCursorPosition = newCursorPosition > buffer.length ? buffer.length : newCursorPosition;

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
