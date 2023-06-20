import 'package:flutter/material.dart';

class VShapedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0); //top-left
    path.lineTo(0,size.height); //bottom-left
    path.lineTo(size.width, size.height); //bottom-right
    path.lineTo(size.width, 0); //top-right
    path.lineTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(VShapedClipper oldClipper) => false;
}

class MyShape extends StatelessWidget {
  final int number;

  const MyShape({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 110,
      child: ClipPath(
        clipper: VShapedClipper(),
        child: Container(
          padding: const EdgeInsets.only(top: 40),
          color: Colors.white,
          child: Center(
            child: Text(number.toString(), style: const TextStyle(fontSize: 30)),
          ),
        ),
      ),
    );
  }
}

