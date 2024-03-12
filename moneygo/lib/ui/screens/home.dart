import 'package:flutter/material.dart';
import 'package:moneygo/ui/mini_screens/budget_screen.dart';
import 'package:moneygo/ui/widgets/Buttons/navigation_button.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  int _previousIndex = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectButton(int index, int previousIndex) {
    setState(() {
      _previousIndex = previousIndex;
      _selectedIndex = index;
    });

    double offset = (_selectedIndex - _previousIndex) * 80;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavigationButton(String title, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: NavigationButton(
        title: title,
        isSelected: _selectedIndex == index,
        onPressed: () => _selectButton(index, _selectedIndex),
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const BudgetScreen();
      case 1:
        return const Text('Savings Screen');
      case 2:
        return const Text('Debt Screen');
      case 3:
        return const Text('Credit Screen');
      default:
        return const Text('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttonTitles = ['Budget', 'Savings', 'Debt', 'Credit'];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            onPressed: () => print("Hello"), //SystemNavigator.pop,
          ),
          title: Text(
            widget.username,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          titleSpacing: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 100),
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
              const SizedBox(height: 10),
              _getCurrentScreen()
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 80,
          height: 80,
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              child: const Icon(Icons.add),
            ),
          ),
        ));
  }
}
