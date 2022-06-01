import 'package:intl/intl.dart';

String convertDateToLocal(String data) {
  DateTime dateTime =
      DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(data).toLocal();

  return DateFormat('dd/MM/yyyy').add_jm().format(dateTime);
}
