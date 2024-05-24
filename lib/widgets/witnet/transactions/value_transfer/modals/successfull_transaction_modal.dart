import 'package:flutter/material.dart';
import 'package:my_wit_wallet/util/get_localization.dart';
import 'package:my_wit_wallet/bloc/transactions/value_transfer/vtt_create/vtt_create_bloc.dart';
import 'package:my_wit_wallet/screens/dashboard/view/dashboard_screen.dart';
import 'package:my_wit_wallet/theme/wallet_theme.dart';
import 'package:my_wit_wallet/widgets/PaddedButton.dart';
import 'package:my_wit_wallet/widgets/alert_dialog.dart';
import 'package:my_wit_wallet/widgets/info_element.dart';
import 'package:my_wit_wallet/widgets/layouts/dashboard_layout.dart';
import 'package:my_wit_wallet/widgets/layouts/send_transaction_layout.dart';

String getTitleByTxType(TransactionType transactionType) {
  switch (transactionType) {
    case TransactionType.Vtt:
      return localization.txnSuccess;
    case TransactionType.Stake:
      return localization.stakeTxnSuccess;
    case TransactionType.Unstake:
      return localization.unstakeTxnSuccess;
  }
}

void buildSuccessfullTransaction(
    {required ThemeData theme,
    required VTTCreateState state,
    required BuildContext context,
    required String routeName,
    required String amountValue,
    required TransactionType transactionType}) {
  return buildAlertDialog(
    context: context,
    actions: [
      PaddedButton(
          padding: EdgeInsets.zero,
          text: localization.close,
          type: ButtonType.text,
          enabled: true,
          onPressed: () => {
                Navigator.popUntil(context, ModalRoute.withName(routeName)),
                ScaffoldMessenger.of(context).clearSnackBars(),
                Navigator.pushReplacement(
                    context,
                    CustomPageRoute(
                        builder: (BuildContext context) {
                          return DashboardScreen();
                        },
                        maintainState: false,
                        settings: RouteSettings(name: DashboardScreen.route)))
              })
    ],
    title: getTitleByTxType(transactionType),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 16),
      svgThemeImage(theme, name: 'transaction-success', height: 100),
      SizedBox(height: 16),
      InfoElement(
        plainText: true,
        label: localization.txnCheckStatus,
        text: state.vtTransaction.transactionID,
        url:
            'https://witnet.network/search/${state.vtTransaction.transactionID}',
      )
    ]),
  );
}
