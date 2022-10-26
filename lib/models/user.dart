class OurUser {
  final String? uid;
  OurUser({this.uid});
}

class UserDetails {
  final String? uid;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? club;
  final String? gender;
  final bool? isUser;
  final bool? isCoach;
  final bool? isClubAdmin;
  final bool? isSuperAdmin;
  final bool? isDeleting;
  final bool? isPreQuestionAnswered;
  final dynamic problems;
  final dynamic sleepProblemAnswers;
  final dynamic energyLevelsProblemAnswers;
  final dynamic lessOfMotivationProblemAnswers;
  final dynamic closedOffProblemAnswers;
  final dynamic stressProblemAnswers;
  final dynamic sadnessProblemAnswers;
  final String? supportPersonName;
  final bool? unreadMessages;
  final bool? newMessageSent;

  UserDetails({
    this.uid,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.club,
    this.dateOfBirth,
    this.gender,
    this.isUser,
    this.isCoach,
    this.isClubAdmin,
    this.isSuperAdmin,
    this.isDeleting,
    this.isPreQuestionAnswered,
    this.problems,
    this.sleepProblemAnswers,
    this.energyLevelsProblemAnswers,
    this.lessOfMotivationProblemAnswers,
    this.closedOffProblemAnswers,
    this.stressProblemAnswers,
    this.sadnessProblemAnswers,
    this.supportPersonName,
    this.unreadMessages,
    this.newMessageSent,
  });
}

class UserRequest {
  final String? email;
  UserRequest({this.email});
}
