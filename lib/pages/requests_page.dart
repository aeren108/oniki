import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/request.dart';
import 'package:oniki/model/user.dart';
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text("İstek yok", style: TextStyle(fontSize: 24))),
                  IconButton(icon: Icon(Icons.refresh), iconSize: 36, onPressed: () { setState(() {}); },)
                ],
              );

            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  Request r = _requests[index];

                  return Column(
                    children: <Widget>[
                      Dismissible(
                        key: Key(r.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete_forever, color: Colors.white, size: 38)
                            ),
                          ),
                        ),
                        child: RequestTile(request: r),
                        onDismissed: (direction) {
                          _userService.deleteRequest(r);
                          setState(() { _requests.remove(r); });
                        },
                      ),
                      Divider(thickness: 1.0, indent: 10.0, endIndent: 10.0)
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
  User receiver;

  String info;

  RequestTile({ @required this.request }) {
    if (request.receiverUser == null)
      request.receiverUser = User.newUser(request.receiverName, request.receiver);

    if (request.rejected)
      info = " bu isteği reddetti";
    else
      info = "'e bir istekte bulundun";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Flexible(
            child: AutoSizeText.rich(TextSpan(
              children: [
                TextSpan(
                  text: request.receiverName,
                  style: TextStyle(color: watermelon),
                  recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (request.receiverUser == null)
                      return ProfilePage.fromUserID(id: request.receiver);
                    else
                      return ProfilePage.withUser(user: request.receiverUser);
                  }))
                ),

                TextSpan(
                  text: info
                )
              ]
            ),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            maxLines: 1)
          ),
        ],
      ),
      subtitle: Text(request.name, style: TextStyle(fontSize: 15)),
      leading: Image.network(
        request.media,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RequestPostPage(receiver: request.receiverUser, request: request))),
    );
  }
}

