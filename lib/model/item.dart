class Item {
  String name;
  String username;
  String rateType;
  int rate;

  Item(this.name, this.username, this.rateType, this.rate);

  static List<Item> items = [
    Item("Dolap", "dolap.png", "B", 12),
    Item("Gofret", "gfrt", "B", 11),
    Item("Halley", "halley.tr", "B", 8),
    Item("Dido", "lkrddo", "B", 9)
  ];
}