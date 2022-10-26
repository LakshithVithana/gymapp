import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/services/database.dart';
import 'package:gymapp/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class QuestionPageLayerThreeYes extends StatefulWidget {
  const QuestionPageLayerThreeYes({Key? key}) : super(key: key);

  @override
  _QuestionPageLayerThreeYesState createState() =>
      _QuestionPageLayerThreeYesState();
}

class _QuestionPageLayerThreeYesState extends State<QuestionPageLayerThreeYes> {
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
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width - 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Could you reach out to anyone about this?",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            // "Like${userDetails!.sleepProblemAnswers != null ? ", ${userDetails.sleepProblemAnswers['answerOne']}" : ""}${userDetails.energyLevelsProblemAnswers != null ? ", ${userDetails.energyLevelsProblemAnswers['answerOne']}" : ""}${userDetails.lessOfMotivationProblemAnswers != null ? ", ${userDetails.lessOfMotivationProblemAnswers['answerOne']}" : ""}${userDetails.closedOffProblemAnswers != null ? ", ${userDetails.closedOffProblemAnswers['answerOne']}" : ""}${userDetails.stressProblemAnswers != null ? ", ${userDetails.stressProblemAnswers['answerOne']}" : ""}${userDetails.sadnessProblemAnswers != null ? ", ${userDetails.sadnessProblemAnswers['answerOne']}" : ""} ?",
                            "Like${userDetails!.problems.contains("sleepProblem1") || userDetails.problems.contains("sleepProblem2") ? ", ${userDetails.sleepProblemAnswers['answerOne']}" : ""}${userDetails.problems.contains("lossOfMotivationProblem1") || userDetails.problems.contains("lossOfMotivationProblem2") ? ", ${userDetails.energyLevelsProblemAnswers['answerOne']}" : ""}${userDetails.problems.contains("energyLevelsProblem") ? ", ${userDetails.lessOfMotivationProblemAnswers['answerOne']}" : ""}${userDetails.problems.contains("closedOffProblem") ? ", ${userDetails.closedOffProblemAnswers['answerOne']}" : ""}${userDetails.problems.contains("stressProblem1") || userDetails.problems.contains("stressProblem2") ? ", ${userDetails.stressProblemAnswers['answerOne']}" : ""}${userDetails.problems.contains("sadnessProblem") ? ", ${userDetails.sadnessProblemAnswers['answerOne']}" : ""} ?",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "Or can you try${userDetails.problems.contains("sleepProblem1") || userDetails.problems.contains("sleepProblem2") ? ", ${userDetails.sleepProblemAnswers['answerTwo']}" : ""}${userDetails.problems.contains("lossOfMotivationProblem1") || userDetails.problems.contains("lossOfMotivationProblem2") ? ", ${userDetails.energyLevelsProblemAnswers['answerTwo']}" : ""}${userDetails.problems.contains("energyLevelsProblem") ? ", ${userDetails.lessOfMotivationProblemAnswers['answerTwo']}" : ""}${userDetails.problems.contains("closedOffProblem") ? ", ${userDetails.closedOffProblemAnswers['answerTwo']}" : ""}${userDetails.problems.contains("stressProblem1") || userDetails.problems.contains("stressProblem2") ? ", ${userDetails.stressProblemAnswers['answerTwo']}" : ""}${userDetails.problems.contains("sadnessProblem") ? ", ${userDetails.sadnessProblemAnswers['answerTwo']}" : ""} ?",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Or check out our service provider card for",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              GestureDetector(
                                child: const Text(
                                  'some extra supports.',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                onTap: () {
                                  _launchURL();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
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

_launchURL() async {
  const url = 'https://staychatty.com.au/get-help/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
