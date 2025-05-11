class Task {
  final int? id;
  final String gambar;
  final String title;
  final String deskripsi;
  final String status;

  Task({this.id, required this.gambar, required this.title, required this.deskripsi, required this.status});

  factory Task.fromDataBase(Map<String, dynamic> data){
    return Task(
      id: data['id'],
      gambar: data['gambar'],
      title: data['title'],
      deskripsi: data['deskripsi'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toDataBase(){
    return{
      'id': id,
      'gambar': gambar,
      'title': title,
      'deskripsi': deskripsi,
      'status': status,
    };
  }
}
