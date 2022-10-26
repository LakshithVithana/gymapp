import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/services/database.dart';
import 'package:gymapp/shared/loading.dart';

class QuestionPageLayerThreeNo extends StatefulWidget {
  const QuestionPageLayerThreeNo({Key? key}) : super(key: key);

  @override
  _QuestionPageLayerThreeNoState createState() =>
      _QuestionPageLayerThreeNoState();
}

class _QuestionPageLayerThreeNoState extends State<QuestionPageLayerThreeNo> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<OurUser?>(context);
    return StreamBuilder<UserDetails>(
        stream: DatabaseService(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;
            return Scaffold(
              backgroundColor: const Color(0xff154c79),
              appBar: AppBar(
                backgroundColor: const Color(0xff133957),
                title: const Text("Shorty"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width - 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Can you let go off the situation?",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "Can you debrief with ${userDetails!.sleepProblemAnswers != null ? userDetails.supportPersonName : ""} ?",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const Text(
                            "Or check out our service provider card for some extra supports.",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xffD90429),
                                ),
                              ),
                              child: const Text(
                                "Ok",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
