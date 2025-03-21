import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';

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
  Rx<ScrollController> scrollController = ScrollController().obs;
  Rx<TermsOfUseModel> data = TermsOfUseModel().obs;

  var isScrollBottom = false.obs;
  var isDisable = false.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    getValueConfig();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollController.value.addListener(() {
        if (scrollController.value.position.atEdge) {
          bool isTop = scrollController.value.position.pixels == 0;
          if (!isTop) {
            isDisable.value = true;
          }
        }
      });
    });
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
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
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
