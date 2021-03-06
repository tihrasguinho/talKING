import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:talking/src/core/domain/entities/user_entity.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    Key? key,
    required this.user,
    this.size = const Size(64, 64),
    this.onTap,
  }) : super(key: key);

  final UserEntity user;
  final Size size;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String _sufix() {
      return user.name.split('').take(2).join().toUpperCase();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          image: user.image.isEmpty
              ? null
              : DecorationImage(
                  image: CachedNetworkImageProvider(
                    user.image,
                    maxWidth: size.width.round() * 2,
                    maxHeight: size.height.round() * 2,
                  ),
                  fit: BoxFit.cover,
                ),
        ),
        child: user.image.isEmpty
            ? Center(
                child: Text(
                  _sufix(),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white,
                        fontSize: size.width * 0.35,
                      ),
                ),
              )
            : null,
      ),
    );
  }
}
