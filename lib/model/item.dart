import 'package:http/http.dart' as http;
import 'dart:convert';

class Item {
  String name;
  String username;
  String rateType;
  int rate;

  Item(this.name, this.username, this.rateType, this.rate);

  static List<Item> items = List();

  Future<String> getPicURL() async {
    final response = await http.get("https://www.instagram.com/aeren108/?__a=1");

    if (response.statusCode == 200) {
      //Everything is okay return instagram profile pic url
      //Look into this json sample (https://www.dropbox.com/s/zwmdwehryun5ffl/data.json?dl=0)
      //print(json.decode(response.body)['graphql']['user']['profile_pic_url_hd'].toString());
      return json.decode(response.body)['graphql']['user']['profile_pic_url_hd'];
    } else {
      print("Sole");
      //An error occured return profile pic placeholder
      return "https://assets.currencycloud.com/wp-content/uploads/2018/01/profile-placeholder.gif";
    }
  }
}