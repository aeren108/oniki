import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Firestore _firestore = Firestore.instance;

final userRef = _firestore.collection('users');
final groupRef = _firestore.collection('groups');
final postRef = _firestore.collection('posts');
final requestRef = _firestore.collection('requests');

final Color watermelon = Color(0xffED4C67);
final Color alertColor = Color(0xffC03D29);
final Color infoColor = Color(0xff9759e3);

final MOVIE = "Dizi/Film";
final INSTA = "Instagram";
final profilePlaceholder = "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png";

final orangeRedGrad = <Color>[Color(0xfff7781e), Color(0xffed154b)];
final greenBlueGrad = <Color>[Color(0xff43cea2), Color(0xff185a9d)];
final greenLimeGrad = <Color>[Color(0xff009245), Color(0xffFCEE21)];
final pinkPurpleGrad = <Color>[Color(0xfffa5f76), Color(0xffc57ffa)];
final bloodyMaryGrad = <Color>[Color(0xffFF512F), Color(0xffDD2476)];
final pinkBurgundyGrad = <Color>[Color(0xfffc81b2), Color(0xffED4C67)];

final bottomNavItemSize = 34.0;

final appBarGradient = Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: pinkPurpleGrad
    )
  ),
);

SnackBar alertSnackBar(String text) => SnackBar(
                                        content: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                        backgroundColor: alertColor,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 2, milliseconds: 500));
SnackBar infoSnackBar(String text) => SnackBar(
                                        content: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                        backgroundColor: infoColor,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 1, milliseconds: 500));