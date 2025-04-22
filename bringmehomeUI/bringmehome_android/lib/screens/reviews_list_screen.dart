import 'package:flutter/material.dart';
import 'package:learning_app/widgets/master_screen.dart';

class ReviewsListScreen extends StatefulWidget {
  const ReviewsListScreen({super.key});

  @override
  State<ReviewsListScreen> createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: 'RECENZIJE',
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              hint: const Text("Izaberite opciju"),
              value: selectedValue,
              items: const [
                DropdownMenuItem(value: "Option 1", child: Text("Opcija 1")),
                DropdownMenuItem(value: "Option 2", child: Text("Opcija 2")),
                DropdownMenuItem(value: "Option 3", child: Text("Opcija 3")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: 'Ostavi recenziju',
                  hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary)),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
            ),
            // date time picker here
            const SizedBox(height: 50,),
            // stars
            
          ],
        ),
      ),
    );
  }
}
