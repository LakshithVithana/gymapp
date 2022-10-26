import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/screens/home/user/questions/questionPageLayerTwo.dart';
import 'package:gymapp/services/database.dart';
import 'package:gymapp/shared/loading.dart';

class QuestionPageLayerOne extends StatefulWidget {
  const QuestionPageLayerOne({Key? key}) : super(key: key);

  @override
  _QuestionPageLayerOneState createState() => _QuestionPageLayerOneState();
}

class _QuestionPageLayerOneState extends State<QuestionPageLayerOne> {
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
                          Text(
                            "Hey, ${userDetails!.firstName} I noticed you are experiencing some${userDetails.problems.contains("sleepProblem1") || userDetails.problems.contains("sleepProblem2") ? ", Sleep Problems" : ""}${userDetails.problems.contains("lossOfMotivationProblem1") || userDetails.problems.contains("lossOfMotivationProblem2") ? ", Loss of Motivation Problems" : ""}${userDetails.problems.contains("energyLevelsProblem") ? ", Energy Levels Problems" : ""}${userDetails.problems.contains("closedOffProblem") ? ", Closed Off Problems" : ""}${userDetails.problems.contains("stressProblem1") || userDetails.problems.contains("stressProblem2") ? ", Stress Problems" : ""}${userDetails.problems.contains("sadnessProblem") ? ", Sadness Problems" : ""} at the moment, is everything okay?",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xff8d99ae),
                                    ),
                                  ),
                                  child: const Text(
                                    "No",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => const QuestionPageLayerTwo());
                                  },
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
                                    "Yes",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: const Text(
                                              'So glad to hear that!'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text(
                                                    'If those changes, be sure to let sombody know.'),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Ok"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
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
