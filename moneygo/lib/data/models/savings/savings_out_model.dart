import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/models/savings/savings_log_subtype.dart';

class SavingsOutModel implements SavingLogsTypes {
  int id;
  SavingsLog savingsLog;
  Saving saving;
  Source source;

  SavingsOutModel({
    required this.id,
    required this.savingsLog,
    required this.saving,
    required this.source,
  });

  SavingsOutModel copyWith({
    int? id,
    SavingsLog? savingsLog,
    Saving? savings,
    Source? source,
    double? amount,
    DateTime? date,
  }) {
    return SavingsOutModel(
      id: id ?? this.id,
      savingsLog: savingsLog ?? this.savingsLog,
      saving: savings ?? this.saving,
      source: source ?? this.source,
    );
  }

  @override
  String toString() {
    return 'SavingsOutModel{id: $id, savingsLog: $savingsLog, savings: $saving, source: $source}';
  }
}
