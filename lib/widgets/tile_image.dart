import 'package:flutter/material.dart';
import 'package:oniki/constants.dart';
import 'package:oniki/model/post.dart';

class TileImage extends StatelessWidget {
  Post post;
  double size = 48;

  TileImage({ @required this.post, this.size });

  @override
  Widget build(BuildContext context) {
    return post.type == MOVIE ? Image.network(
      post.mediaUrl ?? profilePlaceholder,
      width: size,
      height: size * 4 / 3,
      fit: BoxFit.fitWidth,
    ) : CircleAvatar(
      backgroundImage: NetworkImage(post.mediaUrl ?? profilePlaceholder),
      radius: size / 2,
    );
  }
}
