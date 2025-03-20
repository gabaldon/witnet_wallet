import 'package:my_wit_wallet/util/extensions/num_extensions.dart';
import 'package:witnet/explorer.dart';
import 'package:witnet/schema.dart';
import 'package:my_wit_wallet/widgets/layouts/send_transaction_layout.dart'
    as layout;

class BuildTransaction {
  final VTTransaction? vtTransaction;
  final StakeTransaction? stakeTransaction;
  final UnstakeTransaction? unstakeTransaction;
  BuildTransaction(
      {this.vtTransaction, this.stakeTransaction, this.unstakeTransaction});

  dynamic get(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this.vtTransaction;
      case layout.TransactionType.Stake:
        return this.stakeTransaction;
      case layout.TransactionType.Unstake:
        return this.unstakeTransaction;
    }
  }

  bool hasOutput(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this.vtTransaction != null &&
            this.vtTransaction!.body.outputs.length > 0;
      case layout.TransactionType.Stake:
        return this.stakeTransaction != null &&
            this.stakeTransaction!.body.output.key.jsonMap()['withdrawer'] !=
                'wit1q08n42';
      case layout.TransactionType.Unstake:
        return this.unstakeTransaction != null &&
            this.unstakeTransaction!.body.withdrawal.pkh.address !=
                'wit1q08n42';
    }
  }

  dynamic getBody(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return TransactionBody(vtTransactionBody: this.vtTransaction?.body);
      case layout.TransactionType.Stake:
        return TransactionBody(
            stakeTransactionBody: this.stakeTransaction?.body);
      case layout.TransactionType.Unstake:
        return TransactionBody(
            unstakeTransactionBody: this.unstakeTransaction?.body);
    }
  }

  dynamic getKey(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return 'vtTransaction';
      case layout.TransactionType.Stake:
        return 'stakeTransaction';
      case layout.TransactionType.Unstake:
        return 'unstakeTransaction';
    }
  }

  int getNanoWitAmount(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this.vtTransaction?.body.outputs.first.value.toInt() ?? 0;
      case layout.TransactionType.Stake:
        return this.stakeTransaction?.body.output.value.toInt() ?? 0;
      case layout.TransactionType.Unstake:
        return this.unstakeTransaction?.body.withdrawal.value.toInt() ?? 0;
    }
  }

  String? getAuthorization(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return null;
      case layout.TransactionType.Stake:
        return this.stakeTransaction?.body.output.authorization.toString();
      case layout.TransactionType.Unstake:
        return null;
    }
  }

  String getAmount(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this
                .vtTransaction
                ?.body
                .outputs
                .first
                .value
                .toInt()
                .standardizeWitUnits(truncate: -1)
                .formatWithCommaSeparator() ??
            '';
      case layout.TransactionType.Stake:
        return this
                .stakeTransaction
                ?.body
                .output
                .value
                .toInt()
                .standardizeWitUnits(truncate: -1)
                .formatWithCommaSeparator() ??
            '';
      case layout.TransactionType.Unstake:
        return this
                .unstakeTransaction
                ?.body
                .withdrawal
                .value
                .toInt()
                .standardizeWitUnits(truncate: -1)
                .formatWithCommaSeparator() ??
            '';
    }
  }

  dynamic getRecipient(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this.vtTransaction?.body.outputs[0].pkh.address;
      case layout.TransactionType.Stake:
        return this.stakeTransaction?.body.output.key.withdrawer.address;
      case layout.TransactionType.Unstake:
        return this.unstakeTransaction?.body.withdrawal.pkh.address;
    }
  }

  dynamic getWeight(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this.vtTransaction?.weight ?? '';
      case layout.TransactionType.Stake:
        return this.stakeTransaction?.weight ?? '';
      case layout.TransactionType.Unstake:
        return this.unstakeTransaction?.weight ?? '';
    }
  }

  bool hasTimelock(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this.vtTransaction?.body.outputs[0].timeLock != 0;
      case layout.TransactionType.Stake:
        return false;
      case layout.TransactionType.Unstake:
        return false;
    }
  }

  String getTransactionID(layout.TransactionType txType) {
    switch (txType) {
      case layout.TransactionType.Vtt:
        return this.vtTransaction?.transactionID ?? '';
      case layout.TransactionType.Stake:
        return this.stakeTransaction?.transactionID ?? '';
      case layout.TransactionType.Unstake:
        return this.unstakeTransaction?.transactionID ?? '';
    }
  }
}

