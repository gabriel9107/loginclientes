import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          this.child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Column(
      //   children: [
      //     Image.network(
      //       // <-- SEE HERE
      //       'https://firebasestorage.googleapis.com/v0/b/sigaapp-127c4.appspot.com/o/Siga%20inicio.PNG?alt=media&token=b23f275a-b8f1-4656-9f1d-7127ace42ca4',
      //     ),
      //   ],
      // ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 50),
        // child: Icon(Icons.person_pin, color: Colors.white, size: 110),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: size.height * 0.4,
        decoration: _purpleBackground(),
        child: Stack(
          children: [
            // Positioned(child: _Bubble(), top: 90, left: 30),
            Positioned(child: _Bubble(), top: -40, left: 30),
            Positioned(child: _Bubble(), top: -50, right: 30),
            Positioned(child: _Bubble(), bottom: -50, left: 30),
            Positioned(child: _Bubble(), bottom: 120, right: 20),
          ],
        ));
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
          gradient: const LinearGradient(colors: [
        Color.fromARGB(255, 139, 211, 240),
        Color.fromARGB(255, 139, 211, 240),
      ]));
}

//  Color.fromRGBO(63, 63, 156, 1),
//       Color.fromRGBO(90, 70, 178, 1),
class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
