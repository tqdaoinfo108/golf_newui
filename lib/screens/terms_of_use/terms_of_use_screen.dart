import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/terms_of_use/terms_of_use_controller.dart';
import 'package:sizer/sizer.dart';
import '../../utils/color.dart';
import '../../widgets/button_default.dart';

class TermsOfUseScreen extends GetView<TermsOfUseScreenController> {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: GolfColor.GolfPrimaryColor,
        appBar: AppBar(
            title: Text(
          controller.data.value.title ?? "",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        )),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0.w),
                    topRight: Radius.circular(6.0.w)),
                color: Colors.grey.shade200,
              ),
              child: Column(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      width: 90.w,
                      child: Scrollbar(
                        controller: controller.scrollController.value,
                        child: SingleChildScrollView(
                          controller: controller.scrollController.value,
                          child: HtmlWidget(
                            controller.data.value.content ?? "",
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Column(
                      children: [
                        Opacity(
                          opacity: controller.isDisable.value ? 1 : 0.5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                activeColor: GolfColor.GolfPrimaryColor,
                                value: controller.isScrollBottom.value,
                                onChanged: (value) {
                                  controller.onChangeCheckBox();
                                },
                              ),
                              Text(controller.data.value.agree ?? "",
                                  style: Theme.of(context).textTheme.bodyMedium)
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: controller.isScrollBottom.value ? 1 : 0.5,
                          child: DefaultButton(
                              text: controller.data.value.confirm ?? "",
                              textColor: Colors.white,
                              backgroundColor: GolfColor.GolfPrimaryColor,
                              press: () {
                                controller.save();
                              }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 40)
                ],
              ),
            ),
            if (controller.isLoading.value)
              Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0.w),
                        topRight: Radius.circular(6.0.w)),
                    color: Colors.grey.shade200,
                  ),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
