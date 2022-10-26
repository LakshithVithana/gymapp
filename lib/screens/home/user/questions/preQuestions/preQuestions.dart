import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/services/database.dart';
import 'package:gymapp/shared/constants.dart';
import 'package:gymapp/shared/loading.dart';

CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');

class PreQuestions extends StatefulWidget {
  const PreQuestions({
    Key? key,
    this.isSleepQuestionsTriggered,
    this.isEnergyLevelsQuestionsTriggered,
    this.isLossOfMotivationQuestionsTriggered,
    this.isSadnessQuestionsTriggered,
    this.isClosedOffQuestionsTriggered,
    this.isStressQuestionsTriggered,
  }) : super(key: key);

  final bool? isSleepQuestionsTriggered;
  final bool? isEnergyLevelsQuestionsTriggered;
  final bool? isLossOfMotivationQuestionsTriggered;
  final bool? isSadnessQuestionsTriggered;
  final bool? isClosedOffQuestionsTriggered;
  final bool? isStressQuestionsTriggered;

  @override
  _PreQuestionsState createState() => _PreQuestionsState();
}

class _PreQuestionsState extends State<PreQuestions> {
  bool? isSleep = false;
  bool? isEnergyLevels = false;
  bool? isLossOfMotivation = false;
  bool? isSadness = false;
  bool? isClossedOff = false;
  bool? isStress = false;

  @override
  void dispose() {
    isSleep = false;
    isEnergyLevels = false;
    isLossOfMotivation = false;
    isSadness = false;
    isClossedOff = false;
    isStress = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isSleepQuestionsTriggered);
    print(widget.isEnergyLevelsQuestionsTriggered);
    print(widget.isLossOfMotivationQuestionsTriggered);
    print(widget.isClosedOffQuestionsTriggered);
    print(widget.isStressQuestionsTriggered);
    print(widget.isSadnessQuestionsTriggered);
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
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hi,",
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      ),
                      const SizedBox(height: 10.0),
                      widget.isSleepQuestionsTriggered == true
                          ? SleepQuestions(uid: userDetails!.uid)
                          : Container(),
                      const SizedBox(height: 10.0),
                      widget.isEnergyLevelsQuestionsTriggered == true
                          ? EnergyLevelsQuestions(uid: userDetails!.uid)
                          : Container(),
                      const SizedBox(height: 10.0),
                      widget.isLossOfMotivationQuestionsTriggered == true
                          ? LossOfMotivationQuestions(uid: userDetails!.uid)
                          : Container(),
                      const SizedBox(height: 10.0),
                      widget.isClosedOffQuestionsTriggered == true
                          ? ClossedOffQuestions(uid: userDetails!.uid)
                          : Container(),
                      const SizedBox(height: 10.0),
                      widget.isStressQuestionsTriggered == true
                          ? StressQuestions(uid: userDetails!.uid)
                          : Container(),
                      const SizedBox(height: 10.0),
                      widget.isSadnessQuestionsTriggered == true
                          ? SadnessQuestions(uid: userDetails!.uid)
                          : Container(),
                      const SizedBox(height: 10.0),
                      SupportPerson(uid: userDetails!.uid),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        height: 55.0,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffD90429))),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            await userCollection.doc(userDetails.uid).update({
                              "isPreQuestionAnswered": true,
                            });

                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
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

class SleepQuestions extends StatefulWidget {
  const SleepQuestions({Key? key, @required this.uid}) : super(key: key);
  final String? uid;

  @override
  _SleepQuestionsState createState() => _SleepQuestionsState();
}

class _SleepQuestionsState extends State<SleepQuestions> {
  final _formKey = GlobalKey<FormState>();
  bool? _loading = false;

