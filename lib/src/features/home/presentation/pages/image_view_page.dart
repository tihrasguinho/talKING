import 'dart:io';

import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Image View'),
      ),
      body: Center(
        child: Hero(
          tag: widget.image,
          child: widget.isLocal ? Image.file(File(widget.image)) : Image.network(widget.image),
        ),
      ),
    );
  }
}
