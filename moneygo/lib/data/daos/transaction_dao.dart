import 'package:drift/drift.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/tables/transactions.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Stream<List<Transaction>> watchAllTransactions() =>
      select(transactions).watch();

  Future<List<Transaction>> getAllTransactions() async =>
      await select(transactions).get();

  Future<Transaction?> getTransactionById(int id) async =>
      await (select(transactions)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertTransaction(TransactionsCompanion transaction) async =>
      await into(transactions).insert(transaction);

  Future<bool> updateTransaction(Transaction transaction) async =>
      await update(transactions).replace(transaction);

  Future<int> deleteTransaction(Transaction transaction) async =>
      await delete(transactions).delete(transaction);

  Future<int> deleteTransactionById(int id) async =>
      await (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
}
