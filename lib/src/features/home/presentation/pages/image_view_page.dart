import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({
    Key? key,
    required this.image,
    this.isLocal = false,
  }) : super(key: key);

  final String image;
  final bool isLocal;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Modular.to.pop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: widget.image,
            child: widget.isLocal ? Image.file(File(widget.image)) : Image.network(widget.image),
          ),
        ),
      ),
    );
  }
}
