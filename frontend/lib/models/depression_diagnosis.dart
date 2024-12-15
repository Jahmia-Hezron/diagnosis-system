class PHQ9Diagnosis {
  final int userID;
  final int score;

  PHQ9Diagnosis({required this.userID, required this.score});

  Map<String, dynamic> toJson() => {
        'user_id': userID,
        'score': score,
      };
}
