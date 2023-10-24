import 'package:flutter/material.dart';
import 'package:my_wit_wallet/screens/preferences/general_config.dart';
import 'package:my_wit_wallet/screens/preferences/wallet_config.dart';
import 'package:my_wit_wallet/util/enum_from_string.dart';
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

Map<ConfigSteps, String> preferencesSteps = {
  ConfigSteps.general: 'General',
  ConfigSteps.wallet: 'Wallet'
};

class _PreferencePageState extends State<PreferencePage> {
  ScrollController scrollController = ScrollController(keepScrollOffset: false);
  List<String> steps = [];
  String selectedItem = preferencesSteps[ConfigSteps.general]!;
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
          actionable: true,
          selectedItem: selectedItem,
          steps: _localizedConfigSteps.values.toList(),
          initialItem: null,
          onChanged: (item) => {
                scrollController.jumpTo(0.0),
                print(item),
                setState(
                  () => selectedItem = item!,
                )
              });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [stepBar!, SizedBox(height: 16), view],
    );
  }

  Widget _buildConfigView() {
    if (selectedItem == preferencesSteps[ConfigSteps.general]) {
      return _configView(context, GeneralConfig());
    } else if (selectedItem == preferencesSteps[ConfigSteps.wallet]) {
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
