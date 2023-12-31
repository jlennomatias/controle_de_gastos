import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MesDropDownButton extends StatefulWidget {
  MesDropDownButton({
    Key? key,
    required this.months,
    required this.selectedMonth,
  }) : super(key: key);

  final List<String> months;
  String selectedMonth;

  @override
  State<MesDropDownButton> createState() => _MesDropDownButtonState();
}

class _MesDropDownButtonState extends State<MesDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedMonth,
      onChanged: (String? newValue) {
        setState(() {
          widget.selectedMonth = newValue!;
          print(widget.selectedMonth);
        });
      },
      items: widget.months.map((String month) {
        return DropdownMenuItem<String>(
          value: month,
          child: Text(month),
        );
      }).toList(),
    );
  }
}
