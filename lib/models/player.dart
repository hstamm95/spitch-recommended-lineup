class Player {
  final String? id;
  final bool active;
  final int avgScore;
  final String firstName;
  final String lastName;
  final String position;
  final bool injured;

  const Player({
    required this.id,
    required this.active,
    required this.avgScore,
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.injured,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      active: json['active'] as bool,
      avgScore: json['avg_score'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      position: json['position'] as String,
      injured: json['injured'] as bool,
    );
  }
}
