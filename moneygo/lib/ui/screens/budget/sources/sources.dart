import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneygo/data/app_database.dart';
import 'package:moneygo/data/blocs/budget/sources/source_bloc.dart';
import 'package:moneygo/data/blocs/budget/sources/source_event.dart';
import 'package:moneygo/data/blocs/budget/sources/source_state.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_bloc.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_event.dart';
import 'package:moneygo/data/blocs/budget/transactions/transaction_state.dart';
import 'package:moneygo/ui/utils/screen_utils.dart';
import 'package:moneygo/ui/widgets/CheckBoxWithItem/budget/source_checkbox.dart';
import 'package:moneygo/ui/widgets/IconButton/large_icon_button.dart';
import 'package:moneygo/ui/widgets/Loaders/loading_state.dart';
import 'package:moneygo/ui/widgets/SizedBoxes/dashed_box_with_message.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({super.key});

  @override
  State<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  List<Source> _sources = [];
  final Map<int, bool> _checkedStates = {};
  bool _containsChecked = false;
  bool _isMoved = false;

  @override
  void initState() {
    super.initState();

    for (final source in _sources) {
      _checkedStates[source.id] = false;
    }

    BlocProvider.of<SourceBloc>(context).add(LoadSources());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SourceBloc, SourceState>(listener: (context, state) {
            if (state is SourcesSaveSuccess && !_isMoved) {
              ScreenUtils.showSnackBarAddOrUpdate(
                  context, 'Source ${state.name} has been added');
            } else if (state is SourcesUpdateSuccess && !_isMoved) {
              ScreenUtils.showSnackBarAddOrUpdate(
                  context, 'Source has been updated');
            } else if (state is SourcesDeleteSuccess && !_isMoved) {
              ScreenUtils.showSnackBarDelete(context, 'Source/s deleted');
            }
          }),
          BlocListener<TransactionBloc, TransactionState>(
              listener: (context, state) {
            if (state is TransactionsDeleteSuccess) {
              int sourceId = state.sourceId;

              if (sourceId != 0) {
                BlocProvider.of<SourceBloc>(context)
                    .add(DeleteSource(sourceId));
              }
            }
          })
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: CustomColorScheme.appBarCards,
            leading: IconButtonLarge(
                onPressed: () => Navigator.popAndPushNamed(context, '/home'),
                icon: Icons.arrow_back,
                color: Colors.white),
            title: const Text('Sources',
                style: CustomTextStyleScheme.appBarTitleCards),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: IconButton(
                          key: Key(_containsChecked.toString()),
                          onPressed: () {
                            _sources.isEmpty
                                ? null
                                : _containsChecked
                                    ? _unselectAllSources()
                                    : _selectAllSources();
                          },
                          icon: _containsChecked
                              ? const Icon(
                                  Icons.cancel_rounded,
                                  color: CustomColorScheme.appRed,
                                )
                              : const Icon(
                                  Icons.select_all,
                                  color: CustomColorScheme.appBlue,
                                )),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: () {
                        int checkedCount = _checkedStates.values
                            .where((element) => element)
                            .length;

                        if (checkedCount == 2) {
                          return IconButton(
                            key: const ValueKey('swap'),
                            onPressed: _swapSelectedSources,
                            icon: const Icon(Icons.swap_vert_rounded,
                                color: CustomColorScheme.appBlue),
                          );
                        } else if (checkedCount == 1) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Move to topmost
                              IconButton(
                                key: const ValueKey('top'),
                                onPressed: () {
                                  final Source source = _sources.firstWhere(
                                      (source) =>
                                          _checkedStates[source.id] ?? false);
                                  _moveSourceToTopMost(source);
                                },
                                icon: const Icon(
                                    Icons.vertical_align_top_rounded,
                                    color: CustomColorScheme.appGreen),
                              ),

                              IconButton(
                                key: const ValueKey('singleUp'),
                                onPressed: () {
                                  final Source source = _sources.firstWhere(
                                      (source) =>
                                          _checkedStates[source.id] ?? false);
                                  _moveSourceUp(source);
                                },
                                icon: const Icon(Icons.move_up,
                                    color: CustomColorScheme.appGreen),
                              ),

                              IconButton(
                                key: const ValueKey('singleDown'),
                                onPressed: () {
                                  final Source source = _sources.firstWhere(
                                      (source) =>
                                          _checkedStates[source.id] ?? false);
                                  _moveSourceDown(source);
                                },
                                icon: const Icon(Icons.move_down,
                                    color: CustomColorScheme.appRed),
                              ),

                              // Move to bottommost
                              IconButton(
                                key: const ValueKey('bottom'),
                                onPressed: () {
                                  final Source source = _sources.firstWhere(
                                      (source) =>
                                          _checkedStates[source.id] ?? false);
                                  _moveSourceToBottomMost(source);
                                },
                                icon: const Icon(
                                    Icons.vertical_align_bottom_rounded,
                                    color: CustomColorScheme.appRed),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }(),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: IconButton(
                        key: Key(_containsChecked.toString()),
                        onPressed: _containsChecked
                            ? _showDeleteConfirmationDialog
                            : _showAddSourceDialog,
                        icon: _containsChecked
                            ? const Icon(
                                Icons.delete_rounded,
                                color: CustomColorScheme.appRed,
                              )
                            : const Icon(
                                Icons.add_circle_outline_rounded,
                                color: CustomColorScheme.appGreen,
                              ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<SourceBloc, SourceState>(
                  builder: (context, state) {
                    if (state is SourcesLoading) {
                      return const Center(child: Loader());
                    } else if (state is SourcesLoaded) {
                      _sources = state.sources;
                      return _buildSourceList(_sources);
                    } else if (state is SourcesError) {
                      return DashedWidgetWithMessage(
                          message: 'Error: ${state.message}');
                    } else {
                      return const DashedWidgetWithMessage(
                          message: 'Error loading sources');
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildSourceList(List<Source> sources) {
    return sources.isEmpty
        ? const DashedWidgetWithMessage(message: "No sources found")
        : Column(
            children: sources.map((source) {
            return Column(
              children: [
                SourceCheckBox(
                  key: Key(source.id.toString()),
                  id: source.id,
                  name: source.name,
                  isChecked: _checkedStates[source.id] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      _checkedStates[source.id] = value ?? false;
                      _containsChecked = _checkedStates.containsValue(true);
                    });
                  },
                  onLongPressed: () => _showUpdateSourceDialog(source),
                  onTap: () => setState(() {
                    _checkedStates[source.id] =
                        !(_checkedStates[source.id] ?? false);
                    _containsChecked = _checkedStates.containsValue(true);
                  }),
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList());
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

  void _selectAllSources() {
    setState(() {
      for (final source in _sources) {
        _checkedStates[source.id] = true;
      }
      _containsChecked = true;
    });
  }

  void _unselectAllSources() {
    setState(() {
      for (final source in _sources) {
        _checkedStates[source.id] = false;
      }
      _containsChecked = false;
    });
  }

  void _swapSelectedSources() {
    final List<Source> sources = _sources;
    final List<Source> checkedSources =
        sources.where((source) => _checkedStates[source.id] ?? false).toList();

    final int firstIndex = sources.indexOf(checkedSources[0]);

    final int secondIndex = sources.indexOf(checkedSources[1]);

    final Source firstSource = sources[firstIndex];

    final Source secondSource = sources[secondIndex];

    final int firstOrder = firstSource.order;

    final int secondOrder = secondSource.order;
    final Source updatedFirstSource = firstSource.copyWith(order: secondOrder);
    final Source updatedSecondSource = secondSource.copyWith(order: firstOrder);

    BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedFirstSource));
    BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedSecondSource));

    setState(() {
      _isMoved = true;
    });
  }

  void _moveSourceUp(Source source) {
    final List<Source> sources = _sources;
    final int index = sources.indexOf(source);

    if (index > 0) {
      final Source previousSource = sources[index - 1];
      final int order = source.order;
      final int previousOrder = previousSource.order;

      final Source updatedSource = source.copyWith(order: previousOrder);
      final Source updatedPreviousSource =
          previousSource.copyWith(order: order);

      BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedSource));
      BlocProvider.of<SourceBloc>(context)
          .add(UpdateSource(updatedPreviousSource));
    }

    _isMoved = true;
  }

  void _moveSourceDown(Source source) {
    final List<Source> sources = _sources;
    final int index = sources.indexOf(source);

    if (index < sources.length - 1) {
      final Source nextSource = sources[index + 1];
      final int order = source.order;
      final int nextOrder = nextSource.order;

      final Source updatedSource = source.copyWith(order: nextOrder);
      final Source updatedNextSource = nextSource.copyWith(order: order);

      BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedSource));
      BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedNextSource));
    }

    _isMoved = true;
  }

  void _moveSourceToTopMost(Source source) {
    final List<Source> sources = _sources;
    int startIndex = 0;
    int endIndex = sources.indexOf(source);

    for (int i = startIndex; i < endIndex; i++) {
      final Source updatedSource = sources[i].copyWith(order: i + 1);
      BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedSource));
    }

    final Source updatedSource = source.copyWith(order: 0);

    BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedSource));

    _isMoved = true;
  }

  void _moveSourceToBottomMost(Source source) {
    final List<Source> sources = _sources;
    int startIndex = sources.indexOf(source);
    int endIndex = sources.length - 1;

    for (int i = startIndex + 1; i <= endIndex; i++) {
      final Source updatedSource = sources[i].copyWith(order: i - 1);
      BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedSource));
    }

    final Source updatedSource = source.copyWith(order: sources.length - 1);

    BlocProvider.of<SourceBloc>(context).add(UpdateSource(updatedSource));

    _isMoved = true;
  }

  Future<void> _saveSource() async {
    final String name = _nameController.text;

    if (name.isNotEmpty) {
      final source = SourcesCompanion(name: Value(name));

      BlocProvider.of<SourceBloc>(context).add(AddSource(source));

      _nameController.clear();
    }

    _isMoved = false;
  }

  Future<void> _updateSource(Source source) async {
    final String name = _nameController.text;

    if (name.isNotEmpty) {
      source = source.copyWith(name: name);

      BlocProvider.of<SourceBloc>(context).add(UpdateSource(source));
    }

    _isMoved = false;
  }

  Future<void> _deleteSources() async {
    List<int> sourceIdsToDelete = _sources
        .where((source) => _checkedStates[source.id] ?? false)
        .map((source) => source.id)
        .toList();

    for (final id in sourceIdsToDelete) {
      BlocProvider.of<TransactionBloc>(context)
          .add(DeleteTransactionBySource(id));
    }

    _unselectAllSources();

    _isMoved = false;
  }

  Future<void> _showAddSourceDialog() async {
    final result = await _showSourceDialog(title: 'Add Source');

    if (result == 'save') {
      _saveSource();
    }
  }

  Future<void> _showUpdateSourceDialog(Source source) async {
    final result =
        await _showSourceDialog(title: 'Update Source', name: source.name);

    if (result == 'save') {
      _updateSource(source);
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          titlePadding: const EdgeInsets.all(0.0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          buttonPadding: const EdgeInsets.all(0.0),
          title: Container(
              decoration: const BoxDecoration(
                color: CustomColorScheme.appRed,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 15.0),
                  Center(
                    child: Text(
                      'Delete Sources',
                      style: CustomTextStyleScheme.dialogTitle,
                    ),
                  ),
                  SizedBox(height: 15.0),
                ],
              )),
          content: const SingleChildScrollView(
            child: Center(
              child: Text(
                  'This action will delete related transactions. Are you sure you want to delete the selected sources?',
                  style: CustomTextStyleScheme.dialogBody,
                  textAlign: TextAlign.center),
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.black))),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CustomColorScheme.appRed),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            )),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.white)))
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ],
        );
      },
    );

    if (result ?? false) {
      await _deleteSources();
    }
  }

  Future<String?> _showSourceDialog({String? title, String? name}) async {
    _nameController.text = name ?? '';

    return await showDialog<String>(
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
                            } else if (value.length > 15) {
                              return 'Must not exceed 15 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) => _validateForm(),
                        ),
                        const SizedBox(height: 30.0),
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
  }
}