class TransactionBody {
  final VTTransactionBody? vtTransactionBody;
  final StakeBody? stakeTransactionBody;
  final UnstakeBody? unstakeTransactionBody;
  TransactionBody(
      {this.vtTransactionBody,
      this.stakeTransactionBody,
      this.unstakeTransactionBody});
}

class StakeData {
  final List<StakeInput> inputs;
  final int timestamp;
  final int value;
  final String validator;
  final String withdrawer;
  final ValueTransferOutput? change;
  StakeData({
    required this.inputs,
    required this.timestamp,
    required this.value,
    required this.validator,
    required this.withdrawer,
    this.change,
  });
}

class UnstakeData {
  final int timestamp;
  final int value;
  final String validator;
  final String withdrawer;
  final int nonce;

  UnstakeData({
    required this.timestamp,
    required this.value,
    required this.validator,
    required this.withdrawer,
    required this.nonce,
  });
}

class MintData {
  final List<ValueTransferOutput> outputs;
  final int timestamp;
  final int reward;
  final int valueTransferCount;
  final int dataRequestCount;
  final int commitCount;
  final int revealCount;
  final int tallyCount;

  MintData({
    required this.outputs,
    required this.timestamp,
    required this.reward,
    required this.valueTransferCount,
    required this.dataRequestCount,
    required this.commitCount,
    required this.revealCount,
    required this.tallyCount,
  });
}

class VttData {
  final List<InputUtxo> inputs;
  final List<String> inputAddresses;
  final List<ValueTransferOutput> outputs;
  final List<String> outputAddresses;
  final int weight;
  final int priority;
  final bool confirmed;
  final bool reverted;

  VttData(
      {required this.inputs,
      required this.inputAddresses,
      required this.outputs,
      required this.outputAddresses,
      required this.weight,
      required this.confirmed,
      required this.reverted,
      required this.priority});
}

class GeneralTransaction extends HashInfo {
  MintData? mint;
  VttData? vtt;
  StakeData? stake;
  UnstakeData? unstake;
  final int fee;
  final int? epoch;

  GeneralTransaction(
      {required blockHash,
      required this.epoch,
      required this.fee,
      required hash,
      required status,
      required time,
      required type,
      this.stake,
      this.unstake,
      this.mint,
      this.vtt})
      : super(
            txnHash: hash,
            status: status,
            type: type,
            txnTime: time,
            blockHash: blockHash);
  factory GeneralTransaction.fromStakeEntry(StakeEntry stakeEntry) =>
      GeneralTransaction(
          blockHash: stakeEntry.blockHash,
          epoch: stakeEntry.epoch,
          fee: stakeEntry.fees,
          hash: stakeEntry.blockHash,
          status: stakeEntry.status,
          time: stakeEntry.timestamp,
          type: stakeEntry.type,
          mint: null,
          stake: StakeData(
            inputs: stakeEntry.inputs,
            timestamp: stakeEntry.timestamp,
            value: stakeEntry.value,
            validator: stakeEntry.validator,
            withdrawer: stakeEntry.withdrawer,
            change: stakeEntry.change,
          ));
  factory GeneralTransaction.fromUnstakeEntry(UnstakeEntry unstakeEntry) =>
      GeneralTransaction(
          blockHash: unstakeEntry.blockHash,
          epoch: unstakeEntry.epoch,
          fee: unstakeEntry.fees,
          hash: unstakeEntry.blockHash,
          status: unstakeEntry.status,
          time: unstakeEntry.timestamp,
          type: unstakeEntry.type,
          unstake: UnstakeData(
              timestamp: unstakeEntry.timestamp,
              value: unstakeEntry.value,
              validator: unstakeEntry.validator,
              withdrawer: unstakeEntry.withdrawer,
              nonce: unstakeEntry.nonce));
  factory GeneralTransaction.fromMintEntry(MintEntry mintEntry) =>
      GeneralTransaction(
          blockHash: mintEntry.blockHash,
          epoch: mintEntry.epoch,
          fee: mintEntry.fees,
          hash: mintEntry.blockHash,
          status: mintEntry.status,
          time: mintEntry.timestamp,
          type: mintEntry.type,
          mint: MintData(
              commitCount: mintEntry.commitCount,
              outputs: mintEntry.outputs,
              timestamp: mintEntry.timestamp,
              reward: mintEntry.reward,
              valueTransferCount: mintEntry.valueTransferCount,
              dataRequestCount: mintEntry.dataRequestCount,
              revealCount: mintEntry.revealCount,
              tallyCount: mintEntry.tallyCount));
  factory GeneralTransaction.fromValueTransferInfo(
          ValueTransferInfo valueTransferInfo) =>
      GeneralTransaction(
          blockHash: valueTransferInfo.blockHash,
          epoch: valueTransferInfo.epoch,
          fee: valueTransferInfo.fee,
          hash: valueTransferInfo.hash,
          status: valueTransferInfo.status,
          time: valueTransferInfo.timestamp,
          type: valueTransferInfo.type,
          vtt: VttData(
              inputs: valueTransferInfo.inputUtxos,
              inputAddresses: valueTransferInfo.inputAddresses,
              confirmed: valueTransferInfo.confirmed,
              reverted: valueTransferInfo.reverted,
              outputs: valueTransferInfo.outputs,
              outputAddresses: valueTransferInfo.outputAddresses,
              weight: valueTransferInfo.weight,
              priority: valueTransferInfo.priority));

