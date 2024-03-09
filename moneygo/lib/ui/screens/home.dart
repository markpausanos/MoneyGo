import 'package:flutter/material.dart';
import 'package:moneygo/ui/mini_screens/budget_screen.dart';
import 'package:moneygo/ui/widgets/Buttons/navigation_button.dart';
import 'package:moneygo/ui/widgets/Cards/base_card.dart';
import 'package:moneygo/ui/widgets/Cards/budget_screen/remaining_balance_card.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _selectButton(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavigationButton(String title, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: NavigationButton(
        title: title,
        isSelected: _selectedIndex == index,
        onPressed: () => _selectButton(index),
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return BudgetScreen();
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
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0),
          child: Column(
            children: [
              SizedBox(
                height: 35,
                child: ListView(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: const Icon(Icons.add),
        ));
  }
}
