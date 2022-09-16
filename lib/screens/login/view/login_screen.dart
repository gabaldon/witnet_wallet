import 'package:flutter/material.dart';
import 'package:witnet_wallet/screens/login/create_or_recover_card.dart';
import 'package:witnet_wallet/screens/login/view/login_card.dart';
import 'package:witnet_wallet/theme/wallet_theme.dart';

class LoginScreen extends StatefulWidget {
  static final route = '/login';

  LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  var size;
  dynamic currentCard;

  @override
  void initState() {
    super.initState();
    currentCard = LoginCard(onCreateOrRecover: switchToCreateOrRecoverCard);
  }

  void switchToCreateOrRecoverCard() {
    setState(() {
      currentCard = CreateOrRecoverCard(onBack: switchToLoginCard);
    });
  }

  void switchToLoginCard() {
    setState(() {
      currentCard = LoginCard(onCreateOrRecover: switchToCreateOrRecoverCard);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: new GestureDetector(
        onTap: () {
/*This method here will hide the soft keyboard.*/
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.primaryColor.withOpacity(.01),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: size.height * 0.25,
                    width: size.width,
                    child: witnetLogo(theme),
                  ),
                  FittedBox(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 230),
                        reverseDuration: const Duration(microseconds: 1100),
                        child: currentCard,
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