  ValueTransferInfo toValueTransferInfo() => ValueTransferInfo(
        block: blockHash ??
            '0000000000000000000000000000000000000000000000000000000000000000',
        fee: fee,
        inputUtxos: vtt?.inputs ?? [],
        outputs: vtt?.outputs ?? [],
        priority: vtt?.priority ?? 0,
        status: status,
        epoch: epoch ?? 0,
        hash: txnHash,
        timestamp: txnTime,
        weight: vtt?.weight ?? 0,
        confirmed: vtt?.confirmed ?? false,
        reverted: vtt?.reverted ?? false,
        inputAddresses: vtt?.inputAddresses ?? [],
        outputAddresses: vtt?.outputAddresses ?? [],
        value: 0,
        inputsMerged: [],
        outputValues: [],
        timelocks: List.generate(vtt!.outputs.length,
            (index) => vtt!.outputs[index].timeLock.toInt()),
        utxos: [],
        utxosMerged: [],
        trueOutputAddresses: [],
        changeOutputAddresses: [],
        trueValue: 0,
        changeValue: 0,
      );
}

class UnstakeEntry {
  UnstakeEntry({
    required this.hash,
    required this.blockHash,
    required this.fees,
    required this.epoch,
    // specific to mint entry
    required this.timestamp,
    required this.value,
    required this.status,
    required this.type,
    required this.confirmed,
    required this.reverted,
    required this.validator,
    required this.withdrawer,
    required this.nonce,
  });
  final String hash;
  final String blockHash;
  final int timestamp;
  final int? epoch;
  final int fees;
  final TxStatusLabel status;
  final TransactionType type;
  final bool confirmed;
  final bool reverted;
  final int value;
  final String validator;
  final String withdrawer;
  final int nonce;

  bool containsAddress(String address) {
    return address == withdrawer || address == validator;
  }

  bool get unlocked =>
      DateTime.fromMillisecondsSinceEpoch(timestamp)
          .add(Duration(days: 14))
          .millisecondsSinceEpoch <
      DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> jsonMap() => {
        "hash": hash,
        "block_hash": blockHash,
        "timestamp": timestamp,
        "epoch": epoch,
        "value": value,
        "fees": fees,
        'confirmed': confirmed,
        'reverted': reverted,
        "status": status.toString(),
        "type": type.toString(),
      };

  factory UnstakeEntry.fromJson(Map<String, dynamic> data) {
    return UnstakeEntry(
      hash: data["hash"],
      blockHash: data["block_hash"],
      timestamp: data["timestamp"],
      epoch: data["epoch"],
      value: data["value"],
      fees: data["fees"],
      confirmed: data['confirmed'] ?? false,
      reverted: data['reverted'] ?? false,
      status: TransactionStatus.fromJson(data).status,
      type: TransactionType.unstake,
      validator: data['validator'],
      withdrawer: data['withdrawer'],
      nonce: data['nonce'],
    );
  }

  factory UnstakeEntry.fromUnstakeInfo(UnstakeInfo unstakeInfo) => UnstakeEntry(
      hash: unstakeInfo.hash,
      blockHash: unstakeInfo.blockHash,
      timestamp: unstakeInfo.timestamp,
      epoch: unstakeInfo.epoch,
      value: unstakeInfo.unstakeValue,
      fees: unstakeInfo.fee,
      status: TransactionStatus.fromJson({
        'confirmed': unstakeInfo.confirmed,
        'reverted': unstakeInfo.reverted
      }).status,
      type: TransactionType.unstake,
      confirmed: unstakeInfo.confirmed,
      reverted: unstakeInfo.reverted,
      validator: unstakeInfo.validator,
      withdrawer: unstakeInfo.withdrawer,
      nonce: unstakeInfo.nonce);
}

