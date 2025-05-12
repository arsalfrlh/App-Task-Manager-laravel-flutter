class Task {
  final int id;
  final int? id_user;
  final String? gambar;
  final String title;
  final String deskripsi;
  final String status;

  Task({required this.id, this.id_user, this.gambar, required this.title, required this.deskripsi, required this.status});
  factory Task.fromJson(Map<String, dynamic> json){
    return Task(
      id: json['id'],
      id_user: json['id_user'],
      gambar: json['gambar'],
      title: json['title'],
      deskripsi: json['deskripsi'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'id_user': id_user,
      'title': title,
      'deskripsi': deskripsi,
      'status': status,
    };
  }
}
