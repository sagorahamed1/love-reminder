import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    this.maxline,
    this.textOverflow,
    this.fontName,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize,
    this.textHeight,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.italic = false,
    this.text = "",
  });

  final double left;
  final TextOverflow? textOverflow;
  final double right;
  final double top;
  final double bottom;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final String text;
  final TextAlign textAlign;
  final int? maxline;
  final String? fontName;
  final double? textHeight;
  final bool italic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left.w,
        right: right.w,
        top: top.h,
        bottom: bottom.h,
      ),
      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxline,
        overflow: textOverflow ?? TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: (fontSize ?? 14).sp,
          fontFamily: fontName ?? "Georigia",
          fontWeight: fontWeight,
          color: color ?? Colors.black,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          height: textHeight,
        ),
      ),
    );
  }
}
