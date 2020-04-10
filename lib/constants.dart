import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;

final userRef = _firestore.collection('users');
final followingRef = _firestore.collection('following');
final followerRef = _firestore.collection('followers');
final postRef = _firestore.collection('posts');
final requestRef = _firestore.collection('requests');
final notifRef = _firestore.collection('notifications');

final Color watermelon = Color(0xffff6348);

final orangeRedGrad = <Color>[Color(0xfff7781e), Color(0xffed154b)];
final greenBlueGrad = <Color>[Color(0xff43cea2), Color(0xff185a9d)];
final greenLimeGrad = <Color>[Color(0xff009245), Color(0xffFCEE21)];
final pinkPurpleGrad = <Color>[Color(0xffEA8D8D), Color(0xffA890FE)];
final bloodyMaryGrad = <Color>[Color(0xffFF512F), Color(0xffDD2476)];