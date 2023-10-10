import 'package:flutter/material.dart';
import 'package:my_wit_wallet/screens/preferences/general_config.dart';
import 'package:my_wit_wallet/screens/preferences/wallet_config.dart';
import 'package:my_wit_wallet/widgets/layouts/dashboard_layout.dart';
import 'package:my_wit_wallet/widgets/step_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_wit_wallet/util/localization.dart';

class PreferencePage extends StatefulWidget {
  PreferencePage({Key? key}) : super(key: key);
  static final route = '/configuration';
  @override
  State<StatefulWidget> createState() => _PreferencePageState();
}

enum ConfigSteps {
  general,
  wallet,
}

class _PreferencePageState extends State<PreferencePage> {
  final _stepBarKey = new GlobalKey<StepBarState>();
  ScrollController scrollController = ScrollController(keepScrollOffset: false);
  List<String> steps = [];
  StepBar? stepBar;
  AppLocalizations get _localization => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<Enum, String> get _localizedConfigSteps =>
      localizeEnum(context, ConfigSteps.values, _localization.preferenceTabs);

  Widget _configView(BuildContext context, Widget view) {
    if (stepBar == null) {
      stepBar = StepBar(
          key: _stepBarKey,
          actionable: true,
          steps: _localizedConfigSteps.values.toList(),
          initialItem: null,
          onChanged: (item) => {
                scrollController.jumpTo(0.0),
                setState(
                  () => _stepBarKey.currentState!.selectedItem = item!,
                )
              });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [stepBar!, SizedBox(height: 16), view],
    );
  }

  Widget _buildConfigView() {
    if (_stepBarKey.currentState == null) {
      return _configView(context, GeneralConfig());
    } else if (_stepBarKey.currentState?.selectedIndex() ==
        ConfigSteps.general.index) {
      return _configView(context, GeneralConfig());
    } else if (_stepBarKey.currentState?.selectedIndex() ==
        ConfigSteps.wallet.index) {
      return _configView(
          context, WalletConfig(scrollController: scrollController));
    } else {
      return _configView(context, GeneralConfig());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      scrollController: scrollController,
      dashboardChild: _buildConfigView(),
      actions: [],
    );
  }
}
