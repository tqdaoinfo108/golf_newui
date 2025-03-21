import 'package:flutter/material.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sizer/sizer.dart';

class TextClick extends StatelessWidget {
  final ThemeData? themeData;
  final String? lastText;
  final Function? onClicked;
  TextClick({this.themeData, this.lastText, this.onClicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onClicked as void Function()?,
        child: Text(
          lastText!,
          style:
              GoogleFonts.openSans(fontSize: 16, color: GolfColor
                  .GolfPrimaryColor),
          maxLines: 2,
        ));
  }
}

Widget createQRCode(String data, {double width = 300, int typeNumber = 12}) {
  return PrettyQr(
      typeNumber: null,
      size: width,
      data: data,
      errorCorrectLevel: 1,
      roundEdges: true);
}

// Widget TextClicked(ThemeData themeData, String firstText, String lastText) {
//   return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//     Text(
//       firstText,
//       style: themeData.textTheme.headlineSmall,
//     ),
//     InkWell(
//         child: Text(lastText,
//             style:
//                 GoogleFonts.openSans(fontSize: 18, color: Color(0xff376AED))))
//   ]);
// }
