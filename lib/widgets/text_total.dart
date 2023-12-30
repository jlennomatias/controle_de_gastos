import 'package:controle_gastos/models/gasto_model.dart';
import 'package:flutter/material.dart';

class TextMesesTotal extends StatelessWidget {
  TextMesesTotal({
    Key? key,
    required this.months,
    required this.gastos,
    required this.currentMonth,
  }) : super(key: key);

  final List<String> months;
  final List<Gasto> gastos;
  final String currentMonth;

  List totalMeses() {
    List totalMeses;
    try {
      totalMeses = gastos.map((gasto) => gasto.title).toSet().toList();
    } catch (e) {
      // Retornando lista vazia, caso não tenha dados
      totalMeses = [];
    }
    return totalMeses;
  }

  String totalGasto(String currentMes) {
    String mes = currentMes;
    double totalMes;
    totalMeses();
    try {
      totalMes = gastos
          .where((item) => item.title == mes)
          .map((item) => double.tryParse(item.value) ?? 0.0)
          .reduce((valor1, valor2) => valor1 + valor2);
    } catch (e) {
      // Retornando 0 caso não tenha dados
      totalMes = 0.0;
    }
    return totalMes.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: totalMeses().length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
          ),
          child: Column(
            children: [
              Text(
                '${totalMeses()[index]}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'R\$ ${totalGasto(totalMeses()[index])}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
