class Gasto {
  Gasto({required this.title, required this.value});

  Gasto.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        value = json['value'];
  String title;
  String value;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
    };
  }
}
