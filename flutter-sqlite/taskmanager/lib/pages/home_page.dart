import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskmanager/database/database_helper.dart';
import 'package:taskmanager/models/task.dart';
import 'package:taskmanager/pages/belum_page.dart';
import 'package:taskmanager/pages/search_page.dart';
import 'package:taskmanager/pages/selesai_page.dart';
import 'package:taskmanager/pages/tambah_page.dart';
import 'package:taskmanager/pages/update_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;
  List<Task> taskList = [];

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  Future<void> fetchTask()async{
    setState(() {
      isLoading = true;
    });
    taskList = await databaseHelper.getAllTask();
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
        await databaseHelper.statusUpdate(updateTask, task.id!).then((_) => fetchTask());
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
        await databaseHelper.statusUpdate(updateTask, task.id!).then((_) => fetchTask());
      }
    ).show();
  }

  void _deleteTask(BuildContext context, int id)async{
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      title: 'Hapus',
      desc: 'Apakah Anda yakin?',
      btnOkOnPress: ()async{
        await databaseHelper.deleteTask(id).then((_) => fetchTask());
      },
      btnCancelOnPress: (){},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FD), // Warna biru muda lembut
      body: RefreshIndicator(
        onRefresh: fetchTask,
        child: isLoading
        ? Center(child: CircularProgressIndicator(),)
        : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 20), //wajib menggunakan SizedBox uth memisahkan antara stfl
                      HomeHeader(
                        selesai: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelesaiPage())).then((_) => fetchTask());
                        },
                        belum: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BelumPage())).then((_) => fetchTask());
                        },
                      ),
                      SizedBox(height: 10),
                      DiscountBanner(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(
                        task: taskList[index],
                        onPress: () => _statusUpdate(context, taskList[index]),
                        onUpdate: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(task: taskList[index]))).then((_) => fetchTask());
                        },
                        onDelete: () => _deleteTask(context, taskList[index].id!),
                      ),
                      childCount: taskList.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                    ),
                  ),
                ),
              ],
            ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(25), // setengah dari width agar bulat
        child: Container(
          color: Colors.green,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahPage()),
              ).then((_) => fetchTask());
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),

    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.selesai,
    required this.belum,
  });
  final VoidCallback selesai, belum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(child: SearchField()),
          const SizedBox(width: 16),
          IconButton(onPressed: belum, icon: Icon(Icons.assessment_rounded)),
          const SizedBox(width: 8),
          IconButton(onPressed: selesai, icon: Icon(Icons.assignment_turned_in_sharp))
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        onFieldSubmitted: (value) => {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(cari: value)))
        },
        decoration: InputDecoration(
          filled: true,
          hintStyle: const TextStyle(color: Color(0xFF757575)),
          fillColor: const Color(0xFF979797).withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          hintText: "Search product",
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF00BF6D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "Task Manager\n",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: "Aplikasi pengelola tugas Anda"),
          ],
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
    required this.onUpdate,
    required this.onDelete,
  });

  final double width, aspectRetio;
  final Task task;
  final VoidCallback onPress, onUpdate, onDelete;

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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    backgroundColor: task.status == 'selesai'
                    ? Colors.green
                    : Colors.red
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: onUpdate, icon: Icon(Icons.edit)),
                    IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


const heartIcon =
    '''<svg width="18" height="16" viewBox="0 0 18 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M16.5266 8.61383L9.27142 15.8877C9.12207 16.0374 8.87889 16.0374 8.72858 15.8877L1.47343 8.61383C0.523696 7.66069 0 6.39366 0 5.04505C0 3.69644 0.523696 2.42942 1.47343 1.47627C2.45572 0.492411 3.74438 0 5.03399 0C6.3236 0 7.61225 0.492411 8.59454 1.47627C8.81857 1.70088 9.18143 1.70088 9.40641 1.47627C11.3691 -0.491451 14.5629 -0.491451 16.5266 1.47627C17.4763 2.42846 18 3.69548 18 5.04505C18 6.39366 17.4763 7.66165 16.5266 8.61383Z" fill="#DBDEE4"/>
</svg>
''';

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";

