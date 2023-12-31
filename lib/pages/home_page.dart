import 'package:controle_gastos/models/gasto_model.dart';
import 'package:controle_gastos/repositoris/gasto_repository.dart';
import 'package:controle_gastos/repositoris/meses_repository.dart';
import 'package:controle_gastos/widgets/gast_list_item.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final GastoRepository gastoRepository = GastoRepository();
  final MesesRepository mesesRepository = MesesRepository();
  late String selectedMonth = '${mesesRepository.currentMonth()}';

  List<Gasto> gastos = [];

  Gasto? deletedGasto;
  int? deletedGastoPos;
  String? errorDescription;
  String? errorValue;

  String totalGasto(String currentMes) {
    String mes = currentMes;
    double totalMes;

    try {
      totalMes = gastos
          .where((item) => item.month == mes)
          .map((item) => double.tryParse(item.value) ?? 0.0)
          .reduce((valor1, valor2) => valor1 + valor2);
    } catch (e) {
      // Retornando 0 caso não tenha dados
      totalMes = 0.0;
    }
    return totalMes.toString();
  }

  List totalMeses() {
    List totalMeses;
    try {
      totalMeses = gastos.map((gasto) => gasto.month).toSet().toList();
    } catch (e) {
      // Retornando lista vazia, caso não tenha dados
      totalMeses = [];
    }
    return totalMeses;
  }

  void ondelete(Gasto gasto) {
    deletedGasto = gasto;
    deletedGastoPos = gastos.indexOf(gasto);

    setState(() {
      gastos.remove(gasto);
    });

    gastoRepository.saveGastoList(gastos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${gasto.title} foi removida com sucesso!',
        ),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              gastos.insert(deletedGastoPos!, deletedGasto!);
            });
            gastoRepository.saveGastoList(gastos);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    gastoRepository.getGastoList().then((value) {
      setState(() {
        gastos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nome'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              color: Colors.deepPurple,
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Gastos',
                        style: TextStyle(fontSize: 30),
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: totalMeses().length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedMonth.isNotEmpty) {
                      setState(() {
                        selectedMonth = totalMeses()[index];
                      });
                    }
                  },
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
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (Gasto gasto in gastos)
                  if (gasto.month == selectedMonth)
                    GastoListItem(
                      gasto: gasto,
                      ondelete: ondelete,
                    ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedMonth,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                  items: mesesRepository.months().map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.deepPurple),
                      errorText: errorDescription,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  child: TextField(
                    controller: valueController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Value',
                      labelStyle: TextStyle(color: Colors.deepPurple),
                      errorText: errorValue,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  descriptionController.clear();
                  valueController.clear();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, padding: EdgeInsets.all(10)),
                child: Icon(
                  Icons.close,
                  size: 30,
                ),
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  String text = descriptionController.text;
                  String value = valueController.text;

                  if (text.isEmpty) {
                    {
                      setState(() {
                        errorDescription = 'The text field is empty.';
                      });
                      return;
                    }
                  }
                  if (value.isEmpty) {
                    {
                      setState(() {
                        errorValue = 'The text field is empty.';
                      });
                      return;
                    }
                  }
                  setState(() {
                    Gasto newGasto = Gasto(title: text, value: value, month: selectedMonth);
                    gastos.add(newGasto);

                    errorDescription = null;
                    errorValue = null;
                  });
                  descriptionController.clear();
                  valueController.clear();
                  gastoRepository.saveGastoList(gastos);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.all(10)),
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
