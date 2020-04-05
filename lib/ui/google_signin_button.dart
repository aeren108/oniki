import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  VoidCallback onPressed;
  GoogleSignInButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      borderSide: BorderSide(color: Colors.black54),
      splashColor: Colors.grey,
      highlightElevation: 2,
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/google_logo.png"), height: 32.0),

          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text("Google ile giriş yap", style: TextStyle(fontSize: 20, color: Colors.black54)),
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}
