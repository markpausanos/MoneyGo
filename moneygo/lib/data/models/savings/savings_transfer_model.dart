import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/savings/savings_log_subtype.dart';

class SavingsTransferModel implements SavingLogsTypes {
  int id;
  SavingsLog savingsLog;
  Saving fromSaving;
  Saving toSaving;

  SavingsTransferModel({
    required this.id,
    required this.savingsLog,
    required this.fromSaving,
    required this.toSaving,
  });

  SavingsTransferModel copyWith({
    int? id,
    SavingsLog? savingsLog,
    Saving? fromSavings,
    Saving? toSavings,
    double? amount,
    DateTime? date,
  }) {
    return SavingsTransferModel(
      id: id ?? this.id,
      savingsLog: savingsLog ?? this.savingsLog,
      fromSaving: fromSavings ?? this.fromSaving,
      toSaving: toSavings ?? this.toSaving,
    );
  }

  @override
  String toString() {
    return 'SavingsTransferModel{id: $id, savingsLog: $savingsLog, fromSavings: $fromSaving, toSavings: $toSaving}';
  }
}
