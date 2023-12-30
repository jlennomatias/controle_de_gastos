import 'dart:convert';

import 'package:controle_gastos/models/gasto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


const gastoListKey = 'gasto_list';


class GastoRepository {

  GastoRepository() {
    initSharedPreferences();
  }
  Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  late SharedPreferences sharedPreferences;

  Future<List<Gasto>> getGastoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(gastoListKey) ?? '[]';
    final List jsonDecode = json.decode(jsonString) as List;
    return jsonDecode.map((e) => Gasto.fromJson(e)).toList();
  }

  void saveGastoList(List<Gasto> gastos) {
    final String jsonString = json.encode(gastos);
    sharedPreferences.setString(gastoListKey, jsonString);
  }
}
