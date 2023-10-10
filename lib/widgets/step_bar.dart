import 'package:flutter/material.dart';
import 'package:my_wit_wallet/theme/extended_theme.dart';
import 'package:my_wit_wallet/widgets/PaddedButton.dart';

typedef void StringCallback(String? value);

class StepBar extends StatefulWidget {
  StepBar({
    Key? key,
    required this.actionable,
    required this.steps,
    required this.onChanged,
    this.initialItem,
  }) : super(key: key);

  final List<String> steps;
  final StringCallback onChanged;
  final bool actionable;
  final String? initialItem;

  @override
  State<StatefulWidget> createState() => StepBarState();
}

class StepBarState extends State<StepBar> {
  late String selectedItem;
  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      selectedItem = widget.steps[widget.steps.indexOf(widget.initialItem!)];
    } else {
      selectedItem = widget.steps[0];
    }
  }

  int selectedIndex() => widget.steps.indexOf(this.selectedItem);

  Widget _buildStepBarItem(String item, BuildContext context,
      ExtendedTheme extendedTheme, bool isItemActionable) {
    return Container(
        alignment: Alignment.center,
        child: isItemActionable
            ? PaddedButton(
                padding: EdgeInsets.zero,
                text: item,
                color: _itemColor(item, isItemActionable, extendedTheme),
                onPressed: () => widget.onChanged(item),
                type: ButtonType.stepbar)
            : PaddedButton(
                padding: EdgeInsets.zero,
                enabled: false,
                color: item == selectedItem
                    ? extendedTheme.stepBarActiveColor
                    : extendedTheme.inputIconColor,
                text: item,
                onPressed: () => {},
                type: ButtonType.stepbar));
  }

  @override
  Widget build(BuildContext context) {
    final extendedTheme = Theme.of(context).extension<ExtendedTheme>()!;
    return SizedBox(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.steps.length,
          itemBuilder: (context, index) {
            bool isItemActionable =
                (widget.actionable || (index < selectedIndex())) ? true : false;

            return _buildStepBarItem(
                widget.steps[index], context, extendedTheme, isItemActionable);
          },
        ));
  }

  Color _itemColor(
      String item, bool isItemActionable, ExtendedTheme extendedTheme) {
    if (item == selectedItem) {
      return extendedTheme.stepBarActiveColor!;
    } else if (isItemActionable) {
      return extendedTheme.stepBarActionableColor!;
    }
    return extendedTheme.stepBarColor!;
  }
}
