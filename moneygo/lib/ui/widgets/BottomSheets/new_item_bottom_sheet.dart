import 'package:flutter/material.dart';
import 'package:moneygo/routes.dart';
import 'package:moneygo/ui/widgets/Themes/custom_color_scheme.dart';
import 'package:moneygo/ui/widgets/Themes/custom_text_scheme.dart';

class NewItemBottomSheet extends StatelessWidget {
  final Map<String, String> buttons;

  const NewItemBottomSheet({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: CustomColorScheme.appBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: const Center(
              child: Text(
                'Add New Entry',
                style: CustomTextStyleScheme.dialogTitle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buttons.entries.map((button) {
                return Column(children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(15),
                        ),
                        side: MaterialStateProperty.all(
                          const BorderSide(
                              width: 3,
                              color: CustomColorScheme.backgroundColor),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: MaterialStateProperty.all(Size.zero),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            AppRoutes.generateRoute(
                                RouteSettings(name: button.value)));
                      },
                      child: Text(
                        button.key,
                        style: CustomTextStyleScheme.bottomSheetButton,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ]);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
