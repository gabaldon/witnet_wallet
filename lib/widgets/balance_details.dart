import 'package:my_wit_wallet/constants.dart';
import 'package:my_wit_wallet/theme/extended_theme.dart';
import 'package:my_wit_wallet/util/extensions/num_extensions.dart';
import 'package:my_wit_wallet/util/get_localization.dart';
import 'package:my_wit_wallet/util/storage/database/balance_info.dart';
import 'package:flutter/material.dart';

typedef void VoidCallback();

class BalanceDetails extends StatelessWidget {
  BalanceDetails({required this.balance, required this.stakedBalance});
  final BalanceInfo balance;
  final StakedBalanceInfo stakedBalance;

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final extendedTheme = theme.extension<ExtendedTheme>()!;
    final textStyle = extendedTheme.regularPanelText;
    final labelTextStyle = extendedTheme.mediumPanelText;
    ;
    return Padding(
        padding: EdgeInsets.only(top: 32, bottom: 32, left: 24, right: 24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.balanceDetails,
                style: labelTextStyle,
              ),
              SizedBox(height: 24),
              Row(children: [
                Text(
                  localization.available,
                  style: labelTextStyle,
                ),
                Spacer(),
                Text(
                  '${balance.availableNanoWit.standardizeWitUnits().toString()} ${WIT_UNIT[WitUnit.Wit]}',
                  style: textStyle,
                ),
              ]),
              SizedBox(height: 16),
              Row(children: [
                Text(
                  localization.locked,
                  style: labelTextStyle,
                ),
                Spacer(),
                Text(
                  '${balance.lockedNanoWit.standardizeWitUnits().toString()} ${WIT_UNIT[WitUnit.Wit]}',
                  style: textStyle,
                ),
              ]),
              SizedBox(height: 16),
              Row(children: [
                Text(
                  localization.staked,
                  style: labelTextStyle,
                ),
                Spacer(),
                Text(
                  '${stakedBalance.stakedNanoWit.standardizeWitUnits().toString()} ${WIT_UNIT[WitUnit.Wit]}',
                  style: textStyle,
                ),
              ])
            ]));
  }
}