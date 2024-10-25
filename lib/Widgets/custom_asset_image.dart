import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomAssetImage extends StatelessWidget {
  final double height;
  final double width;
  final String image;
  final bool isSvg;
  final Color? imageColor;

  const CustomAssetImage(
      {super.key,
      required this.height,
      required this.width,
      required this.image,
      required this.isSvg,
      this.imageColor});

  @override
  Widget build(BuildContext context) {
    return (isSvg == true)
        ? SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(image, fit: BoxFit.fill, color: imageColor))
        : SizedBox(
            height: height,
            width: width,
            child: Image.asset(image, fit: BoxFit.fill),
          );
  }
}
