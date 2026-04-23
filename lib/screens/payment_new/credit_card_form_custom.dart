import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

import 'credit_card_validator.dart';
import 'masked_text_controller.dart';

// ignore: must_be_immutable
class CreditCardFormCustom extends StatefulWidget {
  CreditCardFormCustom({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.obscureCvv = false,
    this.obscureNumber = false,
    required this.onCreditCardModelChange,
    required this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.cardHolderDecoration = const InputDecoration(
      labelText: 'Card holder',
      errorMaxLines: 2,
    ),
    this.cardNumberDecoration = const InputDecoration(
      labelText: 'Card number',
      hintText: 'XXXX XXXX XXXX XXXX',
      errorMaxLines: 2,
    ),
    this.expiryDateDecoration = const InputDecoration(
      labelText: 'Expired Date',
      hintText: 'MM/YY',
      errorMaxLines: 2,
    ),
    this.cvvCodeDecoration = const InputDecoration(
      labelText: 'CVV',
      hintText: 'XXX',
      errorMaxLines: 2,
    ),
    required this.formKey,
    this.cardNumberKey,
    this.cardHolderKey,
    this.expiryDateKey,
    this.cvvCodeKey,
    this.cvvValidationMessage = 'Please input a valid CVV',
    this.dateValidationMessage = 'Please input a valid date',
    this.numberValidationMessage = 'Please input a valid number',
    this.isHolderNameVisible = true,
    this.isCardNumberVisible = true,
    this.isExpiryDateVisible = true,
    this.enableCvv = true,
    this.autovalidateMode,
    this.cardNumberValidator,
    this.expiryDateValidator,
    this.cvvValidator,
    this.cardHolderValidator,
    this.onFormComplete,
    this.disableCardNumberAutoFillHints = false,
    this.isReadOnly = false,
    this.cardHolderNameController,
    this.cardNumberController,
    this.cvvCodeController,
    this.expiryDateController,
    this.cvvErrorText,
    this.dateErrorText,
  }) : super(key: key);

  /// A string indicating card number in the text field.
  final String cardNumber;

  /// A string indicating expiry date in the text field.
  final String expiryDate;

  /// A string indicating card holder name in the text field.
  final String cardHolderName;

  /// A string indicating cvv code in the text field.
  final String cvvCode;

  /// Error message string when invalid cvv is entered.
  final String cvvValidationMessage;

  /// Error message string when invalid expiry date is entered.
  final String dateValidationMessage;

  /// Error message string when invalid credit card number is entered.
  final String numberValidationMessage;

  /// Provides callback when there is any change in [CreditCardModel].
  final void Function(CreditCardModel) onCreditCardModelChange;

  /// Color of the theme of the credit card form.
  final Color themeColor;

  /// Color of text in the credit card form.
  final Color textColor;

  /// Cursor color in the credit card form.
  final Color? cursorColor;

  /// When enabled cvv gets hidden with obscuring characters. Defaults to
  /// false.
  final bool obscureCvv;

  /// When enabled credit card number get hidden with obscuring characters.
  /// Defaults to false.
  final bool obscureNumber;

  /// Allow editing the holder name by enabling this in the credit card form.
  /// Defaults to true.
  final bool isHolderNameVisible;

  /// Allow editing the credit card number by enabling this in the credit
  /// card form. Defaults to true.
  final bool isCardNumberVisible;

  /// Allow editing the cvv code by enabling this in the credit card form.
  /// Defaults to true.
  final bool enableCvv;

  /// Allows editing the expiry date by enabling this in the credit
  /// card form. Defaults to true.
  final bool isExpiryDateVisible;

  /// A form state key for this credit card form.
  final GlobalKey<FormState> formKey;

  /// Provides a callback when text field provides callback in
  /// [onEditingComplete].
  final Function? onFormComplete;

  /// A FormFieldState key for card number text field.
  final GlobalKey<FormFieldState<String>>? cardNumberKey;

  /// A FormFieldState key for card holder text field.
  final GlobalKey<FormFieldState<String>>? cardHolderKey;

  /// A FormFieldState key for expiry date text field.
  final GlobalKey<FormFieldState<String>>? expiryDateKey;

  /// A FormFieldState key for cvv code text field.
  final GlobalKey<FormFieldState<String>>? cvvCodeKey;

  /// Provides decoration to card number text field.
  final InputDecoration cardNumberDecoration;

  /// Provides decoration to card holder text field.
  final InputDecoration cardHolderDecoration;

  /// Provides decoration to expiry date text field.
  final InputDecoration expiryDateDecoration;

  /// Provides decoration to cvv code text field.
  final InputDecoration cvvCodeDecoration;

  /// Used to configure the auto validation of [FormField] and [Form] widgets.
  final AutovalidateMode? autovalidateMode;