class StakeEntry {
  StakeEntry({
    required this.hash,
    required this.blockHash,
    required this.fees,
    required this.epoch,
    // specific to mint entry
    required this.inputs,
    required this.timestamp,
    required this.status,
    required this.type,
    required this.confirmed,
    required this.reverted,
    required this.validator,
    required this.withdrawer,
    required this.value,
    this.change,
  });
  final String hash;
  final String blockHash;
  final List<StakeInput> inputs;
  final int timestamp;
  final int epoch;
  final int fees;
  final TxStatusLabel status;
  final TransactionType type;
  final bool confirmed;
  final bool reverted;
  final int value;
  final String validator;
  final String withdrawer;
  final ValueTransferOutput? change;

  bool containsAddress(String address) {
    bool response = false;
    inputs.forEach((element) {
      if (element.address == address) response = true;
    });
    return response;
  }

  Map<String, dynamic> jsonMap() => {
        "hash": hash,
        "block_hash": blockHash,
        "inputs":
            List<Map<String, dynamic>>.from(inputs.map((x) => x.jsonMap())),
        "timestamp": timestamp,
        "epoch": epoch,
        "fees": fees,
        "status": status.toString(),
        "type": type.toString(),
        'confirmed': confirmed,
        'reverted': reverted,
        "value": value,
        "validator": validator,
        "withdrawer": withdrawer,
        "change": change != null ? change!.jsonMap(asHex: true) : null
      };

  factory StakeEntry.fromJson(Map<String, dynamic> data) {
    return StakeEntry(
      hash: data["hash"],
      blockHash: data["block_hash"],
      inputs: List<StakeInput>.from(
          data["inputs"].map((x) => StakeInput.fromJson(x))),
      timestamp: data["timestamp"],
      epoch: data["epoch"],
      fees: data["fees"],
      confirmed: data['confirmed'] ?? false,
      reverted: data['reverted'] ?? false,
      status: TransactionStatus.fromJson(data).status,
      type: TransactionType.stake,
      validator: data['validator'],
      withdrawer: data['withdrawer'],
      value: data['value'],
      change: data['change'] != null
          ? ValueTransferOutput.fromJson(data['change'])
          : null,
    );
  }

  factory StakeEntry.fromStakeInfo(StakeInfo stakeInfo) => StakeEntry(
        hash: stakeInfo.hash,
        blockHash: stakeInfo.block,
        inputs: stakeInfo.inputs,
        timestamp: stakeInfo.timestamp,
        epoch: stakeInfo.epoch,
        fees: stakeInfo.fee,
        status: TransactionStatus.fromJson({
          'confirmed': stakeInfo.confirmed,
          'reverted': stakeInfo.reverted
        }).status,
        type: TransactionType.stake,
        confirmed: stakeInfo.confirmed,
        reverted: stakeInfo.reverted,
        validator: stakeInfo.validator,
        withdrawer: stakeInfo.withdrawer,
        value: stakeInfo.stakeValue,
      );
}

class MintEntry {
  MintEntry({
    required this.blockHash,
    required this.fees,
    required this.epoch,
    // specific to mint entry
    required this.outputs,
    required this.timestamp,
    required this.reward,
    required this.valueTransferCount,
    required this.dataRequestCount,
    required this.commitCount,
    required this.revealCount,
    required this.tallyCount,
    required this.status,
    required this.type,
    required this.confirmed,
    required this.reverted,
  });
  final String blockHash;
  final List<ValueTransferOutput> outputs;
  final int timestamp;
  final int epoch;
  final int reward;
  final int fees;
  final int valueTransferCount;
  final int dataRequestCount;
  final int commitCount;
  final int revealCount;
  final int tallyCount;
  final TxStatusLabel status;
  final TransactionType type;
  final bool confirmed;
  final bool reverted;

  bool containsAddress(String address) {
    bool response = false;
    outputs.forEach((element) {
      if (element.pkh.address == address) response = true;
    });
    return response;
  }

