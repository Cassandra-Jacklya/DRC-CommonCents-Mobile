// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navbar_cubit.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final bottomNavBarCubit = context.watch<BottomNavBarCubit>();

    final Size size = MediaQuery.of(context).size;

    return Container(
        width: size.width,
        height: 80,
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.red,
                    border: Border.all(color: Colors.grey, width: 1.5)),
                width: size.width,
                height: 80,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(size.width, 80),
                      painter: NavBarCustomPainter(),
                    ),
                    Center(
                      heightFactor: 0.8,
                      child: SizedBox( height: 150,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: const Color(0xFFA4D8EF),
                              borderRadius: BorderRadius.circular(50),),
                          child: SizedBox(
                            height: 90,
                            width: 90,
                            child: FloatingActionButton(
                              onPressed: () {
                                bottomNavBarCubit.updatePageIndex(2);
                                print("Trading pressed");
                              },
                              backgroundColor: Colors.orange,
                              elevation: 0.1,
                              child: const Icon(Icons.trolley),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<BottomNavBarCubit>()
                                    .updatePageIndex(0);
                                print("HomePage");
                              },
                              icon: const Icon(Icons.home),
                              iconSize: 35,
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<BottomNavBarCubit>()
                                    .updatePageIndex(1);
                                print("NewsPage");
                              },
                              icon: const Icon(Icons.newspaper),
                              iconSize: 35,
                            ),
                            SizedBox(width: size.width * 0.2),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<BottomNavBarCubit>()
                                    .updatePageIndex(3);
                                print("ForumPage");
                              },
                              icon: const Icon(Icons.forum),
                              iconSize: 35,
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<BottomNavBarCubit>()
                                    .updatePageIndex(4);
                                print("ProfilePage");
                              },
                              icon: const Icon(Icons.person),
                              iconSize: 35,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class NavBarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint outlinePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(
        size.width * 0.2, 0, size.width * 0.35, 0); //left side
    path.quadraticBezierTo(
        size.width * 0.4, 0, size.width * 0.4, 20); //left curve
    path.arcToPoint(Offset(size.width * 0.6, 20), // trading button
        radius: const Radius.circular(10),
        clockwise: false);
    path.quadraticBezierTo(
        size.width * 0.6, 0, size.width * 0.65, 0); // right curve
    path.quadraticBezierTo(size.width * 0.8, 0, size.width, 20); // right side
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
    path.close();
    canvas.drawPath(path, paint);
    // canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
