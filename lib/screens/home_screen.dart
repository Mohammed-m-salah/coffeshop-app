import 'package:coffee_advanced_app/widgets/clip_path.dart';
import 'package:flutter/material.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //header
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/icons8-cup-64.png',
                  scale: 1.5,
                  color: Color(0xffE1CCA1),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      'Qahwe',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'space',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                Spacer(),
                Image.asset(
                  'assets/icons/icons8-paper-bag-48 (1).png',
                  scale: 1.5,
                  color: Color(0xffE1CCA1),
                ),
              ],
            ),
          ),
          //center text
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 150, top: 20),
            child: Text(
              'Smothe Out \n Your Everday',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                height: 1,
              ),
            ),
          ),
          //clip path
          CategorySection(),
        ],
      ),
    );
  }
}
