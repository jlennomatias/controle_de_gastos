import 'package:controle_gastos/models/gasto_model.dart';
import 'package:controle_gastos/repositoris/gasto_repository.dart';
import 'package:controle_gastos/repositoris/meses_repository.dart';
import 'package:controle_gastos/widgets/gast_list_item.dart';
import 'package:controle_gastos/widgets/meses_dropDown.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController gastoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final GastoRepository gastoRepository = GastoRepository();
  final MesesRepository mesesRepository = MesesRepository();
  late String selectedMonth = '${mesesRepository.currentMonth()}';

  List<Gasto> gastos = [];

  Gasto? deletedGasto;
  int? deletedGastoPos;
  String? errorText;

  String totalGasto(String currentMes) {
    String mes = currentMes;
    double totalMes;

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

  void deleteAllGastos() {
    setState(() {
      gastos.clear();
    });
    gastoRepository.saveGastoList(gastos);
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
                        'Ganhos',
                        style: TextStyle(fontSize: 30),
                      )),
                  SizedBox(
                    width: 20,
                  ),
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
          ListView(
            shrinkWrap: true,
            children: [
              for (Gasto gasto in gastos)
                if (gasto.title == selectedMonth)
                  GastoListItem(
                    gasto: gasto,
                    ondelete: ondelete,
                  ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: MesDropDownButton(months: mesesRepository.months(), selectedMonth: selectedMonth),
                  // child: Text('data'),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: gastoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descrição',
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: valorController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Valor',
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    String text = gastoController.text.isEmpty
                        ? mesesRepository.currentMonth()
                        : gastoController.text;
                    String value = valorController.text;

                    if (value.isEmpty) {
                      {
                        setState(() {
                          errorText = 'The text field is empty.';
                        });
                        return;
                      }
                    }
                    setState(() {
                      Gasto newGasto = Gasto(title: text, value: value);
                      gastos.add(newGasto);

                      errorText = null;
                    });
                    gastoController.clear();
                    valorController.clear();
                    gastoRepository.saveGastoList(gastos);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.all(18)),
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