const cartIcon =
    '''<svg width="22" height="18" viewBox="0 0 22 18" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M18.4524 16.6669C18.4524 17.403 17.8608 18 17.1302 18C16.3985 18 15.807 17.403 15.807 16.6669C15.807 15.9308 16.3985 15.3337 17.1302 15.3337C17.8608 15.3337 18.4524 15.9308 18.4524 16.6669ZM11.9556 16.6669C11.9556 17.403 11.3631 18 10.6324 18C9.90181 18 9.30921 17.403 9.30921 16.6669C9.30921 15.9308 9.90181 15.3337 10.6324 15.3337C11.3631 15.3337 11.9556 15.9308 11.9556 16.6669ZM20.7325 5.7508L18.9547 11.0865C18.6413 12.0275 17.7685 12.6591 16.7846 12.6591H10.512C9.53753 12.6591 8.66784 12.0369 8.34923 11.1095L6.30162 5.17154H20.3194C20.4616 5.17154 20.5903 5.23741 20.6733 5.35347C20.7563 5.47058 20.7771 5.61487 20.7325 5.7508ZM21.6831 4.62051C21.3697 4.18031 20.858 3.91682 20.3194 3.91682H5.86885L5.0002 1.40529C4.70961 0.564624 3.92087 0 3.03769 0H0.621652C0.278135 0 0 0.281266 0 0.62736C0 0.974499 0.278135 1.25472 0.621652 1.25472H3.03769C3.39158 1.25472 3.70812 1.48161 3.82435 1.8183L4.83311 4.73657C4.83622 4.74598 4.83934 4.75434 4.84245 4.76375L7.17339 11.5215C7.66531 12.9518 9.00721 13.9138 10.512 13.9138H16.7846C18.304 13.9138 19.6511 12.9383 20.1347 11.4859L21.9135 6.14917C22.0847 5.63369 21.9986 5.06175 21.6831 4.62051Z" fill="#7C7C7C"/>
</svg>
''';

const bellIcon =
    '''<svg width="15" height="20" viewBox="0 0 15 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M13.9645 15.8912C13.9645 16.1628 13.7495 16.3832 13.4844 16.3832H9.22765H9.21987H1.51477C1.2505 16.3832 1.03633 16.1628 1.03633 15.8912V10.7327C1.03633 7.08053 3.93546 4.10885 7.50043 4.10885C11.0645 4.10885 13.9645 7.08053 13.9645 10.7327V15.8912ZM7.50043 18.9381C6.77414 18.9381 6.18343 18.3327 6.18343 17.5885C6.18343 17.5398 6.18602 17.492 6.19034 17.4442H8.81052C8.81484 17.492 8.81743 17.5398 8.81743 17.5885C8.81743 18.3327 8.22586 18.9381 7.50043 18.9381ZM9.12488 3.2292C9.35805 2.89469 9.49537 2.48673 9.49537 2.04425C9.49537 0.915044 8.6024 0 7.50043 0C6.39847 0 5.5055 0.915044 5.5055 2.04425C5.5055 2.48673 5.64281 2.89469 5.87512 3.2292C2.51828 3.99204 0 7.06549 0 10.7327V15.8912C0 16.7478 0.679659 17.4442 1.51477 17.4442H5.15142C5.14883 17.492 5.1471 17.5398 5.1471 17.5885C5.1471 18.9186 6.20243 20 7.50043 20C8.79843 20 9.8529 18.9186 9.8529 17.5885C9.8529 17.5398 9.85117 17.492 9.84858 17.4442H13.4844C14.3203 17.4442 15 16.7478 15 15.8912V10.7327C15 7.06549 12.4826 3.99204 9.12488 3.2292Z" fill="#626262"/>
</svg>
''';