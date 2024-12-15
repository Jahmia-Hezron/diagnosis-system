class AQDiagnosis {
  final int userID;
  final int score;

  AQDiagnosis({required this.userID, required this.score});

  Map<String, dynamic> toJson() => {
        'user_id': userID,
        'score': score,
      };
}
