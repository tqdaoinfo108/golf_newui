import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double _kAppBarTapTargetSize = 48;
const double _kAppBarIconSize = 22;
const double _kAppBarTitleFontSize = 18;

// Helper function to safely navigate back without snackbar errors
void _safeBack() {
  try {
    // Try to close any open snackbars safely
    if (Get.isSnackbarOpen == true) {
      Get.closeAllSnackbars();
    }
  } catch (e) {
    // Ignore snackbar errors
    print('Ignoring snackbar error during back navigation: $e');
  }

  // Navigate back
  if (Get.key.currentState?.canPop() ?? false) {
    Navigator.of(Get.context!).pop();
  }
}

Future<void> _handleBack(Future<bool> Function()? onBackPressed) async {
  if (onBackPressed != null) {
    final allowBack = await onBackPressed.call();
    if (allowBack) {
      _safeBack();
    }
    return;
  }
  _safeBack();
}

Future<void> _triggerOnBack({
  VoidCallback? onBack,
  Future<bool> Function()? onBackPressed,
}) async {
  if (onBack != null) {
    onBack();
    return;
  }
  await _handleBack(onBackPressed);
}

Widget _buildLeadingButton({
  VoidCallback? onBack,
  Future<bool> Function()? onBackPressed,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8),
    child: SizedBox(
      width: _kAppBarTapTargetSize,
      height: _kAppBarTapTargetSize,
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
          size: _kAppBarIconSize,
        ),
        constraints: const BoxConstraints.tightFor(
          width: _kAppBarTapTargetSize,
          height: _kAppBarTapTargetSize,
        ),
        splashRadius: 24,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        enableFeedback: false,
        padding: EdgeInsets.zero,
        onPressed: () => _triggerOnBack(
          onBack: onBack,
          onBackPressed: onBackPressed,
        ),
      ),
    ),
  );
}

Widget _buildTitle(
  BuildContext context,
  String title,
  VoidCallback? onBack,
  Future<bool> Function()? onBackPressed,
) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => _triggerOnBack(onBack: onBack, onBackPressed: onBackPressed),
    child: SizedBox(
      height: _kAppBarTapTargetSize,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Colors.white,
            fontSize: _kAppBarTitleFontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),
    ),
  );
}

AppBar _buildApplicationAppBar(
  BuildContext context,
  String title, {
  Color? backgroundColor,
  VoidCallback? onBack,
  Future<bool> Function()? onBackPressed,
  double toolbarHeight = kToolbarHeight,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? Colors.transparent,
    titleSpacing: 8,
    toolbarHeight: toolbarHeight,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    leadingWidth: 56,
    leading: _buildLeadingButton(onBack: onBack, onBackPressed: onBackPressed),
    title: _buildTitle(context, title, onBack, onBackPressed),
  );
}

AppBar ApplicationAppBar(
  BuildContext context,
  String title, {
  Color? backgroundColor,
  VoidCallback? onBack,
  Future<bool> Function()? onBackPressed,
}) {
  return _buildApplicationAppBar(
    context,
    title,
    backgroundColor: backgroundColor,
    onBack: onBack,
    onBackPressed: onBackPressed,
  );
}

AppBar ApplicationAppBarLarge(
  BuildContext context,
  String title, {
  Color? backgroundColor,
  VoidCallback? onBack,
  Future<bool> Function()? onBackPressed,
}) {
  return _buildApplicationAppBar(
    context,
    title,
    backgroundColor: backgroundColor,
    onBack: onBack,
    onBackPressed: onBackPressed,
    toolbarHeight: kToolbarHeight,
  );
}
