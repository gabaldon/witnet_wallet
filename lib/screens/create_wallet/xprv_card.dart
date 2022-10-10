import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:witnet/witnet.dart';
import 'package:witnet_wallet/screens/create_wallet/bloc/api_create_wallet.dart';
import 'package:witnet_wallet/screens/create_wallet/bloc/create_wallet_bloc.dart';
import 'package:witnet_wallet/shared/locator.dart';

typedef void VoidCallback(Action? value);

class Action {
  String label;
  void action;

  Action({
    required this.label,
    required this.action,
  });
}

class EnterXprvCard extends StatefulWidget {
  final Function nextAction;
  final Function prevAction;
  EnterXprvCard({
    Key? key,
    required VoidCallback this.nextAction,
    required VoidCallback this.prevAction,
  }) : super(key: key);

  EnterXprvCardState createState() => EnterXprvCardState();
}

class EnterXprvCardState extends State<EnterXprvCard>
    with TickerProviderStateMixin {
  String xprv = '';
  final TextEditingController textController = TextEditingController();
  int numLines = 0;
  bool _xprvVerified = false;
  bool xprvVerified() => _xprvVerified;
  Widget _buildConfirmField() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: textController,
                onChanged: (String e) {
                  setState(() {
                    xprv = textController.value.text;
                    numLines = '\n'.allMatches(e).length + 1;
                  });
                },
                decoration: new InputDecoration(
                  labelText: 'XPRV',
                )),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void prevAction() {
    CreateWalletState state = BlocProvider.of<CreateWalletBloc>(context).state;
    BlocProvider.of<CreateWalletBloc>(context)
        .add(SetWalletStateEvent(WalletType.xprv, state));
    WalletType type =
        BlocProvider.of<CreateWalletBloc>(context).state.walletType;
    BlocProvider.of<CreateWalletBloc>(context).add(PreviousCardEvent(type));
  }

  void nextAction() {
    Locator.instance<ApiCreateWallet>().setSeed(xprv, 'xprv');
    WalletType type =
        BlocProvider.of<CreateWalletBloc>(context).state.walletType;
    BlocProvider.of<CreateWalletBloc>(context)
        .add(NextCardEvent(type, data: {}));
  }

  Action prev() {
    return Action(
      label: 'Back',
      action: prevAction,
    );
  }

  Action next() {
    return Action(
      label: 'Continue',
      action: nextAction,
    );
  }

  bool validXprv(String xprvString) {
    try {
      Xprv _xprv = Xprv.fromXprv(xprvString);
      assert(_xprv.address.address.isNotEmpty);
    } catch (e) {
      return false;
    }
    return true;
  }

  Widget buildErrorList(List<dynamic> errors) {
    List<Widget> _children = [];
    errors.forEach((element) {
      _children.add(Text(
        element.toString(),
        style: TextStyle(color: Colors.red),
      ));
    });
    return Column(children: _children);
  }

  Widget _verifyButton() {
    return ElevatedButton(
      onPressed: () {
        WalletType type =
            BlocProvider.of<CreateWalletBloc>(context).state.walletType;
        BlocProvider.of<CreateWalletBloc>(context)
            .add(VerifyXprvEvent(type, xprv: xprv));
        try {
          setState(() {
            _xprvVerified = validXprv(xprv);
          });
        } catch (e) {}
      },
      child: Text('Verify'),
    );
  }

  Widget verifyXprvButton() {
    return BlocBuilder<CreateWalletBloc, CreateWalletState>(
        builder: (context, state) {
      final theme = Theme.of(context);
      if (state.status == CreateWalletStatus.EnterXprv) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _verifyButton(),
          ],
        );
      } else if (state.status == CreateWalletStatus.Loading) {
        return SpinKitCircle(
          color: theme.primaryColor,
        );
      } else if (state.status == CreateWalletStatus.ValidXprv) {
        return Container(
          child: Column(
            children: [
              Text('Verify the imported addresses match your records.'),
              Text('Master Node address: ${state.nodeAddress}'),
              Text('First Wallet address: ${state.walletAddress}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _verifyButton(),
                ],
              )
            ],
          ),
        );
      } else if (state.status == CreateWalletStatus.LoadingException) {
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildErrorList([state.message]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _verifyButton(),
                ],
              )
            ],
          ),
        );
      } else {
        return SpinKitCircle(
          color: theme.primaryColor,
        );
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.prevAction(prev));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.nextAction(next));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildConfirmField(),
        verifyXprvButton(),
      ]
    );
  }
}
