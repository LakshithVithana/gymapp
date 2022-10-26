import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/screens/home/user/questions/preQuestions/preQuestions.dart';
import 'package:gymapp/services/database.dart';
import 'package:gymapp/shared/loading.dart';
import 'package:gymapp/shared/text.dart';

class TrainingMonitor extends StatefulWidget {
  const TrainingMonitor({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  _TrainingMonitorState createState() => _TrainingMonitorState();
}

class _TrainingMonitorState extends State<TrainingMonitor> {
  CollectionReference trainingMonitorDetailsCollection =
      FirebaseFirestore.instance.collection('trainingMonitorDetails');
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool isLoading = false;

  double _lengthOfSleep = 0;
  double _qualityOfSleep = 0;
  double _energyLevels = 0;
  double _motivationForExercise = 0;
  double _feelingConnected = 0;
  double _stressLevels = 0;
  double _feelingCalm = 0;
  double _atitudeTowardsLearning = 0;
  double _feelingOptimistic = 0;

  // previous day data
  double _lengthOfSleep1 = 0;
  double _qualityOfSleep1 = 0;
  double _energyLevels1 = 0;
  double _motivationForExercise1 = 0;
  double _feelingConnected1 = 0;
  double _stressLevels1 = 0;
  double _feelingCalm1 = 0;
  double _atitudeTowardsLearning1 = 0;
  double _feelingOptimistic1 = 0;

  // day befor previous day data
  double _lengthOfSleep2 = 0;
  double _qualityOfSleep2 = 0;
  double _energyLevels2 = 0;
  double _motivationForExercise2 = 0;
  double _feelingConnected2 = 0;
  double _stressLevels2 = 0;
  double _feelingCalm2 = 0;
  double _atitudeTowardsLearning2 = 0;
  double _feelingOptimistic2 = 0;

  int days = 0;
  DateTime _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('dd');
  final _monthFormatter = DateFormat('MM');
  final _yearFormatter = DateFormat("yyyy");
  String _calculatedDate = "";
  String _calculatedDate1 = "";
  String _calculatedDate2 = "";

  String today = "";

  bool? isSleepQuestionsTriggered = false;
  bool? isEnergyLevelsQuestionsTriggered = false;
  bool? isLossOfMotivationQuestionsTriggered = false;
  bool? isClosedOffQuestionsTriggered = false;
  bool? isStressQuestionsTriggered = false;
  bool? isSadnessQuestionsTriggered = false;

  @override
  void initState() {
    today = _yearFormatter.format(DateTime.now()).toString() +
        _monthFormatter.format(DateTime.now()).toString() +
        _dayFormatter.format(DateTime.now()).toString();

    _calculatedDate = _yearFormatter.format(_currentDate).toString() +
        _monthFormatter.format(_currentDate).toString() +
        _dayFormatter.format(_currentDate).toString();

    _calculatedDate1 = _yearFormatter
            .format(_currentDate.add(const Duration(days: -1)))
            .toString() +
        _monthFormatter
            .format(_currentDate.add(const Duration(days: -1)))
            .toString() +
        _dayFormatter
            .format(_currentDate.add(const Duration(days: -1)))
            .toString();

    _calculatedDate2 = _yearFormatter
            .format(_currentDate.add(const Duration(days: -2)))
            .toString() +
        _monthFormatter
            .format(_currentDate.add(const Duration(days: -2)))
            .toString() +
        _dayFormatter
            .format(_currentDate.add(const Duration(days: -2)))
            .toString();

    trainingMonitorDetailsCollection.doc(widget.uid).get().then((snapshot) {
      if ((snapshot.data() as dynamic) == null) {
        trainingMonitorDetailsCollection.doc(widget.uid).set({
          _calculatedDate: {
            "lengthOfSleep": _lengthOfSleep,
            "qualityOfSleep": _qualityOfSleep,
            "energyLevels": _energyLevels,
            "motivationForExercise": _motivationForExercise,
            "feelingConnected": _feelingConnected,
            "stressLevels": _stressLevels,
            "feelingCalm": _feelingCalm,
            "atitudeTowardsLearning": _atitudeTowardsLearning,
            "feelingOptimistic": _feelingOptimistic,
          }
        });
      } else if ((snapshot.data() as dynamic)[_calculatedDate] == null) {
        trainingMonitorDetailsCollection.doc(widget.uid).update({
          _calculatedDate: {
            "lengthOfSleep": _lengthOfSleep,
            "qualityOfSleep": _qualityOfSleep,
            "energyLevels": _energyLevels,
            "motivationForExercise": _motivationForExercise,
            "feelingConnected": _feelingConnected,
            "stressLevels": _stressLevels,
            "feelingCalm": _feelingCalm,
            "atitudeTowardsLearning": _atitudeTowardsLearning,
            "feelingOptimistic": _feelingOptimistic,
          }
        });
      } else {
        setState(() {
          _lengthOfSleep =
              (snapshot.data() as dynamic)[_calculatedDate]["lengthOfSleep"];
          _qualityOfSleep =
              (snapshot.data() as dynamic)[_calculatedDate]["qualityOfSleep"];
          _energyLevels =
              (snapshot.data() as dynamic)[_calculatedDate]["energyLevels"];
          _motivationForExercise = (snapshot.data() as dynamic)[_calculatedDate]
              ["motivationForExercise"];
          _feelingConnected =
              (snapshot.data() as dynamic)[_calculatedDate]["feelingConnected"];
          _stressLevels =
              (snapshot.data() as dynamic)[_calculatedDate]["stressLevels"];
          _feelingCalm =
              (snapshot.data() as dynamic)[_calculatedDate]["feelingCalm"];
          _atitudeTowardsLearning = (snapshot.data()
              as dynamic)[_calculatedDate]["atitudeTowardsLearning"];
          _feelingOptimistic = (snapshot.data() as dynamic)[_calculatedDate]
              ["feelingOptimistic"];
          days = 0;
        });
      }
      if ((snapshot.data() as dynamic)[_calculatedDate1] != null) {
        _lengthOfSleep1 =
            (snapshot.data() as dynamic)[_calculatedDate1]["lengthOfSleep"];
        _qualityOfSleep1 =
            (snapshot.data() as dynamic)[_calculatedDate1]["qualityOfSleep"];
        _energyLevels1 =
            (snapshot.data() as dynamic)[_calculatedDate1]["energyLevels"];
        _motivationForExercise1 = (snapshot.data() as dynamic)[_calculatedDate1]
            ["motivationForExercise"];
        _feelingConnected1 =
            (snapshot.data() as dynamic)[_calculatedDate1]["feelingConnected"];
        _stressLevels1 =
            (snapshot.data() as dynamic)[_calculatedDate1]["stressLevels"];
        _feelingCalm1 =
            (snapshot.data() as dynamic)[_calculatedDate1]["feelingCalm"];
        _atitudeTowardsLearning1 = (snapshot.data()
            as dynamic)[_calculatedDate1]["atitudeTowardsLearning"];
        _feelingOptimistic1 =
            (snapshot.data() as dynamic)[_calculatedDate1]["feelingOptimistic"];
      }
      if ((snapshot.data() as dynamic)[_calculatedDate2] != null) {
        _lengthOfSleep2 =
            (snapshot.data() as dynamic)[_calculatedDate2]["lengthOfSleep"];
        _qualityOfSleep2 =
            (snapshot.data() as dynamic)[_calculatedDate2]["qualityOfSleep"];
        _energyLevels2 =
            (snapshot.data() as dynamic)[_calculatedDate2]["energyLevels"];
        _motivationForExercise2 = (snapshot.data() as dynamic)[_calculatedDate2]
            ["motivationForExercise"];
        _feelingConnected2 =
            (snapshot.data() as dynamic)[_calculatedDate2]["feelingConnected"];
        _stressLevels2 =
            (snapshot.data() as dynamic)[_calculatedDate2]["stressLevels"];
        _feelingCalm2 =
            (snapshot.data() as dynamic)[_calculatedDate2]["feelingCalm"];
        _atitudeTowardsLearning2 = (snapshot.data()
            as dynamic)[_calculatedDate2]["atitudeTowardsLearning"];
        _feelingOptimistic2 =
            (snapshot.data() as dynamic)[_calculatedDate2]["feelingOptimistic"];
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calculatedDate = _yearFormatter.format(_currentDate).toString() +
        _monthFormatter.format(_currentDate).toString() +
        _dayFormatter.format(_currentDate).toString();

    _previousDate() {
      trainingMonitorDetailsCollection.doc(widget.uid).get().then((snapshot) {
        print((snapshot.data() as dynamic)[_calculatedDate]);
        if ((snapshot.data() as dynamic)[(_yearFormatter
                    .format(_currentDate.add(const Duration(days: -1)))
                    .toString() +
                _monthFormatter
                    .format(_currentDate.add(const Duration(days: -1)))
                    .toString() +
                _dayFormatter
                    .format(_currentDate.add(const Duration(days: -1)))
                    .toString())] !=
            null) {
          days--;
          setState(() {
            _currentDate = _currentDate.add(Duration(days: days));
            _calculatedDate = _yearFormatter.format(_currentDate).toString() +
                _monthFormatter.format(_currentDate).toString() +
                _dayFormatter.format(_currentDate).toString();
          });

          setState(() {
            _lengthOfSleep =
                (snapshot.data() as dynamic)[_calculatedDate]["lengthOfSleep"];
            _qualityOfSleep =
                (snapshot.data() as dynamic)[_calculatedDate]["qualityOfSleep"];
            _energyLevels =
                (snapshot.data() as dynamic)[_calculatedDate]["energyLevels"];
            _motivationForExercise = (snapshot.data()
                as dynamic)[_calculatedDate]["motivationForExercise"];
            _feelingConnected = (snapshot.data() as dynamic)[_calculatedDate]
                ["feelingConnected"];
            _stressLevels =
                (snapshot.data() as dynamic)[_calculatedDate]["stressLevels"];
            _feelingCalm =
                (snapshot.data() as dynamic)[_calculatedDate]["feelingCalm"];
            _atitudeTowardsLearning = (snapshot.data()
                as dynamic)[_calculatedDate]["atitudeTowardsLearning"];
            _feelingOptimistic = (snapshot.data() as dynamic)[_calculatedDate]
                ["feelingOptimistic"];
            days = 0;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No more previous records."),
          ));
        }
      });
      print(_calculatedDate);
      print(days);
    }

    _nextDate() {
      trainingMonitorDetailsCollection.doc(widget.uid).get().then((snapshot) {
        print((snapshot.data() as dynamic)[_calculatedDate]);

        if ((snapshot.data() as dynamic)[(_yearFormatter
                    .format(_currentDate.add(const Duration(days: 1)))
                    .toString() +
                _monthFormatter
                    .format(_currentDate.add(const Duration(days: 1)))
                    .toString() +
                _dayFormatter
                    .format(_currentDate.add(const Duration(days: 1)))
                    .toString())] !=
            null) {
          days++;
          setState(() {
            _currentDate = _currentDate.add(Duration(days: days));
            _calculatedDate = _yearFormatter.format(_currentDate).toString() +
                _monthFormatter.format(_currentDate).toString() +
                _dayFormatter.format(_currentDate).toString();
          });

          setState(() {
            _lengthOfSleep =
                (snapshot.data() as dynamic)[_calculatedDate]["lengthOfSleep"];
            _qualityOfSleep =
                (snapshot.data() as dynamic)[_calculatedDate]["qualityOfSleep"];
            _energyLevels =
                (snapshot.data() as dynamic)[_calculatedDate]["energyLevels"];
            _motivationForExercise = (snapshot.data()
                as dynamic)[_calculatedDate]["motivationForExercise"];
            _feelingConnected = (snapshot.data() as dynamic)[_calculatedDate]
                ["feelingConnected"];
            _stressLevels =
                (snapshot.data() as dynamic)[_calculatedDate]["stressLevels"];
            _feelingCalm =
                (snapshot.data() as dynamic)[_calculatedDate]["feelingCalm"];
            _atitudeTowardsLearning = (snapshot.data()
                as dynamic)[_calculatedDate]["atitudeTowardsLearning"];
            _feelingOptimistic = (snapshot.data() as dynamic)[_calculatedDate]
                ["feelingOptimistic"];
            days = 0;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No more further records."),
          ));
        }
      });
      print(_calculatedDate);
      print(days);
    }

    return StreamBuilder<UserDetails>(
        stream: DatabaseService(uid: widget.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;
            return Scaffold(
              backgroundColor: const Color(0xff154c79),
              appBar: AppBar(
                backgroundColor: const Color(0xff133957),
                title: Text(
                  'TRAINING MONITOR',
                  style: GoogleFonts.baiJamjuree(),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 55.0,
                            width: MediaQuery.of(context).size.width / 5,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xffD90429),
                                ),
                              ),
                              child: const Icon(
                                Icons.chevron_left,
                                size: 45.0,
                              ),
                              onPressed: () {
                                _previousDate();
                              },
                            ),
                          ),
                          Container(
                            height: 55.0,
                            width: MediaQuery.of(context).size.width / 5 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: TextBox(
                                textValue:
                                    "${_yearFormatter.format(_currentDate)}/${_monthFormatter.format(_currentDate)}/${_dayFormatter.format(_currentDate)}",
                                textSize: 7,
                                textWeight: FontWeight.normal,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              // Text(
                              //   _yearFormatter.format(_currentDate).toString() +
                              //       "/" +
                              //       _monthFormatter
                              //           .format(_currentDate)
                              //           .toString() +
                              //       "/" +
                              //       _dayFormatter
                              //           .format(_currentDate)
                              //           .toString(),
                              //   style: TextStyle(fontSize: 24.0),
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 55.0,
                            width: MediaQuery.of(context).size.width / 5,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xffD90429),
                                ),
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                size: 45.0,
                              ),
                              onPressed: () {
                                _nextDate();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.23,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Length of sleep',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  TextBox(
                                    textValue: 'hours',
                                    textSize: 5,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextBox(
                                          textValue: '<3',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '4',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '5',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '6',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '7',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '8',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '9',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '10',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '11',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                        TextBox(
                                          textValue: '>12',
                                          textSize: 4,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.center,
                                          captionAlign: TextAlign.center,
                                          textColor: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Slider(
                                    value: _lengthOfSleep,
                                    min: 0,
                                    max: 9,
                                    divisions: 9,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _lengthOfSleep = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-5',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-4',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-3',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('3',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('4',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Quality of sleep',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'restless',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'normal',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'very deep',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _qualityOfSleep,
                                    min: 0,
                                    max: 2,
                                    divisions: 2,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _qualityOfSleep = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Energy levels',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'exhausted',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'low',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'normal',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'high',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'very high',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _energyLevels,
                                    min: 0,
                                    max: 4,
                                    divisions: 4,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _energyLevels = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Motivation for exercise',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'not at all',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'low',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'average',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'above avg.',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'high',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _motivationForExercise,
                                    min: 0,
                                    max: 4,
                                    divisions: 4,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _motivationForExercise = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Feeling connected',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'discon.',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'not con.',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'average',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'connected',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'very con.',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _feelingConnected,
                                    min: 0,
                                    max: 4,
                                    divisions: 4,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _feelingConnected = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Stress levels',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'not coping',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'reacting',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'coping',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _stressLevels,
                                    min: 0,
                                    max: 2,
                                    divisions: 2,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _stressLevels = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-5',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Feeling calm',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'agitated',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'not calm',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'average',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'calm',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'very calm',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _feelingCalm,
                                    min: 0,
                                    max: 4,
                                    divisions: 4,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _feelingCalm = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Attitude towards learning',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'very poor',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'poor',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'normal',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'good',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'very good',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _atitudeTowardsLearning,
                                    min: 0,
                                    max: 4,
                                    divisions: 4,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _atitudeTowardsLearning = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('1',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width - 8.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextBox(
                                textValue: 'Feeling optimistic',
                                textSize: 6,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.center,
                                textColor: Colors.black,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBox(
                                        textValue: 'very poor',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'poor',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'normal',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'good',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                      TextBox(
                                        textValue: 'very good',
                                        textSize: 4,
                                        textWeight: FontWeight.normal,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _feelingOptimistic,
                                    min: 0,
                                    max: 4,
                                    divisions: 4,
                                    onChanged: _calculatedDate == today
                                        ? (double value) {
                                            setState(() {
                                              _feelingOptimistic = value;
                                            });
                                            // trainingMonitorDetailsCollection
                                            //     .doc(widget.uid)
                                            //     .update({
                                            //   _calculatedDate: {
                                            //     "lengthOfSleep": _lengthOfSleep,
                                            //     "qualityOfSleep": _qualityOfSleep,
                                            //     "energyLevels": _energyLevels,
                                            //     "motivationForExercise":
                                            //         _motivationForExercise,
                                            //     "feelingConnected": _feelingConnected,
                                            //     "stressLevels": _stressLevels,
                                            //     "feelingCalm": _feelingCalm,
                                            //     "atitudeTowardsLearning":
                                            //         _atitudeTowardsLearning,
                                            //     "feelingOptimistic": _feelingOptimistic,
                                            //   }
                                            // });
                                          }
                                        : null,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text('-6',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-4',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('-2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('0',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //       Text('2',
                                  //           style:
                                  //               TextStyle(color: Colors.grey)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Text("points",
                                  //     style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      _calculatedDate == today
                          ? SizedBox(
                              height: 55.0,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color(0xffD90429),
                                  ),
                                ),
                                onPressed: _calculatedDate == today
                                    ? () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await trainingMonitorDetailsCollection
                                            .doc(widget.uid)
                                            .update({
                                          _calculatedDate: {
                                            "lengthOfSleep": _lengthOfSleep,
                                            "qualityOfSleep": _qualityOfSleep,
                                            "energyLevels": _energyLevels,
                                            "motivationForExercise":
                                                _motivationForExercise,
                                            "feelingConnected":
                                                _feelingConnected,
                                            "stressLevels": _stressLevels,
                                            "feelingCalm": _feelingCalm,
                                            "atitudeTowardsLearning":
                                                _atitudeTowardsLearning,
                                            "feelingOptimistic":
                                                _feelingOptimistic,
                                          }
                                        });
                                        if ((_lengthOfSleep2 <= 2 &&
                                                _lengthOfSleep1 <= 2 &&
                                                _lengthOfSleep <= 2) ||
                                            _lengthOfSleep == 0) {
                                          setState(() {
                                            isSleepQuestionsTriggered = true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['sleepProblem1']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['sleepProblem1']),
                                          });
                                        }
                                        if ((_qualityOfSleep2 == 0 &&
                                                _qualityOfSleep1 == 0 &&
                                                _qualityOfSleep == 0) ||
                                            _qualityOfSleep == 0) {
                                          setState(() {
                                            isSleepQuestionsTriggered = true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['sleepProblem2']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['sleepProblem2']),
                                          });
                                        }
                                        if ((_energyLevels2 <= 1 &&
                                                _energyLevels1 <= 1 &&
                                                _energyLevels <= 1) ||
                                            _energyLevels == 0) {
                                          setState(() {
                                            isEnergyLevelsQuestionsTriggered =
                                                true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['energyLevelsProblem']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['energyLevelsProblem']),
                                          });
                                        }
                                        if ((_motivationForExercise2 <= 1 &&
                                                _motivationForExercise1 <= 1 &&
                                                _motivationForExercise <= 1) ||
                                            _motivationForExercise == 0) {
                                          setState(() {
                                            isLossOfMotivationQuestionsTriggered =
                                                true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['lossOfMotivationProblem1']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['lossOfMotivationProblem1']),
                                          });
                                        }
                                        if ((_feelingConnected2 <= 1 &&
                                                _feelingConnected1 <= 1 &&
                                                _feelingConnected <= 1) ||
                                            _feelingConnected == 0) {
                                          setState(() {
                                            isClosedOffQuestionsTriggered =
                                                true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['closedOffProblem']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['closedOffProblem']),
                                          });
                                        }
                                        if ((_stressLevels2 <= 1 &&
                                                _stressLevels1 <= 1 &&
                                                _stressLevels <= 1) ||
                                            _stressLevels == 0) {
                                          setState(() {
                                            isStressQuestionsTriggered = true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['stressProblem1']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['stressProblem1']),
                                          });
                                        }
                                        if ((_feelingCalm2 <= 1 &&
                                                _feelingCalm1 <= 1 &&
                                                _feelingCalm <= 1) ||
                                            _feelingCalm == 0) {
                                          setState(() {
                                            isStressQuestionsTriggered = true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['stressProblem2']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['stressProblem2']),
                                          });
                                        }
                                        if (_atitudeTowardsLearning2 <= 1 &&
                                                _atitudeTowardsLearning1 <= 1 &&
                                                _atitudeTowardsLearning <= 1 ||
                                            _atitudeTowardsLearning == 0) {
                                          setState(() {
                                            isLossOfMotivationQuestionsTriggered =
                                                true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['lossOfMotivationProblem2']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['lossOfMotivationProblem2']),
                                          });
                                        }
                                        if ((_feelingOptimistic2 <= 1 &&
                                                _feelingOptimistic1 <= 1 &&
                                                _feelingOptimistic <= 1) ||
                                            _feelingOptimistic == 0) {
                                          setState(() {
                                            isSadnessQuestionsTriggered = true;
                                          });
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayUnion(
                                                ['sadnessProblem']),
                                          });
                                        } else {
                                          userCollection
                                              .doc(widget.uid)
                                              .update({
                                            "problems": FieldValue.arrayRemove(
                                                ['sadnessProblem']),
                                          });
                                        }
                                        if ((_lengthOfSleep2 <= 2 &&
                                                _lengthOfSleep1 <= 2 &&
                                                _lengthOfSleep <= 2) ||
                                            (_qualityOfSleep2 == 0 &&
                                                _qualityOfSleep1 == 0 &&
                                                _qualityOfSleep == 0) ||
                                            (_energyLevels2 <= 1 &&
                                                _energyLevels1 <= 1 &&
                                                _energyLevels <= 1) ||
                                            (_motivationForExercise2 <= 1 &&
                                                _motivationForExercise1 <= 1 &&
                                                _motivationForExercise <= 1) ||
                                            (_feelingConnected2 <= 1 &&
                                                _feelingConnected1 <= 1 &&
                                                _feelingConnected <= 1) ||
                                            (_stressLevels2 <= 1 &&
                                                _stressLevels1 <= 1 &&
                                                _stressLevels <= 1) ||
                                            (_feelingCalm2 <= 1 &&
                                                _feelingCalm1 <= 1 &&
                                                _feelingCalm <= 1) ||
                                            (_atitudeTowardsLearning2 <= 1 &&
                                                _atitudeTowardsLearning1 <= 1 &&
                                                _atitudeTowardsLearning <= 1) ||
                                            (_feelingOptimistic2 <= 1 &&
                                                _feelingOptimistic1 <= 1 &&
                                                _feelingOptimistic <= 1) ||
                                            _lengthOfSleep == 0 ||
                                            _energyLevels == 0 ||
                                            _motivationForExercise == 0 ||
                                            _feelingConnected == 0 ||
                                            _stressLevels == 0 ||
                                            _feelingCalm == 0 ||
                                            _atitudeTowardsLearning == 0 ||
                                            _feelingOptimistic == 0) {
                                          print("red flag");
                                        }
                                        if (userDetails!
                                                .isPreQuestionAnswered ==
                                            false) {
                                          Get.to(() => const PreQuestions(
                                                isSleepQuestionsTriggered: true,
                                                isClosedOffQuestionsTriggered:
                                                    true,
                                                isEnergyLevelsQuestionsTriggered:
                                                    true,
                                                isLossOfMotivationQuestionsTriggered:
                                                    true,
                                                isSadnessQuestionsTriggered:
                                                    true,
                                                isStressQuestionsTriggered:
                                                    true,
                                              ));
                                        }

                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (userDetails.isPreQuestionAnswered ==
                                            true) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    : null,
                                child: isLoading == false
                                    ? TextBox(
                                        textValue: 'DONE',
                                        textSize: 6,
                                        textWeight: FontWeight.bold,
                                        typeAlign: Alignment.center,
                                        captionAlign: TextAlign.center,
                                        textColor: Colors.white,
                                      )
                                    : const CircularProgressIndicator(
                                        backgroundColor: Color(0xffD90429),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08),
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
