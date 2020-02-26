import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blabla/Model/Constants.dart';

class CustomImage extends StatelessWidget {
  String imgUrl;
  String initiales;
  double radius;

  CustomImage(this.imgUrl, this.initiales, this.radius);

  @override
  Widget build(BuildContext context) {
    if (imgUrl == null) {
      return new CircleAvatar(
        radius: radius ?? 0.0,
        backgroundColor: Constants.colorElement,
        child: Text(
          initiales ?? "",
          style: TextStyle(
              color: Constants.colorElementSecondary, fontSize: radius),
        ),
      );
    } else {
      ImageProvider provider = CachedNetworkImageProvider(imgUrl);
      if (radius == null) {
        return new InkWell(
          child: Image(
            image: provider,
            width: 250,
          ),
          onTap: () {
            showImg(context, provider);
          },
        );
      } else {
        return new InkWell(
          child: CircleAvatar(
            radius: radius,
            backgroundImage: provider,
          ),
          onTap: () {
            showImg(context, provider);
          },
        );
      }
    }
  }

  Future<void> showImg(BuildContext context, ImageProvider imageProvider) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext build) {
          return new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image(
                  image: imageProvider,
                ),
              ],
            ),
          );
        });
  }
}
