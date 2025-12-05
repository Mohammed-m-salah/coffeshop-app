import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- HEADER ROW ---
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.black, size: 28),
                ),
                Text(
                  'Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/icons/icons8-paper-bag-48 (1).png',
                  scale: 1.5,
                  color: Color(0xffE1CCA1),
                ),
              ],
            ),
          ),

          // --- BIG CIRCLE ---
          Positioned(
            top: 180,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xff44A475),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -100,
                    left: 30,
                    right: 30,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/drink4.png',
                        scale: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- TEXT BELOW THE CIRCLE ---
          Positioned(
            top: 400,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Text(
                  'Strawberry \n Juice',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1),
                ),
                Spacer(),
                Text(
                  '\$30.00',
                  style: TextStyle(
                    color: Color(0xff44A475),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // --- Size options label ---
          Positioned(
            top: 470,
            left: 16,
            child: Text(
              'Size options',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ),

          // --- Scrollable sizes with even spacing ---
          Positioned(
            top: 510,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) =>
                    SizedBox(width: 30), // space between items
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0xff44A475),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icons/icons8-cup-64.png',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Size',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Name',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
