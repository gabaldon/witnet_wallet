import 'dart:isolate';

import 'package:witnet/constants.dart';
import 'package:witnet/witnet.dart';
import 'package:witnet_wallet/bloc/crypto/crypto_bloc.dart';
import 'package:witnet_wallet/shared/locator.dart';

enum KeyType { internal, external }

class Wallet {
  final String name;
  final String? description;

  late Xprv masterXprv;
  late Xprv walletXprv;
  late Xprv internalXprv;
  late Xprv externalXprv;
  late Xpub internalXpub;
  late Xpub externalXpub;
  final Map<int, Xpub> externalKeys = {};
  final Map<int, Xpub> internalKeys = {};

  Wallet(this.name, this.description);

  static Future<Wallet> fromMnemonic(
      {required String name,
      required String description,
      required String mnemonic}) async {
    final _wallet = Wallet(name, description);
    _wallet._setMasterXprv(Xprv.fromMnemonic(mnemonic: mnemonic));
    return _wallet;
  }

  static Future<Wallet> fromXprvStr(
      {required String name,
      required String description,
      required String xprv}) async {
    final _wallet = Wallet(name, description);
    _wallet._setMasterXprv(Xprv.fromXprv(xprv));
    return _wallet;
  }

  static Future<Wallet> fromEncryptedXprv(
      {required String name,
      required String description,
      required String xprv,
      required String password}) async {
    try {
      final _wallet = Wallet(name, description);
      _wallet._setMasterXprv(Xprv.fromEncryptedXprv(xprv, password));
      return _wallet;
    } catch (e) {
      rethrow;
    }
  }

  void _setMasterXprv(Xprv xprv) {
    masterXprv = xprv;
    walletXprv = xprv / KEYPATH_PURPOSE / KEYPATH_COIN_TYPE / KEYPATH_ACCOUNT;
    externalXprv = walletXprv / 0;
    internalXprv = walletXprv / 1;
    internalXpub = internalXprv.toXpub();
    externalXpub = externalXprv.toXpub();
  }

  Future<Xpub> generateKey(
      {required int index, KeyType keyType = KeyType.external}) async {
    ReceivePort response = ReceivePort();
    // initialize the crypto isolate if not already done so

    await Locator.instance<CryptoIsolate>().init();
    // send the request

    Locator.instance<CryptoIsolate>().send(
        method: 'generateKey',
        params: {
          'external_keychain': externalXpub.toSlip32(),
          'internal_keychain': internalXpub.toSlip32(),
          'index': index,
          'keyType': keyType.toString()
        },
        port: response.sendPort);
    var resp = await response.first.then((value) {
      return value['xpub'] as Xpub;
    });
    switch (keyType) {
      case KeyType.external:
        externalKeys[index] = resp;
        break;
      case KeyType.internal:
        internalKeys[index] = resp;
        break;
    }
    return resp;
  }

  Future<Xpub> getXpub({required int index, required KeyType keyType}) async {
    switch (keyType) {
      case KeyType.internal:
        if (!internalKeys.containsKey(index)) {
          await generateKey(index: index, keyType: keyType);
        }
        return internalKeys[index]!;
      case KeyType.external:
        if (!externalKeys.containsKey(index)) {
          await generateKey(index: index, keyType: keyType);
        }
        return externalKeys[index]!;
    }
  }
}
