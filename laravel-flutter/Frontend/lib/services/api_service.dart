import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/models/task.dart';
import 'dart:convert';

import 'package:task/models/user.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async { //Map<String, dynamic> tdk wajib saat ingin mengirim data dri body| tapi jika ingin nge return dan menggunakannya wajib menggunakannya seperti login dll
    final response = await http.post(Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password)async{ //data JSON berupa objek| karena beberapa data saja
    final response = await http.post(Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'name': name, 'email': email, 'password': password}));
    return json.decode(response.body);
  }

  Future<User?> getUser() async {
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/user'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<Task>> getAllTask() async {
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/tugas'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data']; //data JSON berupa List| karena banyak
      return data.map((item) => Task.fromJson(item)).toList();
    } else {
      throw Exception('data gagal dimuat');
    }
  }

  Future<void> updateStatus(Task task) async { //jika http post|put|delete|get hasilnya Future<http.Response> |jdi bisa digunakan langsung
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    await http.put(
      Uri.parse('$baseUrl/tugas/update/status'),
      headers: {
        'Authorization': 'Bearer $token', //route di lindungin auth:sanctum wajib menggunakan token user
        'Content-Type': 'application/json', //post atw put harus menggunakan ini
        },
      body: json.encode(task.toJson()), //body isi requestnya
    );
  }

  Future<Map<String, dynamic>> addTask(Task task, XFile gambar)async{ //jika http MultipartRequest|MultipartFile hasilnya Future<http.StreamedResponse> |jdi harus di konversi dlu (http.Response.fromStream(response))
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final request = await http.MultipartRequest('POST',Uri.parse('$baseUrl/tugas/tambah')); //multipart request flexsible stiap request berpisah
    request.headers.addAll({ //guanakan jika ingin requestnya MultipartRequest
      'Authorization': 'Bearer $token',
    });
    request.fields['title'] = task.title;
    request.fields['deskripsi'] = task.deskripsi;
    request.fields['status'] = task.status;
    request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));
    final response = await request.send(); //variable request di kirim dan di simpan di variabel response

    if(response.statusCode == 200){
      final responseData = await http.Response.fromStream(response); //hasil response tadi di konversi jadi json
      return json.decode(responseData.body);
    }else{
      throw Exception('Tambah Task gagal');
    }
  }

  Future<Map<String, dynamic>> editTask(Task task, XFile? gambar)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');
    
    final request = await http.MultipartRequest('POST', Uri.parse('$baseUrl/tugas/edit'));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.fields['id'] = task.id.toString();
    request.fields['title'] = task.title;
    request.fields['deskripsi'] = task.deskripsi;
    request.fields['status'] = task.status;

    if(gambar != null){
      request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));
    }

    final response = await request.send();
    if(response.statusCode == 200){
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body);
    }else{
      throw Exception('Edit Task gagal');
    }
  }

  Future<dynamic> updateTask(Task task)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.put(Uri.parse('$baseUrl/tugas/update'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(task.toJson()));
    return json.decode(response.body);
  }

  Future<void> deleteTask(int id)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    await http.delete(Uri.parse('$baseUrl/tugas/hapus/$id'),
    headers: {'Authorization': 'Bearer $token'});
  }

  Future<void> logout()async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    await http.post(Uri.parse('$baseUrl/logout'),
    headers: {'Authorization': 'Bearer $token'});

    await key.remove('token');
    await key.remove('statusLogin');
  }

  Future<List<Task>> getAllDoneTask(int id)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/tugas/selesai/$id'),
    headers: {'Authorization': 'Bearer $token'});

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Task.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }
  

  Future<List<Task>> searchTask(String search)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.post(Uri.parse('$baseUrl/tugas/search'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      },
    body: json.encode({'search': search}));
    final List<dynamic> data = json.decode(response.body)['data'];
    return data.map((item) => Task.fromJson(item)).toList();
  }

  Future<Map<String, dynamic>> sendData()async{ //function utk mengkonversi token utk mengambil data user
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.post(Uri.parse('$baseUrl/send/data'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      },
    body: json.encode({'token': token}));
    return json.decode(response.body);
  }
}
