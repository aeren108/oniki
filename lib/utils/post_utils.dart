import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getInstagramData(String username) async {
  final response = await http.get("https://www.instagram.com/web/search/topsearch/?query={$username}");

  if (response.statusCode == 200) {
    //Everything is okay return instagram profile pic url
    //Look into this json sample (https://www.dropbox.com/s/zwmdwehryun5ffl/data.json?dl=0)
    var data = json.decode(response.body);

    final usernameFixed = data['users'][0]['user']['username'];
    final pictureUrl = data['users'][0]['user']['profile_pic_url'].toString();

    return {
      'username': usernameFixed,
      'url': pictureUrl
    };
  }
}

Future<Map<String, dynamic>> getMovieData(String movie) async {
  List<String> words = movie.split(" ");
  String searchText = "";
  for (var word in words)
    searchText += word + "+";

  final response = await http.get("http://www.omdbapi.com/?apikey=ab62d015&t=$searchText");

  if (response.statusCode == 200) {
    var data = json.decode(response.body);

    String found = data['Response'];
    String title = "";
    String poster = "";
    String year = "";

    if (found == "True") {
      title = data['Title'];
      year = data['Year'];
      poster = data['Poster'];
    }

    return {
      'found': found,
      'title': title,
      'year': year,
      'poster': poster
    };
  }
}