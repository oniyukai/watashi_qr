import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyIconData {
  final IconData? iconData;
  final String? svgString;

  const MyIconData(
    this.iconData, {
    this.svgString,
  });

  static const MyIconData
      barcode = MyIconData(null, svgString: '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3 3H5V21H3V3Z" fill="white"/>
<path d="M12 3H13V21H12V3Z" fill="white"/>
<path d="M7 3H10V21H7V3Z" fill="white"/>
<path d="M20 3H21V21H20V3Z" fill="white"/>
<path d="M15 3H18V21H15V3Z" fill="white"/>
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
  final MyIconData? myIconData;
  final Color? color;
  final double? size;
  final String? semanticLabel;
  final List<Shadow>? shadows;

  const MyIcon(
    this.myIconData, {
    super.key,
    this.color,
    this.size,
    this.semanticLabel,
    this.shadows,
  });

  @override
  Widget build(context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconSize = size ?? iconTheme.size ?? kDefaultFontSize;
    return myIconData?.svgString != null ? SizedBox.square(
      dimension: iconSize,
      child: Center(
        child: SvgPicture.string(
          myIconData!.svgString!,
          colorFilter: .mode(
            color ?? iconTheme.color ?? Theme.of(context).colorScheme.error,
            BlendMode.srcIn,
          ),
          semanticsLabel: semanticLabel,
        ),
      ),
    ) : Icon(
      myIconData?.iconData,
      color: color,
      size: iconSize,
      semanticLabel: semanticLabel,
      shadows: shadows,
    );
  }
}
