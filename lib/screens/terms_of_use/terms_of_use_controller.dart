import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/golf_api.dart';
import '../../translations/localization_service.dart';
import '../../utils/keys.dart';
import '../../utils/support.dart';

class TermsOfUseScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsOfUseScreenController>(() => TermsOfUseScreenController());
  }
}

class TermsOfUseScreenController extends GetxController {
  Rx<TermsOfUseModel> data = TermsOfUseModel().obs;
  final Rxn<WebViewController> webViewController = Rxn<WebViewController>();

  static const String termsUrl = 'https://mujin24.com/termnopolicy';

  var isScrollBottom = false.obs;
  var isDisable = false.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    _initWebView();
    getValueConfig();
  }

  void _initWebView() {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'TermsScrollChannel',
            onMessageReceived: (message) {
              if (message.message == 'bottom') {
                isDisable.value = true;
              }
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                isLoading.value = false;
                _attachBottomListener();
              },
              onWebResourceError: (_) {
                isLoading.value = false;
              },
            ),
          )
          ..loadRequest(Uri.parse(termsUrl));

    webViewController.value = controller;
  }

  void _attachBottomListener() {
    webViewController.value?.runJavaScript('''
      (function () {
        if (window.__termsScrollBound) return;
        window.__termsScrollBound = true;

        function notifyIfBottom() {
          var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
          var viewportHeight = window.innerHeight || document.documentElement.clientHeight || 0;
          var fullHeight = Math.max(
            document.body.scrollHeight || 0,
            document.documentElement.scrollHeight || 0
          );

          if (scrollTop + viewportHeight >= fullHeight - 8) {
            TermsScrollChannel.postMessage('bottom');
          }
        }

        window.addEventListener('scroll', notifyIfBottom, { passive: true });
        notifyIfBottom();
      })();
    ''');
  }

  void onChangeCheckBox() {
    if (isDisable.value) {
      isScrollBottom.value = !isScrollBottom.value;
    }
  }

  void save() {
    if (isScrollBottom.value) {
      SupportUtils.prefs.setBool(IS_FIRST_OPEN_APP, true);
      Get.offAndToNamed(AppRoutes.LOGIN);
    }
  }

  Future<void> getValueConfig() async {
    var _result = await GolfApi().getKeyConfigByKey("TermsOfUse");

    /// Handle result
    if (_result.data != null && _result.data!.isNotEmpty) {
      var value = TermsOfUseBaseModel.fromJson(jsonDecode(_result.data!));
      var locale = LocalizationService.locale;
      if (locale.languageCode == "en") {
        data.value =
            value.data!.firstWhere((element) => element.language == "en");
      } else {
        data.value =
            value.data!.firstWhere((element) => element.language == "jp");
      }
    }
  }
}

class TermsOfUseBaseModel {
  List<TermsOfUseModel>? data;

  TermsOfUseBaseModel({this.data});

  TermsOfUseBaseModel.fromJson(Map<String, dynamic> json) {
    this.data = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => TermsOfUseModel.fromJson(e))
            .toList();
  }
}

class TermsOfUseModel {
  String? language;
  String? title;
  String? content;
  String? agree;
  String? confirm;

  TermsOfUseModel(
      {this.language, this.title, this.content, this.agree, this.confirm});

  TermsOfUseModel.fromJson(Map<String, dynamic> json) {
    this.language = json["language"];
    this.title = json["title"];
    this.content = json["content"];
    this.agree = json["agree"];
    this.confirm = json["confirm"];
  }
}
