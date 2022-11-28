import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.calendar_today,
              size: 96,
            ),
            SizedBox(
              height: 16,
            ),
            SpinKitChasingDots(
              color: Colors.black,
              size: 50.0,
            ),
          ]),
    );
  }
}
