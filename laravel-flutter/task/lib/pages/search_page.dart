import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task/models/task.dart';
import 'package:task/models/user.dart';
import 'package:task/services/api_service.dart';

class SearchPage extends StatefulWidget {
  final String search;
  SearchPage({required this.search});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  List<Task> taskSearch = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    fetchSearchTask();
    fetchUser();
  }

  void fetchUser() async {
    User? user = await apiService.getUser();
    setState(() {
      _user = user;
    });
  }

  Future<void> fetchSearchTask() async {
    setState(() {
      isLoading = true;
    });
    taskSearch = await apiService.searchTask(widget.search);
    setState(() {
      isLoading = false;
    });
  }

  void _statusUpdate(BuildContext context, Task task) async {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      title: task.title, //mengambil isi dari parameter function class Task
      desc: 'Ubah Status Tugas',
      btnOkText: 'Selesai',
      btnOkOnPress: () async {
        final statusTask = Task(
          id: task.id, //mengambil isi dari parameter function class Task
          id_user: _user!.id,
          title: task.title,
          deskripsi: task.deskripsi,
          status: 'selesai', //mengisi selesai
        );

        await apiService.updateStatus(statusTask);
      },
      btnCancelText: 'Belum Selesai',
      btnCancelOnPress: () async {
        final statusTask = Task(
          id: task.id,
          id_user: _user!.id,
          title: task.title,
          deskripsi: task.deskripsi,
          status: 'belum selesai',
        );

        await apiService.updateStatus(statusTask);
      },
    ).show().then((_) => fetchSearchTask());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Tugas yang dicari"),
        ),
        body: _user == null
        ? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: fetchSearchTask,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: taskSearch.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) => ProductCard(
                        task: taskSearch[index],
                        onPress: () =>
                            _statusUpdate(context, taskSearch[index]),
                      ),
                    ),
                  ),
                ),
        ),
        );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.task,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Task task;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF979797).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  'http://10.0.2.2:8000/images/${task.gambar}',
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    backgroundColor:
                        task.status == 'selesai' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