  /// A validator for card number text field.
  final String? Function(String?)? cardNumberValidator;

  /// A validator for expiry date text field.
  final String? Function(String?)? expiryDateValidator;

  /// A validator for cvv code text field.
  final String? Function(String?)? cvvValidator;

  /// A validator for card holder text field.
  final String? Function(String?)? cardHolderValidator;

  /// Setting this flag to true will disable autofill hints for Credit card
  /// number text field. Flutter has a bug when auto fill hints are enabled for
  /// credit card numbers it shows keyboard with characters. But, disabling
  /// auto fill hints will show correct keyboard.
  ///
  /// Defaults to false.
  ///
  /// You can follow the issue here
  /// [https://github.com/flutter/flutter/issues/104604](https://github.com/flutter/flutter/issues/104604).
  final bool disableCardNumberAutoFillHints;

  final bool isReadOnly;

  MaskedTextController?
  cardNumberController; //   MaskedTextController(mask: '0000 0000 0000 0000');
  TextEditingController?
  expiryDateController; // MaskedTextController(mask: '00/00');

  TextEditingController? cardHolderNameController; // TextEditingController();

  TextEditingController? cvvCodeController;

  final String? cvvErrorText;
  final String? dateErrorText;

  @override
  _CreditCardFormCustomState createState() => _CreditCardFormCustomState();
}

class _CreditCardFormCustomState extends State<CreditCardFormCustom> {
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  bool isCvvFocused = false;
  late Color themeColor;

  late void Function(CreditCardModel) onCreditCardModelChange;
  late CreditCardModel creditCardModel;

  FocusNode cvvFocusNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;

    creditCardModel = CreditCardModel(
      cardNumber,
      expiryDate,
      cardHolderName,
      cvvCode,
      isCvvFocused,
    );
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();
    widget.cardNumberController ??= MaskedTextController(
      mask: '0000 0000 0000 0000',
    );
    widget.expiryDateController ??= MaskedTextController(mask: '00/00');
    widget.cardHolderNameController ??= TextEditingController();
    widget.cvvCodeController ??= MaskedTextController(mask: '0000');

