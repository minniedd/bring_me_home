import 'package:flutter/material.dart';
import 'package:learning_app/components/animal_window.dart';
import 'package:learning_app/screens/animal_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: "HOME",
      child: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.deepPurple.shade300,
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                height: 210,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recite nam šta mislite",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Button functionality here
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 45, vertical: 25),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.deepPurple.shade300,
                            ),
                            child: const Text('RECENZIJE'),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/dog.png',
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Button functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 25),
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black87,
                        ),
                        child: const Text('MAČKE'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Button functionality here
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            elevation: 2,
                            shadowColor: Colors.grey.shade800),
                        child: const Text('PSI'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Button functionality here
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            elevation: 2,
                            shadowColor: Colors.grey.shade800),
                        child: const Text('PTICE'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Button functionality here
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            elevation: 2,
                            shadowColor: Colors.grey.shade800),
                        child: const Text('HRČCI'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Button functionality here
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            elevation: 2,
                            shadowColor: Colors.grey.shade800),
                        child: const Text('RIBICE'),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(
                            color: Colors.deepPurple.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () {
                          // button func
                        },
                        icon: const Icon(
                          Icons.filter_list_alt,
                          size: 40,
                          color: Color.fromRGBO(176, 139, 215, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: AnimalWindow(
                  animalName: 'animalName',
                  animalAge: 'animalAge',
                  shelterCity: 'shelterCity',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnimalScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
