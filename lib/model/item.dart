import 'package:http/http.dart' as http;
import 'dart:convert';

class Item {
  int id;
  String name;
  String username;
  String rateType;
  String picUrl = PLACEHOLDER;
  int rate;

  bool shouldUpdateUrl = true;

  static const String PLACEHOLDER = "https://assets.currencycloud.com/wp-content/uploads/2018/01/profile-placeholder.gif";

  Item(this.name, this.username, this.rateType, this.rate);
  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    username = map['insta'];
    rate = map['rate'];
    rateType = map['rate_type'];
  }

  set instaname(String username) {
    if (this.username == username)
      return;
    this.username = username;
    shouldUpdateUrl = true;
  }

  Future<String> get instaPhoto async {
    if (shouldUpdateUrl) {
      final response = await http.get("https://www.instagram.com/web/search/topsearch/?query={$username}");

      if (response.statusCode == 200) {
        //Everything is okay return instagram profile pic url
        //Look into this json sample (https://www.dropbox.com/s/zwmdwehryun5ffl/data.json?dl=0)
        var data = json.decode(response.body);
        username = data['users'][0]['user']['username'];
        picUrl = data['users'][0]['user']['profile_pic_url'].toString();

        shouldUpdateUrl = false;
      } else {
        //An error occured return placeholder
        picUrl = PLACEHOLDER;
      }
    }
    return picUrl;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['insta'] = username;
    map['rate'] = rate;
    map['rate_type'] = rateType;
    return map;
  }
}