  String? answerOne = "";
  String? answerTwo = "";
  bool? isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.51,
      width: MediaQuery.of(context).size.width - 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "When you aren’t sleeping, what do you need from others?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerOne = val;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                "When you aren’t sleeping, what is something positive you can you do about it?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerTwo = val;
                  });
                },
              ),
              // SizedBox(height: 30.0),
              // Text(
              //   "If you wanted to get something off your chest or let someone know you might be struggling, who would that person be?",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // SizedBox(height: 15.0),
              // TextFormField(
              //   enabled: !isAnswered!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your answer' : null,
              //   decoration: textInputDecoration.copyWith(
              //     hintText: 'Your answer',
              //   ),
              //   onChanged: (val) {
              //     setState(() {
              //       supportPersonName = val;
              //     });
              //   },
              // ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD90429))),
                  onPressed: isAnswered == false
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await userCollection.doc(widget.uid).update({
                            "sleepProblemAnswers": {
                              "answerOne": answerOne,
                              "answerTwo": answerTwo,
                            }
                          });
                          setState(() {
                            _loading = false;
                            isAnswered = true;
                          });
                        }
                      : null,
                  child: _loading == false
                      ? isAnswered == false
                          ? const Text(
                              'Submit Answers',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.done, size: 40.0)
                      : const CircularProgressIndicator(
                          backgroundColor: Color(0xffD90429),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnergyLevelsQuestions extends StatefulWidget {
  const EnergyLevelsQuestions({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  _EnergyLevelsQuestionsState createState() => _EnergyLevelsQuestionsState();
}

class _EnergyLevelsQuestionsState extends State<EnergyLevelsQuestions> {
  final _formKey = GlobalKey<FormState>();
  bool? _loading = false;

  String? answerOne = "";
  String? answerTwo = "";
  // String? supportPersonName = "";
  bool? isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.51,
      width: MediaQuery.of(context).size.width - 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "When you are exhausted, what do you need from others?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerOne = val;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                "When you are exhausted, what is something positive you can you do about it?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerTwo = val;
                  });
                },
              ),
              // SizedBox(height: 30.0),
              // Text(
              //   "If you wanted to get something off your chest or let someone know you might be struggling, who would that person be?",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // SizedBox(height: 15.0),
              // TextFormField(
              //   enabled: !isAnswered!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your answer' : null,
              //   decoration: textInputDecoration.copyWith(
              //     hintText: 'Your answer',
              //   ),
              //   onChanged: (val) {
              //     setState(() {
              //       supportPersonName = val;
              //     });
              //   },
              // ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD90429))),
                  onPressed: isAnswered == false
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await userCollection.doc(widget.uid).update({
                            "energyLevelsProblemAnswers": {
                              "answerOne": answerOne,
                              "answerTwo": answerTwo,
                              // "supportPersonName": supportPersonName,
                            }
                          });
                          setState(() {
                            _loading = false;
                            isAnswered = true;
                          });
                        }
                      : null,
                  child: _loading == false
                      ? isAnswered == false
                          ? const Text(
                              'Submit Answers',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.done, size: 40.0)
                      : const CircularProgressIndicator(
                          backgroundColor: Color(0xffD90429),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LossOfMotivationQuestions extends StatefulWidget {
  const LossOfMotivationQuestions({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  _LossOfMotivationQuestionsState createState() =>
      _LossOfMotivationQuestionsState();
}

class _LossOfMotivationQuestionsState extends State<LossOfMotivationQuestions> {
  final _formKey = GlobalKey<FormState>();
  bool? _loading = false;

  String? answerOne = "";
  String? answerTwo = "";
  // String? supportPersonName = "";
  bool? isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.51,
      width: MediaQuery.of(context).size.width - 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "When you lose motivation, what do you need from others?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerOne = val;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                "When you lose motivation, what is something positive can you do about it?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerTwo = val;
                  });
                },
              ),
              // SizedBox(height: 30.0),
              // Text(
              //   "If you wanted to get something off your chest or let someone know you might be struggling, who would that person be?",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // SizedBox(height: 15.0),
              // TextFormField(
              //   enabled: !isAnswered!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your answer' : null,
              //   decoration: textInputDecoration.copyWith(
              //     hintText: 'Your answer',
              //   ),
              //   onChanged: (val) {
              //     setState(() {
              //       supportPersonName = val;
              //     });
              //   },
              // ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD90429))),
                  onPressed: isAnswered == false
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await userCollection.doc(widget.uid).update({
                            "lessOfMotivationProblemAnswers": {
                              "answerOne": answerOne,
                              "answerTwo": answerTwo,
                              // "supportPersonName": supportPersonName,
                            }
                          });
                          setState(() {
                            _loading = false;
                            isAnswered = true;
                          });
                        }
                      : null,
                  child: _loading == false
                      ? isAnswered == false
                          ? const Text(
                              'Submit Answers',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.done, size: 40.0)
                      : const CircularProgressIndicator(
                          backgroundColor: Color(0xffD90429),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClossedOffQuestions extends StatefulWidget {
  const ClossedOffQuestions({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  _ClossedOffQuestionsState createState() => _ClossedOffQuestionsState();
}

class _ClossedOffQuestionsState extends State<ClossedOffQuestions> {
  final _formKey = GlobalKey<FormState>();
  bool? _loading = false;

  String? answerOne = "";
  String? answerTwo = "";
  // String? supportPersonName = "";
  bool? isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.51,
      width: MediaQuery.of(context).size.width - 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "When you feel closed off or isolated, what do you need form others?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerOne = val;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                "When you feel closed off or isolated, what is something positive you can you do about it?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerTwo = val;
                  });
                },
              ),
              // SizedBox(height: 30.0),
              // Text(
              //   "If you wanted to get something off your chest or let someone know you might be struggling, who would that person be?",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // SizedBox(height: 15.0),
              // TextFormField(
              //   enabled: !isAnswered!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your answer' : null,
              //   decoration: textInputDecoration.copyWith(
              //     hintText: 'Your answer',
              //   ),
              //   onChanged: (val) {
              //     setState(() {
              //       supportPersonName = val;
              //     });
              //   },
              // ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD90429))),
                  onPressed: isAnswered == false
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await userCollection.doc(widget.uid).update({
                            "closedOffProblemAnswers": {
                              "answerOne": answerOne,
                              "answerTwo": answerTwo,
                              // "supportPersonName": supportPersonName,
                            }
                          });
                          setState(() {
                            _loading = false;
                            isAnswered = true;
                          });
                        }
                      : null,
                  child: _loading == false
                      ? isAnswered == false
                          ? const Text(
                              'Submit Answers',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.done, size: 40.0)
                      : const CircularProgressIndicator(
                          backgroundColor: Color(0xffD90429),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StressQuestions extends StatefulWidget {
  const StressQuestions({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  _StressQuestionsState createState() => _StressQuestionsState();
}

class _StressQuestionsState extends State<StressQuestions> {
  final _formKey = GlobalKey<FormState>();
  bool? _loading = false;

  String? answerOne = "";
  String? answerTwo = "";
  // String? supportPersonName = "";
  bool? isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.51,
      width: MediaQuery.of(context).size.width - 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "When you are stressed, what do you need from others?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerOne = val;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                "When you are stressed, what is something positive you can you do about it?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerTwo = val;
                  });
                },
              ),
              // SizedBox(height: 30.0),
              // Text(
              //   "If you wanted to get something off your chest or let someone know you might be struggling, who would that person be?",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // SizedBox(height: 15.0),
              // TextFormField(
              //   enabled: !isAnswered!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your answer' : null,
              //   decoration: textInputDecoration.copyWith(
              //     hintText: 'Your answer',
              //   ),
              //   onChanged: (val) {
              //     setState(() {
              //       supportPersonName = val;
              //     });
              //   },
              // ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD90429))),
                  onPressed: isAnswered == false
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await userCollection.doc(widget.uid).update({
                            "stressProblemAnswers": {
                              "answerOne": answerOne,
                              "answerTwo": answerTwo,
                              // "supportPersonName": supportPersonName,
                            }
                          });
                          setState(() {
                            _loading = false;
                            isAnswered = true;
                          });
                        }
                      : null,
                  child: _loading == false
                      ? isAnswered == false
                          ? const Text(
                              'Submit Answers',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.done, size: 40.0)
                      : const CircularProgressIndicator(
                          backgroundColor: Color(0xffD90429),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SadnessQuestions extends StatefulWidget {
  const SadnessQuestions({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  _SadnessQuestionsState createState() => _SadnessQuestionsState();
}

class _SadnessQuestionsState extends State<SadnessQuestions> {
  final _formKey = GlobalKey<FormState>();
  bool? _loading = false;

  String? answerOne = "";
  String? answerTwo = "";
  // String? supportPersonName = "";
  bool? isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width - 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "When you feel sad, what do you need from others?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerOne = val;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                "When you feel sad, what is something positive you can you do about it?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    answerTwo = val;
                  });
                },
              ),
              // SizedBox(height: 30.0),
              // Text(
              //   "If you wanted to get something off your chest or let someone know you might be struggling, who would that person be?",
              //   style: TextStyle(fontSize: 18.0),
              // ),
              // SizedBox(height: 15.0),
              // TextFormField(
              //   enabled: !isAnswered!,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please enter your answer' : null,
              //   decoration: textInputDecoration.copyWith(
              //     hintText: 'Your answer',
              //   ),
              //   onChanged: (val) {
              //     setState(() {
              //       supportPersonName = val;
              //     });
              //   },
              // ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD90429))),
                  onPressed: isAnswered == false
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await userCollection.doc(widget.uid).update({
                            "sadnessProblemAnswers": {
                              "answerOne": answerOne,
                              "answerTwo": answerTwo,
                              // "supportPersonName": supportPersonName,
                            }
                          });
                          setState(() {
                            _loading = false;
                            isAnswered = true;
                          });
                        }
                      : null,
                  child: _loading == false
                      ? isAnswered == false
                          ? const Text(
                              'Submit Answers',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.done, size: 40.0)
                      : const CircularProgressIndicator(
                          backgroundColor: Color(0xffD90429),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SupportPerson extends StatefulWidget {
  const SupportPerson({Key? key, this.uid}) : super(key: key);
  final String? uid;

  @override
  _SupportPersonState createState() => _SupportPersonState();
}

class _SupportPersonState extends State<SupportPerson> {
  final _formKey = GlobalKey<FormState>();
  bool? _loading = false;
  String? supportPersonName = "";
  bool? isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width - 8.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // SizedBox(height: 30.0),
              const Text(
                "If you wanted to get something off your chest or let someone know you might be struggling, who would that person be?",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                enabled: !isAnswered!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your answer' : null,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Your answer',
                ),
                onChanged: (val) {
                  setState(() {
                    supportPersonName = val;
                  });
                },
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD90429))),
                  onPressed: isAnswered == false
                      ? () async {
                          setState(() {
                            _loading = true;
                          });
                          await userCollection.doc(widget.uid).update({
                            "supportPersonName": supportPersonName,
                          });
                          setState(() {
                            _loading = false;
                            isAnswered = true;
                          });
                        }
                      : null,
                  child: _loading == false
                      ? isAnswered == false
                          ? const Text(
                              'Submit Answers',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.done, size: 40.0)
                      : const CircularProgressIndicator(
                          backgroundColor: Color(0xffD90429),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
