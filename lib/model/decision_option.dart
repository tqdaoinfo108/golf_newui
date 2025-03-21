import 'package:golf_uiv2/utils/constants.dart';

class DecisionOption {
  String title;
  DecisionOptionType type;
  bool isImportant;
  bool isCompleteDecision;
  Function? onDecisionPressed;

  DecisionOption(this.title,
      {this.type = DecisionOptionType.NORMAL,
      this.isImportant = false,
      this.isCompleteDecision = true,
      required this.onDecisionPressed});
}
