import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Gasto {
  final String title;
  final String value;

  Gasto({required this.title, required this.value});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Gasto> gastos = [
    Gasto(title: 'Janeiro', value: '100'),
    Gasto(title: 'Fevereiro', value: '150'),
    Gasto(title: 'Março', value: '200'),
    // Adicione mais dados para outros meses
  ];

  String selectedMonth = 'Janeiro';

  @override
  Widget build(BuildContext context) {
    List<Gasto> filteredGastos =
        gastos.where((gasto) => gasto.title == selectedMonth).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gastos por Mês'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selectedMonth,
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue!;
              });
            },
            items: gastos.map((Gasto gasto) {
              return DropdownMenuItem<String>(
                value: gasto.title,
                child: Text(gasto.title),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text('Mês Selecionado: $selectedMonth'),
          SizedBox(height: 20),
          Text('Dados do Mês:'),
          Expanded(
            child: ListView.builder(
              itemCount: filteredGastos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredGastos[index].value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}