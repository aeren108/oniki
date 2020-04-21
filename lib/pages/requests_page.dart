import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/request.dart';
import 'package:oniki/pages/profile_page.dart';
import 'package:oniki/pages/request_post_page.dart';
import 'package:oniki/services/user_service.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final _userService = UserService.instance;
  
  Future<List<Request>> _future;
  List<Request> _requests = [];
  
  @override
  Widget build(BuildContext context) {
    _future = _userService.getRequests();
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("İstekler", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: appBarGradient,
      ),

      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return _future = _userService.getRequests();
        },
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if ((snapshot.connectionState != ConnectionState.done || !snapshot.hasData) && _requests.isEmpty)
              return Center(child: CircularProgressIndicator());

            _requests = snapshot.data;

            if (_requests.isEmpty)
              return Center(child: Text("İstek yok", style: TextStyle(fontSize: 24)));

            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  Request r = _requests[index];

                  return Column(
                    children: <Widget>[
                      RequestTile(request: r),
                      Divider(thickness: 1.0)
                    ],
                  );
                }
              ),
            );
          },
        ),
      )
    );
  }
}

class RequestTile extends StatelessWidget {
  Request request;

  RequestTile({ @required this.request });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          InkWell(
            child: Text(request.receiverName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: watermelon)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage.fromUserID(id: request.receiver))),
          ),
          Text("'e bir istekte bulundun", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
      subtitle: Text(request.name, style: TextStyle(fontSize: 15)),
      leading: CircleAvatar(
        child: Image(image: NetworkImage(request.media)),
        radius: 28,
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
        if (request.receiverUser == null)
          return ProfilePage.fromUserID(id: request.receiver);
        else
          return ProfilePage.withUser(user: request.receiverUser);
      })),
    );
  }
}

