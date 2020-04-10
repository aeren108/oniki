import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  Widget child;
  VoidCallback onPressed;
  List<Color> colors;

  GradientButton({@required this.child, @required this.onPressed, this.colors});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.all(0.0),
      textColor: Colors.white,

      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            gradient: LinearGradient(
                colors: colors
            )
        ),
        padding: const EdgeInsets.all(10.0),
        child: child
      ),

      onPressed: onPressed
    );
  }
}
