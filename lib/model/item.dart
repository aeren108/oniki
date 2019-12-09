class Item {
  String name;
  String rateType;
  int rate;

  Item(this.name, this.rateType, this.rate);

  static List<Item> items = [
    Item("Dolap", "B", 12),
    Item("Gofret", "B", 11),
    Item("Halley", "B", 8),
    Item("Dido", "B", 9)
  ];
}