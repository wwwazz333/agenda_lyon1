import 'package:flutter/material.dart';

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
              size: 64,
            ),
            SizedBox(
              height: 16,
            ),
            CircularProgressIndicator(),
          ]),
    );
  }
}
