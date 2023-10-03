import 'package:my_wit_wallet/util/storage/database/transaction_adapter.dart';
import 'package:sembast/sembast.dart';
import 'package:witnet/explorer.dart';
import 'package:witnet/schema.dart';

abstract class _TransactionRepository {
  Future<bool> insertTransaction(
    dynamic transaction,
    DatabaseClient databaseClient,
  );

  Future<bool> updateTransaction(
    dynamic transaction,
    DatabaseClient databaseClient,
  );

  Future<bool> deleteTransaction(
    String transactionId,
    DatabaseClient databaseClient,
  );

  Future<List<dynamic>> getAllTransactions(DatabaseClient databaseClient);
}

class VttRepository extends _TransactionRepository {
  final StoreRef _store = stringMapStoreFactory.store("value_transfers");

  @override
  Future<bool> deleteTransaction(
      String transactionId, DatabaseClient databaseClient) async {
    try {
      await _store.record(transactionId).delete(databaseClient);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ValueTransferInfo>> getAllTransactions(
      DatabaseClient databaseClient) async {
    final snapshots = await _store.find(databaseClient);
    try {
      List<ValueTransferInfo> transactions = snapshots
          .map((snapshot) => ValueTransferInfo.fromDbJson(
              snapshot.value as Map<String, dynamic>))
          .toList(growable: false);
      return transactions;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> insertTransaction(
      transaction, DatabaseClient databaseClient) async {
    try {
      assert(transaction.runtimeType == ValueTransferInfo);
      await _store
          .record(transaction.txnHash)
          .add(databaseClient, transaction.jsonMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateTransaction(
      transaction, DatabaseClient databaseClient) async {
    try {
      assert(transaction.runtimeType == ValueTransferInfo);
      await _store
          .record(transaction.txnHash)
          .update(databaseClient, transaction.jsonMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ValueTransferInfo?> getTransaction(
      String txHash, DatabaseClient databaseClient) async {
    try {
      dynamic valueTransferInfoDbJson =
          await _store.record(txHash).get(databaseClient);

      ValueTransferInfo valueTransferInfo =
          ValueTransferInfo.fromDbJson(valueTransferInfoDbJson);

      return valueTransferInfo;
    } catch (e) {
      return null;
    }
  }
}

class DataRequestRepository extends _TransactionRepository {
  final StoreRef _store = stringMapStoreFactory.store("data_requests");

  @override
  Future<bool> deleteTransaction(
    String transactionId,
    DatabaseClient databaseClient,
  ) async {
    try {
      await _store.record(transactionId).delete(databaseClient);
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<List> getAllTransactions(DatabaseClient databaseClient) async {
    final List<RecordSnapshot<dynamic, dynamic>> snapshots =
        await _store.find(databaseClient);

    List<DRTransaction> wallets = snapshots
        .map((snapshot) => DRTransaction.fromJson(snapshot.value))
        .toList(growable: false);
    return wallets;
  }

  @override
  Future<bool> insertTransaction(
    transaction,
    DatabaseClient databaseClient,
  ) async {
    try {
      assert(transaction.runtimeType == DRTransaction);
      await _store
          .record(transaction.transactionID)
          .add(databaseClient, transaction.jsonMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateTransaction(
    transaction,
    DatabaseClient databaseClient,
  ) async {
    try {
      assert(transaction.runtimeType == VTTransaction);
      await _store.record(transaction.transactionID).update(
            databaseClient,
            transaction.jsonMap(),
          );
    } catch (e) {
      return false;
    }
    return true;
  }
}

class MintRepository extends _TransactionRepository {
  final StoreRef _store = stringMapStoreFactory.store("mints");

  @override
  Future<bool> deleteTransaction(
    String transactionId,
    DatabaseClient databaseClient,
  ) async {
    try {
      await _store.record(transactionId).delete(databaseClient);
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<List<MintEntry>> getAllTransactions(
      DatabaseClient databaseClient) async {
    final snapshots = await _store.find(databaseClient);
    try {
      List<MintEntry> transactions = snapshots
          .map((snapshot) =>
              MintEntry.fromJson(snapshot.value as Map<String, dynamic>))
          .toList(growable: false);
      return transactions;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> insertTransaction(
    transaction,
    DatabaseClient databaseClient,
  ) async {
    try {
      assert(transaction.runtimeType == MintEntry);
      await _store
          .record(transaction.blockHash)
          .add(databaseClient, transaction.jsonMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateTransaction(
    transaction,
    DatabaseClient databaseClient,
  ) async {
    try {
      assert(transaction.runtimeType == MintEntry);
      await _store.record(transaction.blockHash).update(
            databaseClient,
            transaction.jsonMap(),
          );
    } catch (e) {
      print('Error updating mint $e');
      return false;
    }
    return true;
  }

  Future<MintEntry?> getTransaction(
      String txHash, DatabaseClient databaseClient) async {
    try {
      dynamic mintInfoDbJson = await _store.record(txHash).get(databaseClient);

      MintEntry valueTransferInfo = MintEntry.fromJson(mintInfoDbJson);

      return valueTransferInfo;
    } catch (e) {
      return null;
    }
  }
}
