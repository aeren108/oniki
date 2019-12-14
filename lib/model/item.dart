import 'package:http/http.dart' as http;
import 'dart:convert';

class Item {
  String name;
  String username;
  String rateType;
  String picUrl = PLACEHOLDER;
  int rate;

  bool shouldUpdateUrl = true;

  static const String PLACEHOLDER = "https://assets.currencycloud.com/wp-content/uploads/2018/01/profile-placeholder.gif";

  Item(this.name, this.username, this.rateType, this.rate);

  static List<Item> items = List();

  void set instaname(String usrname) {
    if (usrname == username)
      return;
    username = usrname;
    shouldUpdateUrl = true;
  }

  Future<String> getPicURL() async {
    if (shouldUpdateUrl) {
      final response = await http.get("https://www.instagram.com/web/search/topsearch/?query={$username}");

      if (response.statusCode == 200) {
        //Everything is okay return instagram profile pic url
        //Look into this json sample (https://www.dropbox.com/s/zwmdwehryun5ffl/data.json?dl=0)
        var data = json.decode(response.body);
        picUrl = data['users'][0]['user']['profile_pic_url'].toString();
        username = data['users'][0]['user']['username'];

        shouldUpdateUrl = false;
      } else {
        //An error occured return placeholder
        return picUrl = PLACEHOLDER;
      }
    }
    return picUrl;
  }
}