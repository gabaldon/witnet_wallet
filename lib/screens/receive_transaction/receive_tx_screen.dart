import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wit_wallet/shared/api_database.dart';
import 'package:my_wit_wallet/theme/colors.dart';
import 'package:my_wit_wallet/widgets/PaddedButton.dart';
import 'package:my_wit_wallet/widgets/address_list.dart';
import 'package:my_wit_wallet/widgets/dashed_rect.dart';
import 'package:my_wit_wallet/widgets/qr/qr_address_generator.dart';
import 'package:my_wit_wallet/util/storage/database/wallet.dart';
import 'package:my_wit_wallet/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_wit_wallet/widgets/layouts/dashboard_layout.dart';

import '../../shared/locator.dart';
import '../../util/storage/database/account.dart';

class ReceiveTransactionScreen extends StatefulWidget {
  static final route = '/receive-transaction';
  @override
  ReceiveTransactionScreenState createState() =>
      ReceiveTransactionScreenState();
}

class ReceiveTransactionScreenState extends State<ReceiveTransactionScreen>
    with TickerProviderStateMixin {
  Account? selectedAccount;
  late AnimationController _loadingController;
  bool isLoading = false;
  String copyText = 'Copy selected address';
  bool enableButton = true;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _loadingController.forward();
    ApiDatabase db = Locator.instance.get<ApiDatabase>();
    _setCurrentWallet(
        db.walletStorage.currentWallet, db.walletStorage.currentAccount);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  List<Widget> _actions() {
    return [
      PaddedButton(
          padding: EdgeInsets.zero,
          text: copyText,
          type: 'primary',
          enabled: enableButton,
          isLoading: isLoading,
          onPressed: () async {
            await Clipboard.setData(
                ClipboardData(text: selectedAccount?.address ?? ''));
            if (await Clipboard.hasStrings()) {
              setState(() {
                isLoading = true;
              });
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  isLoading = false;
                });
              });
            }
          }),
      // TODO: Implement generate new address
      // PaddedButton(
      //     padding: EdgeInsets.only(bottom: 8),
      //     text: 'Generate new',
      //     type: 'secondary',
      //     enabled: true,
      //     onPressed: () => {
      //           // generate new address change address index
      //         }),
    ];
  }

  _setCurrentWallet(Wallet? currentWallet, Account currentAccount) {
    setState(() {
      selectedAccount = currentAccount;
    });
  }

  Widget _buildReceiveTransactionScreen() {
    final theme = Theme.of(context);
    ApiDatabase db = Locator.instance.get<ApiDatabase>();

    return Column(
      children: [
        QrAddressGenerator(
          data: selectedAccount!.address,
        ),
        SizedBox(height: 24),
        DashedRect(
          color: WitnetPallet.witnetGreen1,
          strokeWidth: 1.0,
          gap: 3.0,
          text: selectedAccount!.address,
        ),
        SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generated addresses',
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(height: 16),
        AddressList(
          currentWallet: db.walletStorage.currentWallet,
        ),
      ],
    );
  }

  BlocListener _dashboardBlocListener() {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (BuildContext context, DashboardState state) {
        ApiDatabase database = Locator.instance.get<ApiDatabase>();
        setState(() {
          selectedAccount = database.walletStorage.currentAccount;
        });
      },
      child: _dashboardBlocBuilder(),
    );
  }

  BlocBuilder _dashboardBlocBuilder() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (BuildContext context, DashboardState state) {
        return DashboardLayout(
          dashboardChild: _buildReceiveTransactionScreen(),
          actions: _actions(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: _dashboardBlocListener(),
    );
  }
}
