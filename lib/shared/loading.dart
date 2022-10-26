import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff154c79),
      child: Center(
        child: SpinKitThreeBounce(
          color: Color(0xffD90429),
          size: 50.0,
        ),
      ),
    );
  }
}
