import 'package:flutter/material.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/blocs/periods/period_state.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';

Widget buildBlocStateWidget(
  dynamic state, {
  required Widget onLoad,
  required Widget Function(String) onError,
  required Widget Function(dynamic) onLoaded,
}) {
  if (state is CategoriesLoading ||
      state is SettingsLoading ||
      state is SourcesLoading ||
      state is PeriodsLoading ||
      state is TransactionsLoading) {
    return onLoad;
  } else if (state is CategoriesError ||
      state is SettingsError ||
      state is SourcesError ||
      state is PeriodsError ||
      state is TransactionsError) {
    return onError(state.message);
  } else if (state is CategoriesLoaded ||
      state is SettingsLoaded ||
      state is SourcesLoaded ||
      state is PeriodsLoaded ||
      state is TransactionsLoaded) {
    return onLoaded(state);
  }
  return const Text('Unknown state');
}
