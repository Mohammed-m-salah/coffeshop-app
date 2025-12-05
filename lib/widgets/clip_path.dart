import 'package:coffee_advanced_app/screens/product_details.dart';
import 'package:flutter/material.dart';

class CategoryClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 100);
    path.quadraticBezierTo(size.width / 2, -40, 0, 80);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CategorySection extends StatefulWidget {
  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final List<IconData> icons = [
    Icons.coffee,
    Icons.fastfood,
    Icons.icecream,
    Icons.local_pizza,
    Icons.cake,
  ];

  final ScrollController _scrollController = ScrollController();
  double scrollOffset = 0;

  // عدد تكرارات القائمة لإنشاء تأثير السكرول الدائري
  final int _loopMultiplier = 1000;

  // تعديل هذه القيمة لوضع الصورة أعلى/أسفل داخل الدائرة (بين 20 و 100)
  final double imageTopOffset = 60.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scroll_controller_safe();
      });
    });

    // التمرير إلى المنتصف بعد بناء الواجهة لإنشاء تأثير لا نهائي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double initialScroll = (_loopMultiplier / 2) * icons.length * 100.0;
        _scrollController.jumpTo(initialScroll);
      }
    });
  }

  double _scroll_controller_safe() {
    // حماية بسيطة: إذا لم يكن controller متاحًا أو لا يحتوي قيمة، نعيد 0
    try {
      return _scroll_controller_value();
    } catch (_) {
      return 0.0;
    }
  }

  double _scroll_controller_value() {
    return _scroll_controller_get();
  }

  double _scroll_controller_get() =>
      _scrollController.hasClients ? _scrollController.offset : 0.0;

  double getCurveY(double x, double width) {
    double a = 160 / (width * width);
    double b = -160 / width;
    double c = 80;
    return a * x * x + b * x + c;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      clipper: CategoryClipper(),
      child: Stack(
        children: [
          Container(
            height: 587,
            color: Color(0xff3E9269),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              reverse: true, // اتركها true إذا تريد البداية من اليمين
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(icons.length * _loopMultiplier, (index) {
                  // استخدام modulo للحصول على الأيقونة المناسبة بشكل دائري
                  int actualIndex = index % icons.length;
                  double iconX = index * 100.0;
                  double topOffset =
                      getCurveY(iconX - scrollOffset, screenWidth);

                  return Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        SizedBox(height: topOffset.clamp(20, 120)),
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Icon(icons[actualIndex], color: Color(0xffC67C4E)),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Cat ${actualIndex + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 110,
            right: 10,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Column(
                    children: [
                      // --- BIG CIRCLE ---
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return ProductDetails();
                          }));
                        },
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.amber,
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

                      const SizedBox(height: 10),

                      // --- TEXT UNDER THE CIRCLE ---
                      Text(
                        'Strwpary Jouse ', // or any dynamic category title
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- TEXT UNDER THE CIRCLE ---
                      Text(
                        ' \$30.00  ', // or any dynamic category title
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
