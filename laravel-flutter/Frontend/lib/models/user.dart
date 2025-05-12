class User {
  final int id;
  final String name;
  final String email;
  final String level;

  User({required this.id, required this.name, required this.email, required this.level});
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      email: json['name'],
      level: json['level'],
    );
  }
}
