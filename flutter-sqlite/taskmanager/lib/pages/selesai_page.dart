import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskmanager/database/database_helper.dart';
import 'package:taskmanager/models/task.dart';

class SelesaiPage extends StatefulWidget {
  @override
  _SelesaiPageState createState() => _SelesaiPageState();
}

class _SelesaiPageState extends State<SelesaiPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskDoneList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDoneTask();
  }

  Future<void> fetchDoneTask() async {
    setState(() {
      isLoading = true;
    });
    taskDoneList = await databaseHelper.getDoneTask();
    setState(() {
      isLoading = false;
    });
  }

  void _statusUpdate(BuildContext context, Task task){
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      title: task.title,
      desc: task.deskripsi,
      btnOkText: 'Selesai',
      btnOkOnPress: () async{
        final updateTask = Task(
          id: task.id,
          gambar: task.gambar,
          title: task.title,
          deskripsi: task.deskripsi,
          status: 'selesai',
        );
        await databaseHelper.statusUpdate(updateTask, task.id!).then((_) => fetchDoneTask());
      },
      btnCancelText: 'Belum Selesai',
      btnCancelOnPress: () async{
        final updateTask = Task(
          id: task.id,
          gambar: task.gambar,
          title: task.title,
          deskripsi: task.deskripsi,
          status: 'belum selesai',
        );
        await databaseHelper.statusUpdate(updateTask, task.id!).then((_) => fetchDoneTask());
      }
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FD), // Warna biru muda lembut
      appBar: AppBar(
        title: const Text("Tugas yang Diselesaikan"),
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: taskDoneList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => ProductCard(
              task: taskDoneList[index],
              onPress: () => _statusUpdate(context, taskDoneList[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.task,
    required this.onPress,
  });

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
                child: Image.file(File(task.gambar)),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    backgroundColor: Colors.green,
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
