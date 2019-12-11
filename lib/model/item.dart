class Item {
  String name;
  String username;
  String rateType;
  int rate;

  Item(this.name, this.username, this.rateType, this.rate);

  static List<Item> items = List();
}