import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/savings/savings_log_subtype.dart';

class SavingsInModel implements SavingLogsTypes {
  int id;
  SavingsLog savingsLog;
  Saving saving;
  Source source;

  SavingsInModel({
    required this.id,
    required this.savingsLog,
    required this.saving,
    required this.source,
  });

  SavingsInModel copyWith({
    int? id,
    SavingsLog? savingsLog,
    Saving? savings,
    Source? source,
    double? amount,
    DateTime? date,
  }) {
    return SavingsInModel(
      id: id ?? this.id,
      savingsLog: savingsLog ?? this.savingsLog,
      saving: savings ?? this.saving,
      source: source ?? this.source,
    );
  }

  @override
  String toString() {
    return 'SavingsInModel{id: $id, savingsLog: $savingsLog, savings: $saving, source: $source}';
  }
}
