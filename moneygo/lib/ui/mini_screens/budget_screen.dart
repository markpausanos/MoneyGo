import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_bloc.dart';
import 'package:moneygo/data/blocs/categories/category_event.dart';
import 'package:moneygo/data/blocs/categories/category_state.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/blocs/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/sources/source_event.dart';
import 'package:moneygo/data/blocs/sources/source_state.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/budget_period_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/categories_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/remaining_balance_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/sources_card.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  String _currency = "₱";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
    BlocProvider.of<SourceBloc>(context).add(LoadSources());
    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded) {
          setState(() {
            _currency = state.settings["currency"] ?? "₱";
          });
        }
      },
      child: Column(
        children: [
          BudgetPeriodCard(startDate: DateTime.parse("2024-03-03")),
          _buildSettingsCard(),
          _buildCategoriesCard(),
          _buildSourcesCard(),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return _buildBlocStateWidget(state,
          onLoad: const CircularProgressIndicator(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) {
            final settings = (state as SettingsLoaded).settings;
            return RemainingBalanceCard(
                isVisible: settings["isVisible"] == "true",
                currency: settings["currency"] ?? _currency);
          });
    });
  }

  Widget _buildCategoriesCard() {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return _buildBlocStateWidget(state,
          onLoad: const CircularProgressIndicator(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) => CategoriesCard(
                categories: (state as CategoriesLoaded).categories,
                currency: _currency,
              ));
    });
  }

  Widget _buildSourcesCard() {
    return BlocBuilder<SourceBloc, SourceState>(builder: (context, state) {
      return _buildBlocStateWidget(state,
          onLoad: const CircularProgressIndicator(),
          onError: (message) => DashedWidgetWithMessage(message: message),
          onLoaded: (state) => SourcesCard(
                sources: (state as SourcesLoaded).sources,
                currency: _currency,
              ));
    });
  }

  Widget _buildBlocStateWidget(
    dynamic state, {
    required Widget onLoad,
    required Widget Function(String) onError,
    required Widget Function(dynamic) onLoaded,
  }) {
    if (state is CategoriesLoading ||
        state is SettingsLoading ||
        state is SourcesLoading) {
      return onLoad;
    } else if (state is CategoriesError ||
        state is SettingsError ||
        state is SourcesError) {
      return onError(state.message);
    } else if (state is CategoriesLoaded ||
        state is SettingsLoaded ||
        state is SourcesLoaded) {
      return onLoaded(state);
    }
    return const Text('Unknown state');
  }
}
