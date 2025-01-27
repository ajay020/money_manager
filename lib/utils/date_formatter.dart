import 'package:intl/intl.dart';

String formatDate(String dateString) {
  // Parse the date string to a DateTime object
  final date = DateTime.parse(dateString);

  // Format the date to "MMM d, EEEE" (e.g., "Jan 27, Monday")
  final formatter = DateFormat('MMM d, EEEE');
  return formatter.format(date);
}
