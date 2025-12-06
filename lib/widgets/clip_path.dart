import 'package:coffee_advanced_app/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// Circular Arc Painter - draws the circular path guide
class CircularArcPainter extends CustomPainter {
  final double centerX;
  final double centerY;
  final double radius;

  CircularArcPainter({
    required this.centerX,
    required this.centerY,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw semi-circular arc as guide
    final Paint arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw semi-circle arc (180 degrees from right to left)
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius,
      ),
      0, // Start angle (0 = right side)
      math.pi, // Sweep angle (π = 180 degrees)
      false, // Use center
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(CircularArcPainter oldDelegate) {
    return centerX != oldDelegate.centerX ||
        centerY != oldDelegate.centerY ||
        radius != oldDelegate.radius;
  }
}

class CategoryClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 120);

    // Create a perfect semi-circular arc at the top
    // Using cubic bezier for smoother circular curve
    double controlPoint1X = size.width * 0.75;
    double controlPoint1Y = 20;
    double controlPoint2X = size.width * 0.25;
    double controlPoint2Y = 20;

    path.cubicTo(
        controlPoint1X,
        controlPoint1Y, // First control point
        controlPoint2X,
        controlPoint2Y, // Second control point
        0,
        120 // End point
        );

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
    // Start with initial scroll offset to center items in semi-circle
    // This positions the first few items in the visible arc (0 to π)
    scrollOffset = -100.0; // Start position to show items
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

  // Get position on semi-circular arc (180 degrees only)
  Map<String, double> getCircularPosition(
      int index, double scrollOffset, double screenWidth) {
    // Semi-circle carousel parameters (matches green arc)
    double radius = screenWidth * 0.4; // Radius proportional to screen width
    double centerX = screenWidth / 2; // Center X of the semi-circle
    double centerY = 200.0; // Center Y position (adjusted to match green arc)

    // Calculate angle for this item (in radians)
    // Semi-circle: from 0 to π (180 degrees)
    // Each item separated by 0.35 radians (~20 degrees) - smaller spacing
    double itemAngleSpacing = 0.35;
    double baseAngle = index * itemAngleSpacing;

    // Adjust angle based on scroll offset
    double angleOffset = scrollOffset * 0.008;
    double angle = baseAngle + angleOffset;

    // Wrap angle to create infinite loop (keep between 0 and 2π)
    while (angle < 0) angle += math.pi * 2;
    while (angle > math.pi * 2) angle -= math.pi * 2;

    // Only show items in the top semi-circle (0 to π)
    if (angle > math.pi) {
      return {
        'x': -1000.0, // Hide off-screen
        'y': -1000.0,
        'scale': 0.0,
        'opacity': 0.0,
        'visible': 0.0,
      };
    }

    // Calculate position using trigonometry
    // For semi-circle: angle goes from 0 (right) to π (left)
    double x = centerX + radius * math.cos(angle);
    double y = centerY - radius * math.sin(angle); // Negative for upward arc

    // Calculate scale based on angle (items at top center are larger)
    // Top center is at π/2 (90 degrees)
    double distanceFromTop = (angle - math.pi / 2).abs();
    double scale = 1.0 - (distanceFromTop / (math.pi / 2)) * 0.35;
    scale = scale.clamp(0.65, 1.0);

    // Calculate opacity (more visible at top)
    double opacity = 0.5 + (scale * 0.5); // Range from 0.5 to 1.0

    return {
      'x': x,
      'y': y,
      'scale': scale,
      'opacity': opacity,
      'visible': 1.0,
    };
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
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                // Update scroll position based on drag
                setState(() {
                  scrollOffset -= details.delta.dx;
                });
              },
              child: Stack(
                children: List.generate(icons.length * 5, (index) {
                  int actualIndex = index % icons.length;

                  // Get position on semi-circular arc
                  Map<String, double> pos =
                      getCircularPosition(index, scrollOffset, screenWidth);

                  // Skip items that are not visible (outside semi-circle)
                  if (pos['visible'] == 0.0) {
                    return SizedBox.shrink();
                  }

                  return Positioned(
                    left: pos['x']! - 40, // Center the icon
                    top: pos['y']! - 40,
                    child: Transform.scale(
                      scale: pos['scale']!,
                      child: Opacity(
                        opacity: pos['opacity']!,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    icons[actualIndex],
                                    color: Color(0xffC67C4E),
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Cat ${actualIndex + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Draw semi-circular arc guide
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(screenWidth, 400),
              painter: CircularArcPainter(
                centerX: screenWidth / 2,
                centerY: 200,
                radius: screenWidth * 0.4,
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
