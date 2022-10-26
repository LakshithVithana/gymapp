import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfirEmail extends StatefulWidget {
  ConfirEmail({Key? key, this.message}) : super(key: key);
  static String id = 'confirm-email';
  final String? message;

  @override
  _ConfirEmailState createState() => _ConfirEmailState();

  // @override
  // startTime() async {
  //   var duration = new Duration(seconds: 6);
  //   return new Timer(duration, route);
  // }

  // route() {
  //   Get.to(LogIn());
  // }
}

class _ConfirEmailState extends State<ConfirEmail> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff154c79),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width * 0.7,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xffD90429),
                ),
              ),
              child: Text(
                'Back to LOG IN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // RestartWidget.restartApp(context);
                // Get.to(() => LogIn(toggleView: toggleView));
                // navigator.pushAndRemoveUntil(
                //     MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //             LogIn(toggleView: toggleView)),
                //     ModalRoute.withName('/'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class ConfirmEmail extends StatelessWidget {
//   static String id = 'confirm-email';
//   final String message;

//   const ConfirmEmail({Key key, this.message}) : super(key: key);

//   @override
//   startTime() async {
//     var duration = new Duration(seconds: 6);
//     return new Timer(duration, route);
//   }

//   route() {
//     Get.to(LogIn());
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff154c79),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   message,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: 50.0,
//             width: MediaQuery.of(context).size.width * 0.7,
//             child: ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(
//                   Color(0xffD90429),
//                 ),
//               ),
//               child: Text(
//                 'Back to LOG IN',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.0,
//                 ),
//               ),
//               onPressed: () {
//                 // Get.to(() => LogIn());
//                 Navigator.pushAndRemoveUntil(context,
//                     MaterialPageRoute(builder: (context) {
//                   return LogIn(toggleView: );
//                 }), (route) => false);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
