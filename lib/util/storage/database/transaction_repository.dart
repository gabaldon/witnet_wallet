import 'package:my_wit_wallet/util/storage/database/adapters/transaction_adapter.dart';
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
          .map((snapshot) => ValueTransferAdapter.fromJson(
              snapshot.value as Map<String, dynamic>))
          .toList(growable: false);
      return transactions;
    } catch (e) {
      print('Error getting all transactions $e');
      return [];
    }
  }

  @override
  Future<bool> insertTransaction(
      transaction, DatabaseClient databaseClient) async {
    try {
      assert(transaction.runtimeType == ValueTransferInfo);
      await _store
          .record(transaction.hash)
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
          .record(transaction.hash)
          .update(databaseClient, transaction.jsonMap());
      return true;
    } catch (e) {
      print('Error updating transaction $e');
      return false;
    }
  }

  Future<ValueTransferInfo?> getTransaction(
      String txHash, DatabaseClient databaseClient) async {
    try {
      dynamic valueTransferInfoDbJson =
          await _store.record(txHash).get(databaseClient);

      ValueTransferInfo valueTransferInfo =
          ValueTransferAdapter.fromJson(valueTransferInfoDbJson);

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

class UnstakeRepository extends _TransactionRepository {
  final StoreRef _store = stringMapStoreFactory.store("unstakes");

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
  Future<List<UnstakeEntry>> getAllTransactions(
      DatabaseClient databaseClient) async {
    final snapshots = await _store.find(databaseClient);
    try {
      List<UnstakeEntry> transactions = snapshots
          .map((snapshot) =>
              UnstakeEntry.fromJson(snapshot.value as Map<String, dynamic>))
          .toList(growable: false);
      return transactions;
    } catch (e) {
      print('Error getting mint transactions $e');
      return [];
    }
  }

  @override
  Future<bool> insertTransaction(
    transaction,
    DatabaseClient databaseClient,
  ) async {
    try {
      assert(transaction.runtimeType == UnstakeEntry);
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
      assert(transaction.runtimeType == UnstakeEntry);
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

  Future<UnstakeEntry?> getTransaction(
      String txHash, DatabaseClient databaseClient) async {
    try {
      dynamic unstakeInfoDbJson =
          await _store.record(txHash).get(databaseClient);

      UnstakeEntry unstakeEntry = UnstakeEntry.fromJson(unstakeInfoDbJson);

      return unstakeEntry;
    } catch (e) {
      return null;
    }
  }
}

class StakeRepository extends _TransactionRepository {
  final StoreRef _store = stringMapStoreFactory.store("stakes");

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
  Future<List<StakeEntry>> getAllTransactions(
      DatabaseClient databaseClient) async {
    final snapshots = await _store.find(databaseClient);
    try {
      List<StakeEntry> transactions = snapshots
          .map((snapshot) =>
              StakeEntry.fromJson(snapshot.value as Map<String, dynamic>))
          .toList(growable: false);
      return transactions;
    } catch (e) {
      print('Error getting mint transactions $e');
      return [];
    }
  }

  @override
  Future<bool> insertTransaction(
    transaction,
    DatabaseClient databaseClient,
  ) async {
    try {
      assert(transaction.runtimeType == StakeEntry);
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
      assert(transaction.runtimeType == StakeEntry);
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

  Future<StakeEntry?> getTransaction(
      String txHash, DatabaseClient databaseClient) async {
    try {
      dynamic stakeInfoDbJson = await _store.record(txHash).get(databaseClient);

      StakeEntry stakeEntry = StakeEntry.fromJson(stakeInfoDbJson);

      return stakeEntry;
    } catch (e) {
      return null;
    }
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
      print('Error getting mint transactions $e');
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

      MintEntry mintEntry = MintEntry.fromJson(mintInfoDbJson);

      return mintEntry;
    } catch (e) {
      return null;
    }
  }
}
