import 'package:flutter/material.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  var controller =
      WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse("https://www.sky-trak.com/overview.html"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar("back".tr),
      body: Container(
        height: double.infinity,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.0.w),
            topRight: Radius.circular(6.0.w),
          ),
          color: Colors.white,
        ),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