    widget.cardNumberController!.text = widget.cardNumber;
    widget.expiryDateController!.text = widget.expiryDate;
    widget.cardHolderNameController!.text = widget.cardHolderName;
    widget.cvvCodeController!.text = widget.cvvCode;

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);
  }

  @override
  void dispose() {
    cardHolderNode.dispose();
    cvvFocusNode.dispose();
    expiryDateNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: widget.isCardNumberVisible,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(widget.cardNumberDecoration),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: widget.cardNumberKey,
                      obscureText: widget.obscureNumber,
                      controller: widget.cardNumberController,
                      onChanged: (String value) {
                        setState(() {
                          cardNumber = widget.cardNumberController!.text;
                          creditCardModel.cardNumber = cardNumber;
                          onCreditCardModelChange(creditCardModel);
                        });
                      },
                      cursorColor: widget.cursorColor ?? themeColor,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(expiryDateNode);
                      },
                      style: TextStyle(color: widget.textColor),
                      decoration: _buildInputDecorationWithoutLabel(
                        widget.cardNumberDecoration,
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints:
                          widget.disableCardNumberAutoFillHints
                              ? null
                              : const <String>[AutofillHints.creditCardNumber],
                      autovalidateMode: widget.autovalidateMode,
                      readOnly: widget.isReadOnly,
                      validator:
                          widget.cardNumberValidator ??
                          (String? value) {
                            if (value?.isEmpty ?? true) {
                              return "card_number_empty".tr;
                            }

                            Map<String, dynamic> cardData =
                                CreditCardValidator.getCard(
                                  (value ?? "").replaceAll(" ", ""),
                                );

                            if (value!.isEmpty ||
                                value.length < 16 ||
                                !cardData[CreditCardValidator.isValidCard]) {
                              return widget.numberValidationMessage;
                            }

                            return null;
                          },
                    ),
                  ],
                ),
              ),
            ),
            if (widget.isExpiryDateVisible)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(widget.expiryDateDecoration),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: widget.expiryDateKey,
                      controller: widget.expiryDateController,
                      onChanged: (String value) {
                        if (widget.expiryDateController!.text.startsWith(
                          RegExp('[2-9]'),
                        )) {
                          widget.expiryDateController!.text =
                              '0' + widget.expiryDateController!.text;
                        }
                        setState(() {
                          expiryDate = widget.expiryDateController!.text;
                          creditCardModel.expiryDate = expiryDate;
                          onCreditCardModelChange(creditCardModel);
                        });
                      },
                      cursorColor: widget.cursorColor ?? themeColor,
                      focusNode: expiryDateNode,
                      onEditingComplete: () {
                        if (widget.enableCvv) {
                          FocusScope.of(context).requestFocus(cvvFocusNode);
                        } else {
                          FocusScope.of(context).requestFocus(cardHolderNode);
                        }
                      },
                      style: TextStyle(color: widget.textColor),
                      decoration: _buildInputDecorationWithoutLabel(
                        widget.expiryDateDecoration,
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const <String>[
                        AutofillHints.creditCardExpirationDate,
                      ],
                      validator:
                          widget.expiryDateValidator ??
                          (String? value) {
                            if (value!.isEmpty) {
                              return "expired_date_empty".tr;
                            }
                            final DateTime now = DateTime.now();
                            final List<String> date = value.split(RegExp(r'/'));
                            final int month = int.parse(date.first);
                            final int year = int.parse('20${date.last}');
                            final int lastDayOfMonth =
                                month < 12
                                    ? DateTime(year, month + 1, 0).day
                                    : DateTime(year + 1, 1, 0).day;
                            final DateTime cardDate = DateTime(
                              year,
                              month,
                              lastDayOfMonth,
                              23,
                              59,
                              59,
                              999,
                            );

                            if (cardDate.isBefore(now) ||
                                month > 12 ||
                                month == 0) {
                              return widget.dateValidationMessage;
                            }
                            return null;
                          },
                    ),
                  ],
                ),
              ),
            if (widget.enableCvv)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(widget.cvvCodeDecoration),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: widget.cvvCodeKey,
                      obscureText: widget.obscureCvv,
                      focusNode: cvvFocusNode,
                      controller: widget.cvvCodeController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      style: TextStyle(color: widget.textColor),
                      decoration: _buildInputDecorationWithoutLabel(
                        widget.cvvCodeDecoration,
                        clearErrorText: true,
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction:
                          widget.isHolderNameVisible
                              ? TextInputAction.next
                              : TextInputAction.done,
                      autofillHints: const <String>[
                        AutofillHints.creditCardSecurityCode,
                      ],
                      onChanged: (String text) {
                        setState(() {
                          cvvCode = text;
                          creditCardModel.cvvCode = cvvCode;
                          onCreditCardModelChange(creditCardModel);
                        });
                      },
                      validator:
                          widget.cvvValidator ??
                          (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return widget.cvvValidationMessage;
                            }
                            return null;
                          },
                    ),
                  ],
                ),
              ),
            if (widget.dateErrorText != null &&
                widget.dateErrorText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.dateErrorText!,
                  style: TextStyle(color: Color(0xFFE53935), fontSize: 12),
                ),
              ),

            // ErrorText custom, tràn ra toàn màn hình
            if (widget.cvvErrorText != null && widget.cvvErrorText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.cvvErrorText!,
                  style: TextStyle(color: Color(0xFFE53935), fontSize: 12),
                ),
              ),
            Visibility(
              visible: widget.isHolderNameVisible,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(widget.cardHolderDecoration),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: widget.cardHolderKey,
                      controller: widget.cardHolderNameController,
                      onChanged: (String value) {
                        setState(() {
                          String filteredValue = value.replaceAll(
                            RegExp(r'[^a-zA-Z\s]'),
                            '',
                          );

                          widget.cardHolderNameController!.text =
                              filteredValue.toUpperCase();
                          cardHolderName =
                              widget.cardHolderNameController!.text;
                          creditCardModel.cardHolderName = cardHolderName;
                          onCreditCardModelChange(creditCardModel);

                          widget
                              .cardHolderNameController!
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset:
                                  widget.cardHolderNameController!.text.length,
                            ),
                          );
                        });
                      },
                      cursorColor: widget.cursorColor ?? themeColor,
                      focusNode: cardHolderNode,
                      style: TextStyle(color: widget.textColor),
                      decoration: _buildInputDecorationWithoutLabel(
                        widget.cardHolderDecoration,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      autofillHints: const <String>[
                        AutofillHints.creditCardName,
                      ],
                      onEditingComplete: () {
                        final String normalizedHolderName = widget
                            .cardHolderNameController!
                            .text
                            .trim()
                            .replaceAll(RegExp(r'\s+'), ' ');

                        if (widget.cardHolderNameController!.text !=
                            normalizedHolderName) {
                          widget.cardHolderNameController!.text =
                              normalizedHolderName;
                          widget
                              .cardHolderNameController!
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: normalizedHolderName.length),
                          );
                        }

                        cardHolderName = normalizedHolderName;
                        creditCardModel.cardHolderName = cardHolderName;

                        FocusScope.of(context).unfocus();
                        onCreditCardModelChange(creditCardModel);
                        widget.onFormComplete?.call();
                      },
                      validator:
                          widget.cardHolderValidator ??
                          (String? value) {
                            final String normalizedValue = value?.trim() ?? '';

                            if (normalizedValue.isEmpty) {
                              return 'card_holder_empty'.tr;
                            }

                            if (!RegExp(
                              r'^[a-zA-Z]+(?:\s+[a-zA-Z]+)*$',
                            ).hasMatch(normalizedValue)) {
                              return 'Please enter only alphabetic characters'
                                  .tr;
                            }
                            return null;
                          },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(InputDecoration decoration) {
    final String? text = decoration.labelText;
    if ((text ?? '').isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> labelLines =
        text!
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    final String title = labelLines.isNotEmpty ? labelLines.first : text;
    final String normalizedExample = _sanitizeExampleText(decoration.hintText);
    final String fallbackExample =
        labelLines.length > 1 ? labelLines.sublist(1).join(' ') : '';
    final bool hasExample =
        normalizedExample.isNotEmpty || fallbackExample.isNotEmpty;
    final String displayExample =
        normalizedExample.isNotEmpty
            ? _formatExampleText(normalizedExample)
            : fallbackExample;
    final TextStyle titleStyle =
        decoration.labelStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3B3F63),
        );
    final TextStyle exampleStyle = titleStyle.copyWith(
      fontSize: 13,
      height: 1.15,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: titleStyle),
        if (hasExample) Text(displayExample, style: exampleStyle),
      ],
    );
  }

  InputDecoration _buildInputDecorationWithoutLabel(
    InputDecoration decoration, {
    bool clearErrorText = false,
    TextStyle? errorStyle,
  }) {
    return InputDecoration(
      icon: decoration.icon,
      iconColor: decoration.iconColor,
      labelStyle: decoration.labelStyle,
      floatingLabelStyle: decoration.floatingLabelStyle,
      helperStyle: decoration.helperStyle,
      helperText: decoration.helperText,
      helperMaxLines: decoration.helperMaxLines,
      hintText: decoration.hintText,
      hintStyle: decoration.hintStyle,
      hintTextDirection: decoration.hintTextDirection,
      hintMaxLines: decoration.hintMaxLines,
      errorStyle: errorStyle ?? decoration.errorStyle,
      errorText: clearErrorText ? null : decoration.errorText,
      errorMaxLines: decoration.errorMaxLines,
      floatingLabelBehavior: decoration.floatingLabelBehavior,
      isCollapsed: decoration.isCollapsed,
      isDense: decoration.isDense,
      contentPadding: decoration.contentPadding,
      prefixIcon: decoration.prefixIcon,
      prefixIconConstraints: decoration.prefixIconConstraints,
      prefixIconColor: decoration.prefixIconColor,
      prefix: decoration.prefix,
      prefixText: decoration.prefixText,
      prefixStyle: decoration.prefixStyle,
      suffixIcon: decoration.suffixIcon,
      suffixIconConstraints: decoration.suffixIconConstraints,
      suffixIconColor: decoration.suffixIconColor,
      suffix: decoration.suffix,
      suffixText: decoration.suffixText,
      suffixStyle: decoration.suffixStyle,
      counter: decoration.counter,
      counterText: decoration.counterText,
      counterStyle: decoration.counterStyle,
      filled: decoration.filled,
      fillColor: decoration.fillColor,
      focusColor: decoration.focusColor,
      hoverColor: decoration.hoverColor,
      errorBorder: decoration.errorBorder,
      focusedBorder: decoration.focusedBorder,
      focusedErrorBorder: decoration.focusedErrorBorder,
      disabledBorder: decoration.disabledBorder,
      enabledBorder: decoration.enabledBorder,
      border: decoration.border,
      enabled: decoration.enabled,
      semanticCounterText: decoration.semanticCounterText,
      alignLabelWithHint: decoration.alignLabelWithHint,
      constraints: decoration.constraints,
    );
  }

  String _sanitizeExampleText(String? raw) {
    if (raw == null) {
      return '';
    }

    return raw
        .replaceAll('「', '')
        .replaceAll('」', '')
        .replaceAll('（', '')
        .replaceAll('）', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('例：', '')
        .replaceAll('例:', '')
        .replaceAll('e.g.', '')
        .replaceAll('e.g', '')
        .trim();
  }

  String _formatExampleText(String raw) {
    final String normalized = raw.trim();
    if (normalized.isEmpty) {
      return '';
    }
    if (normalized.startsWith('(') || normalized.startsWith('（')) {
      return normalized;
    }
    if (normalized.toUpperCase() == 'CVC/CVV') {
      return '(CVC/CVV)';
    }
    final bool isJapanese = (Get.locale?.languageCode ?? 'ja') == 'ja';
    return isJapanese ? '(例：$normalized)' : '(e.g. $normalized)';
  }
}
