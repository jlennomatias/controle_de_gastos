class Gasto {
  Gasto({required this.title, required this.value, required this.month});

  Gasto.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        value = json['value'],
        month = json['month'];
  String title;
  String value;
  String month;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'month': month,
    };
  }
}