  Map<String, dynamic> jsonMap() => {
        "block_hash": blockHash,
        "outputs": List<Map<String, dynamic>>.from(
            outputs.map((x) => x.jsonMap(asHex: true))),
        "timestamp": timestamp,
        "epoch": epoch,
        "reward": reward,
        "fees": fees,
        "vtt_count": valueTransferCount,
        "drt_count": dataRequestCount,
        "commit_count": commitCount,
        "reveal_count": revealCount,
        "tally_count": tallyCount,
        'confirmed': confirmed,
        'reverted': reverted,
        "status": status.toString(),
        "type": type.toString(),
      };

  factory MintEntry.fromJson(Map<String, dynamic> json) {
    return MintEntry(
      blockHash: json["block_hash"],
      outputs: List<ValueTransferOutput>.from(
          json["outputs"].map((x) => ValueTransferOutput.fromJson(x))),
      timestamp: json["timestamp"],
      epoch: json["epoch"],
      reward: json["reward"],
      fees: json["fees"],
      valueTransferCount: json["vtt_count"],
      dataRequestCount: json["drt_count"],
      commitCount: json["commit_count"],
      revealCount: json["reveal_count"],
      tallyCount: json["tally_count"],
      confirmed: json['confirmed'] ?? false,
      reverted: json['reverted'] ?? false,
      status: TransactionStatus.fromJson(json).status,
      type: TransactionType.mint,
    );
  }

  factory MintEntry.fromBlockMintInfo(
          BlockInfo blockInfo, BlockDetails blockDetails) =>
      MintEntry(
        blockHash: blockDetails.mintInfo.blockHash,
        outputs: blockDetails.mintInfo.outputs,
        timestamp: blockInfo.timestamp,
        epoch: blockInfo.epoch,
        reward: blockInfo.reward,
        fees: blockInfo.fees,
        valueTransferCount: blockInfo.valueTransferCount,
        dataRequestCount: blockInfo.dataRequestCount,
        commitCount: blockInfo.commitCount,
        revealCount: blockInfo.revealCount,
        tallyCount: blockInfo.tallyCount,
        status: TransactionStatus.fromJson({
          'confirmed': blockDetails.confirmed,
          'reverted': blockDetails.reverted
        }).status,
        type: TransactionType.mint,
        confirmed: blockDetails.confirmed,
        reverted: blockDetails.reverted,
      );
}

extension InputUtxoAdapter on InputUtxo {
  static InputUtxo fromDBJson(Map<String, dynamic> json) => InputUtxo(
      address: json["pkh"],
      inputUtxo: json["output_pointer"],
      value: json["value"]);

  static InputUtxo fromJson(Map<String, dynamic> json) {
    bool dbJson = json["pkh"] != null;
    if (dbJson) {
      return fromDBJson(json);
    } else {
      return InputUtxo.fromJson(json);
    }
  }
}

// TODO: it is not used, delete if not necessary
extension AddressBlocksAdapter on AddressBlocks {
  static AddressBlocks fromDBJson(List<dynamic> data) {
    return AddressBlocks(
      address: data[0]['address'],
      blocks: List<BlockInfo>.from(
          data.map((blockInfo) => BlockInfo.fromJson(blockInfo))),
    );
  }

  static AddressBlocks fromJson(List<dynamic> data) {
    bool dbJson = data[0]['miner'] == null;
    if (dbJson) {
      return fromDBJson(data);
    } else {
      return AddressBlocks.fromJson(data);
    }
  }
}

extension ValueTransferAdapter on ValueTransferInfo {
  static ValueTransferInfo fromJson(Map<String, dynamic> data) {
    bool dbJson = data["epoch"] == null;
    if (dbJson) {
      return fromDBJson(data);
    } else {
      return ValueTransferInfo.fromJson(data);
    }
  }

