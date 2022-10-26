import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'clubAdminRegisterRequest.dart';
import 'coachRegister.dart';
import 'userRegister.dart';

class RegisterSelection extends StatefulWidget {
  const RegisterSelection({Key? key, this.toggleView}) : super(key: key);
  final Function? toggleView;

  @override
  _RegisterSelectionState createState() => _RegisterSelectionState();
}

class _RegisterSelectionState extends State<RegisterSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff154c79),
      appBar: AppBar(
        backgroundColor: const Color(0xff133957),
        title: Text(
          'CHOICES',
          style: GoogleFonts.baiJamjuree(
            textStyle: Theme.of(context).textTheme.headline5,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('login'),
            onPressed: () {
              widget.toggleView!();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   height: 150.0,
            //   child: Image.asset('assets/images/logo.png'),
            // ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            const Text(
              'Are You a ?',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            const SizedBox(height: 25.0),
            SizedBox(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffD90429))),
                child: const Text(
                  'PLAYER',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Get.to(() => Register());
                },
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffD90429))),
                child: const Text(
                  'COACH',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Get.to(() => const CoachRegister());
                },
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffD90429))),
                child: const Text(
                  'CLUB ADMIN',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Get.to(() => ClubAdminRegisterRequest());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
