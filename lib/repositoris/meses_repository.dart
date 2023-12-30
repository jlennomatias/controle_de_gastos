import 'package:intl/intl.dart';

class MesesRepository {

  String currentMonth() {
    DateTime currentDate = DateTime.now();
    String currentMonthName = DateFormat('MMMM').format(currentDate);
    return currentMonthName;
  }

  List<String> months(){
    List<String> monthsInEnglish = DateFormat('MMMM').dateSymbols.MONTHS;
    return monthsInEnglish;
  }
}