  static ValueTransferInfo fromDBJson(Map<String, dynamic> data) {
    List<String> outputAddresses = getOrDefault(data).outputAddresses;
    List<int> outputValues = getOrDefault(data).outputValues;
    List<ValueTransferOutput> outputs = [];
    if (data['outputs'] != null) {
      data['outputs'].forEach((element) {
        Address address = Address.fromAddress(element['pkh']);

        outputs.add(ValueTransferOutput(
            pkh: address.publicKeyHash!,
            timeLock: element['time_lock'],
            value: element['value']));
      });
    } else {
      for (int i = 0; i < outputValues.length; i++) {
        ValueTransferOutput vto = ValueTransferOutput(
          value: outputValues[i],
          pkh: Address.fromAddress(outputAddresses[i]).publicKeyHash!,
          timeLock: getOrDefault(data).timelocks[i],
        );
        outputs.add(vto);
      }
    }
    return ValueTransferInfo(
        epoch: data["txn_epoch"],
        timestamp: data["txn_time"],
        hash: data["txn_hash"],
        block: data["block_hash"],
        inputUtxos: List<InputUtxo>.from(
            data["inputs"].map((x) => InputUtxoAdapter.fromJson(x))),
        fee: data["fee"],
        priority: data["priority"],
        weight: data["weight"],
        status: TransactionStatus.fromJson(data).status,
        outputs: outputs,
        value: getOrDefault(data).value,
        confirmed: getOrDefault(data).confirmed,
        reverted: getOrDefault(data).reverted,
        inputAddresses: getOrDefault(data).inputAddresses,
        inputsMerged: getOrDefault(data).inputsMerged,
        outputAddresses: getOrDefault(data).outputAddresses,
        outputValues: getOrDefault(data).outputValues,
        timelocks: getOrDefault(data).timelocks,
        utxos: getOrDefault(data).utxos,
        utxosMerged: getOrDefault(data).utxosMerged,
        trueOutputAddresses: getOrDefault(data).trueOutputAddresses,
        changeOutputAddresses: getOrDefault(data).outputAddresses,
        trueValue: getOrDefault(data).trueValue,
        changeValue: getOrDefault(data).changeValue);
  }
}

class NullableFields {
  final int? value;
  final bool confirmed;
  final bool reverted;
  final List<String> inputAddresses;
  final List<InputMerged> inputsMerged;
  final List<String> outputAddresses;
  final List<int> outputValues;
  final List<int> timelocks;
  final List<TransactionUtxo> utxos;
  final List<TransactionUtxo> utxosMerged;
  final List<String> trueOutputAddresses;
  final List<String> changeOutputAddresses;
  final int? trueValue;
  final int? changeValue;
  NullableFields(
      {required this.changeOutputAddresses,
      required this.changeValue,
      required this.confirmed,
      required this.inputAddresses,
      required this.inputsMerged,
      required this.outputAddresses,
      required this.outputValues,
      required this.reverted,
      required this.timelocks,
      required this.trueOutputAddresses,
      required this.trueValue,
      required this.utxos,
      required this.utxosMerged,
      required this.value});
}

NullableFields getOrDefault(Map<String, dynamic> data) {
  return NullableFields(
    value: data["value"] ?? null,
    confirmed: data["confirmed"] ??
        TransactionStatus.fromJson(data).status == TxStatusLabel.confirmed,
    reverted: data["reverted"] ??
        TransactionStatus.fromJson(data).status == TxStatusLabel.reverted,
    inputAddresses: data["input_addresses"] != null
        ? List<String>.from(data["input_addresses"])
        : List<String>.from(data["inputs"].map((input) {
            return input['pkh'];
          }).toList()),
    inputsMerged: data["inputs_merged"] != null
        ? List<InputMerged>.from(
            data["inputs_merged"].map((x) => InputMerged.fromJson(x)))
        : [],
    outputAddresses: data["output_addresses"] != null
        ? List<String>.from(data["output_addresses"])
        : List<String>.from(
            data["outputs"].map((output) => output['pkh']).toList()),
    outputValues: data["output_values"] != null
        ? List<int>.from(data["output_values"])
        : List<int>.from(
            data["outputs"].map((output) => output['value']).toList()),
    timelocks: data["timelocks"] != null
        ? List<int>.from(data["timelocks"])
        : List<int>.from(
            data["outputs"].map((output) => output['time_lock']).toList()),
    utxos: data["utxos"] != null
        ? List<TransactionUtxo>.from(data["utxos"]
            .map((e) => TransactionUtxo.fromJson(Map<String, dynamic>.from(e))))
        : [],
    utxosMerged: data["utxos_merged"] != null
        ? List<TransactionUtxo>.from(data["utxos_merged"]
            .map((e) => TransactionUtxo.fromJson(Map<String, dynamic>.from(e))))
        : [],
    trueOutputAddresses: data["true_output_addresses"] != null
        ? List<String>.from(data["true_output_addresses"])
        : [],
    changeOutputAddresses: data["change_output_addresses"] != null
        ? List<String>.from(data["change_output_addresses"])
        : [],
    trueValue: data["true_value"],
    changeValue: data["change_value"],
  );
}
