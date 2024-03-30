import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_bloc.dart';
import 'package:moneygo/data/blocs/settings/settings_event.dart';
import 'package:moneygo/data/blocs/settings/settings_state.dart';
import 'package:moneygo/data/blocs/budget/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/budget/sources/source_state.dart';
import 'package:moneygo/ui/mini_screens/budget_screen.dart';
import 'package:moneygo/ui/utils/screen_utils.dart';
import 'package:moneygo/ui/widgets/BottomSheets/new_item_bottom_sheet.dart';
import 'package:moneygo/ui/widgets/Buttons/navigation_button.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  bool _autoValidate = false;
  int _selectedIndex = 0;
  String _username = 'Default User';
  String _currency = '\$';

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SettingsBloc>(context).add(LoadSettings());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttonTitles = [
      'Budget',
      'Savings',
      'Debt',
      'Credit',
      'Notes'
    ];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            onPressed: () => SystemNavigator.pop(),
          ),
          title: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading) {
                return const CircularProgressIndicator();
              } else if (state is SettingsError) {
                return const Text('Error loading settings');
              } else {
                final settings = (state as SettingsLoaded).settings;
                _username = settings['username'] ?? 'Default User';
                _currency = settings['currency'] ?? '\$';
                return Text(
                  _username,
                  style: Theme.of(context).textTheme.titleMedium,
                );
              }
            },
          ),
          titleSpacing: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
                onPressed: () => _showHomeSettingsDialog(
                    title: "Settings", name: _username, currency: _currency),
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 0),
          child: Column(
            children: [
              SizedBox(
                height: 35,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: buttonTitles
                      .map((title) => _buildNavigationButton(
                          title, buttonTitles.indexOf(title)))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _selectButton(index);
                  },
                  children: [
                    _wrapChildrenWithScrollView(const BudgetScreen()),
                    const DashedWidgetWithMessage(
                        message: 'Savings Screen Ongoing!'),
                    const DashedWidgetWithMessage(
                        message: 'Debt Screen Ongoing!'),
                    const DashedWidgetWithMessage(
                        message: 'Credit Screen Ongoing!'),
                    const DashedWidgetWithMessage(
                        message: 'Notes Screen Ongoing!'),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Tooltip(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          textAlign: TextAlign.center,
          message:
              'Add a new transaction by selecting what type of transaction you want to add.',
          child: SizedBox(
            width: 80,
            height: 80,
            child: FittedBox(
              child: BlocBuilder<SourceBloc, SourceState>(
                  builder: (context, state) {
                if (state is SourcesLoading) {
                  return const CircularProgressIndicator();
                } else if (state is SourcesError) {
                  return const Icon(Icons.error);
                } else {
                  var sources = (state as SourcesLoaded).sources;

                  if (sources.isEmpty) {
                    return const SizedBox();
                  }
                  return FloatingActionButton(
                    elevation: 10,
                    onPressed: () =>
                        _showBottomSheet(context, sources.length > 1),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: const Icon(Icons.add),
                  );
                }
              }),
            ),
          ),
        ));
  }

  void _selectButton(int index) {
    _pageController.jumpToPage(index);

    setState(() {
      _selectedIndex = index;
    });

    double offset = (_selectedIndex) * 50;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavigationButton(String title, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: NavigationButton(
        title: title,
        isSelected: _selectedIndex == index,
        onPressed: () => _selectButton(
          index,
        ),
      ),
    );
  }

  Widget _wrapChildrenWithScrollView(Widget child) {
    return SingleChildScrollView(
      child: Column(
        children: [child, const SizedBox(height: 100)],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, bool transferVisible) {
    if (_selectedIndex == 0) {
      _showBottomSheetBudgetScreen(context, transferVisible);
    }
  }

  void _showBottomSheetBudgetScreen(
      BuildContext context, bool transferVisible) {
    var buttons = {
      'Expense': '/expense/new',
      'Income': '/income/new',
    };

    if (transferVisible) {
      buttons['Transfer'] = '/transfer/new';
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return NewItemBottomSheet(
          buttons: buttons,
        );
      },
    );
  }

  void _saveSettings() {
    BlocProvider.of<SettingsBloc>(context).add(UpdateSetting(
      'username',
      _nameController.text,
    ));
    BlocProvider.of<SettingsBloc>(context).add(UpdateSetting(
      'currency',
      _currencyController.text,
    ));

    setState(() {
      _username = _nameController.text;
      _currency = _currencyController.text;
    });

    _nameController.clear();
    _currencyController.clear();
  }

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop('save');
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Future<void> _showHomeSettingsDialog(
      {String? title, String? name, String? currency}) async {
    _nameController.text = name ?? '';
    _currencyController.text = currency ?? '';

    final result = await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: const EdgeInsets.all(0.0),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            buttonPadding: const EdgeInsets.all(0.0),
            title: Container(
              decoration: const BoxDecoration(
                color: CustomColorScheme.appGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15.0),
                  Center(
                      child: Text(title ?? '',
                          style: CustomTextStyleScheme.dialogTitle)),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            content: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: ListBody(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColorScheme.appRed)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            } else if (value.length > 20) {
                              return 'Must not exceed 20 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) => _validateForm(),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                            style: TextStyle(
                                fontFamily: CustomTextStyleScheme
                                    .currencySign.fontFamily),
                            controller: _currencyController,
                            decoration: const InputDecoration(
                              labelText: 'Currency',
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColorScheme.appRed)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a currency';
                              } else if (value.length > 3) {
                                return 'Must not exceed 3 characters';
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) => _validateForm(),
                            readOnly: true,
                            onTap: () {
                              showCurrencyPicker(
                                  context: context,
                                  showFlag: true,
                                  showCurrencyName: true,
                                  showCurrencyCode: true,
                                  onSelect: (Currency currency) {
                                    _currencyController.text = currency.symbol;
                                  },
                                  theme: CurrencyPickerThemeData(
                                      currencySignTextStyle:
                                          CustomTextStyleScheme
                                              .currencySignDropDown));
                            }),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CustomColorScheme.dialogButtonCancel),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )),
                              onPressed: () =>
                                  Navigator.of(context).pop('cancel'),
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CustomColorScheme.dialogButtonSave,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  side: const BorderSide(
                                      color: CustomColorScheme.appGreen,
                                      width: 0.5)),
                              onPressed: () {
                                _validateForm();
                              },
                              child: const Text('Save',
                                  style: TextStyle(
                                      color: CustomColorScheme.appGreen)),
                            ),
                          ],
                        ),
                      ],
                    ))),
          );
        });

    if (result == 'save') {
      _saveSettings();
    }
  }
}
