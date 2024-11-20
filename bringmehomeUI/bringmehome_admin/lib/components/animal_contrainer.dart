import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimalContainer extends StatelessWidget {
  const AnimalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
  height: 400, 
  width: 250,  
  child: Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://picsum.photos/250?image=9',
              height: 200, 
              width: 200, 
              fit: BoxFit.cover, 
            ),
          ),
          Text(
            "data",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("data"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
    ),
  ),
);

  }
}
