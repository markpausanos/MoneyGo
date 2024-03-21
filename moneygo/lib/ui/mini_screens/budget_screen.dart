import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/blocs/periods/period_bloc.dart';
import 'package:moneygo/data/blocs/periods/period_event.dart';
import 'package:moneygo/data/blocs/periods/period_state.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/data/blocs/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/transactions/transaction_state.dart';
import 'package:moneygo/ui/utils/state_widget.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/budget_period_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/categories_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/remaining_balance_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/sources_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/transactions_card.dart';
import 'package:moneygo/ui/widgets/Loaders/loading_state.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
    BlocProvider.of<SourceBloc>(context).add(LoadSources());
    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
    BlocProvider.of<PeriodBloc>(context).add(LoadPeriods());
    BlocProvider.of<TransactionBloc>(context).add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBudgetPeriodCard(),
        _buildBalanceCard(),
        _buildCategoriesCard(),
        _buildSourcesCard(),
        _buildTransactionsCard(),
      ],
    );
  }

  Widget _buildBudgetPeriodCard() {
    return BlocBuilder<PeriodBloc, PeriodState>(builder: (context, state) {
      return buildBlocStateWidget(state,
          onLoad: const Loader(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) {
            final periods = (state as PeriodsLoaded).periods;
            return BudgetPeriodCard(
                startDate: periods[0].startDate, endDate: periods[0].endDate);
          });
    });
  }

  Widget _buildBalanceCard() {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return buildBlocStateWidget(state,
          onLoad: const CircularProgressIndicator(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) {
            final settings = (state as SettingsLoaded).settings;
            return RemainingBalanceCard(
              isVisible: settings["isVisible"] == "true",
            );
          });
    });
  }

  Widget _buildCategoriesCard() {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return buildBlocStateWidget(state,
          onLoad: const Loader(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) => CategoriesCard(
                categories: (state as CategoriesLoaded).categories,
              ));
    });
  }

  Widget _buildSourcesCard() {
    return BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
      return buildBlocStateWidget(state,
          onLoad: const Loader(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) {
            print("Hello sources");
            return SourcesCard(
              sources: (state as SourcesLoaded).sources,
            );
          });
    });
  }

  Widget _buildTransactionsCard() {
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
      return buildBlocStateWidget(state,
          onLoad: const Loader(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) {
            var transactionsMap = (state as TransactionsLoaded).transactions;

            for (var transaction in transactionsMap.values) {
              print(transaction);

            }
            return TransactionsCard(transactionsMap: transactionsMap);
          });
    });
  }
}
