import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyIconData {
  const MyIconData(
    this.iconData, {
    this.svgString,
  });

  final IconData? iconData;
  final String? svgString;

  static const MyIconData
        barcode = MyIconData(null, svgString: '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 3H5V21H3V3Z" fill="white"/>
<path d="M12 3H13V21H12V3Z" fill="white"/>
<path d="M7 3H10V21H7V3Z" fill="white"/>
<path d="M20 3H21V21H20V3Z" fill="white"/>
<path d="M15 3H18V21H15V3Z" fill="white"/>
</svg>'''),

      dataMatrix = MyIconData(null, svgString: '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 3L3 21L21 21L21 19L19 19L19 17L17 17L17 15L15 15L15 13L17 13L19 13L19 15L19 17L21 17L21 15L21 13L21 11L19 11L19 9L17 9L17 11L15 11L15 9L13 9L13 7L11 7L11 9L9 9L9 7L7 7L7 5L5 5L5 3L3 3ZM7 5L9 5L9 7L11 7L11 5L13 5L13 3L11 3L9 3L7 3L7 5ZM13 5L13 7L15 7L15 9L17 9L17 7L19 7L21 7L21 5L21 3L19 3L19 5L17 5L17 3L15 3L15 5L13 5ZM5 9L7 9L7 11L9 11L9 13L7 13L7 15L9 15L9 17L11 17L11 15L13 15L13 17L15 17L15 19L13 19L13 17L11 17L11 19L9 19L9 17L7 17L7 15L5 15L5 13L7 13L7 11L5 11L5 9ZM11 11L13 11L13 13L11 13L11 11Z" fill="white"/>
</svg>'''),

      aztec = MyIconData(null, svgString: '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M7 7H17V17H7V7ZM9 9H15V15H9V9Z" fill="white"/>
<path d="M11 11H13V13H11V11Z" fill="white"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M3 3V21H21V3H3ZM5 5H19V19H5V5Z" fill="white"/>
</svg>'''),

      pdf417 = MyIconData(null, svgString: '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 3H5V21H3V3ZM7 3H7V7H7V11H7V15H9V15H9V11H11V11H11V9H11V7H13V7H13V9H15V9H15V7H17V7H17V3H15V3H15V5H13V5H13V3H11V3H11V5H9V5H9V3H7V3ZM15 9H15V11H15V13H13V13H13V11H11V11H11V13H11V15H9V15H9V17H7V17H7V21H9V21H11V21H11V19H11V17H13V17H13V21H15V21H15V19H17V19H17V15H17V11H17V9H15V9ZM19 3H21V21H19V3Z" fill="white"/>
</svg>''');
}


class MyIcon extends StatelessWidget {
  const MyIcon(
    this.myIconData, {
    super.key,
    this.color,
    this.size,
    this.semanticLabel,
    this.textDirection,
    this.shadows,
  });

  final MyIconData? myIconData;
  final Color? color;
  final double? size;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final List<Shadow>? shadows;

  @override
  Widget build(BuildContext context) {

    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconSize = size ?? iconTheme.size ?? kDefaultFontSize;

    if (myIconData?.iconData != null) {
      return Icon(
        myIconData!.iconData,
        color: color,
        size: iconSize,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
        shadows: shadows,
      );
    } else if (myIconData?.svgString != null) {
      return SvgPicture.string(
        myIconData!.svgString!, //myIconData!.svgString!,
        colorFilter: ColorFilter.mode(
          color ?? iconTheme.color ?? Colors.red,
          BlendMode.srcIn,
        ),
        width: iconSize,
        height: iconSize,
        semanticsLabel: semanticLabel,
      );
    }
    return Semantics(label: semanticLabel, child: SizedBox(width: iconSize, height: iconSize));
  }
}