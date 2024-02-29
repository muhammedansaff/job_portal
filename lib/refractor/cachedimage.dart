import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Refimagecached extends StatelessWidget {
  final Animation<double> animation;
  final String imgurl;
  const Refimagecached(
      {super.key, required this.animation, required this.imgurl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imgurl,
        placeholder: (context, url) => Image.asset(
              'assets/images/loading.gif',
              fit: BoxFit.cover,
            ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        alignment: FractionalOffset(animation.value, 0));
  }
}// refactored cached image network used in login signup and foprgot password
