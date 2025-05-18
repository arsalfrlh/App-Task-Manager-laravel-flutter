import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/models/task.dart';
import 'package:task/services/api_service.dart';

class UpdatePage extends StatefulWidget {
  final Task task;
  UpdatePage({required this.task});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  ApiService apiService = ApiService();
  late TextEditingController titleController;
  late TextEditingController deskripsiController;
  late TextEditingController statusController ;
  XFile? gambar;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    deskripsiController = TextEditingController(text: widget.task.deskripsi);
    statusController = TextEditingController(text: widget.task.status);
  }

  void pilih()async{
    gambar = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  void _update(BuildContext context)async{
    if(titleController.text.isNotEmpty && deskripsiController.text.isNotEmpty && statusController.text.isNotEmpty){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)  => const Center(
          child: CircularProgressIndicator(),
          ),
        );

      final udpateTask = Task(
        id: widget.task.id,
        title: titleController.text,
        deskripsi: deskripsiController.text,
        status: statusController.text,
      );

      final response = await apiService.editTask(udpateTask, gambar);
      Navigator.of(context, rootNavigator: true).pop();

      if(response['success'] == true){
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: response['message'],
          desc: 'Berhasil Mengupdate Task',
          btnOkOnPress: (){
            Navigator.pop(context);
          }
        ).show();
      }else{
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: response['message'],
          desc: response['data'].toString(),
          btnOkOnPress: (){}
        ).show();
      }
    }else{
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'Mohon isi semua fieldnya',
        btnOkOnPress: (){}
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Update Tugas"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfilePic(
              image: 'http://10.0.2.2:8000/images/${widget.task.gambar}',
              imageUploadBtnPress: pilih,
            ),
            const Divider(),
            Form(
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Title",
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Deskripsi",
                    child: TextFormField(
                      controller: deskripsiController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Status",
                    child: DropdownButtonFormField<String>(
                      value: statusController.text.isNotEmpty 
                      ? statusController.text //isi statusControllernya jika tdk kosong akan menampilkan optionnya
                      : null, //jika kosong isinya akan null di tampilannya optionnnya
                      items: ['selesai', 'belum selesai'].map((String value) { //isi dari Dropdown| di konversi di dalam map dan jdi tipe data String dan disimpan di vbariable value
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) { //saat Dropdown di pilih di isi akan meng set statusController| jika tdk di pilih akan null karena tipe data "?"
                        setState(() {
                          statusController.text = newValue!; //mengset statusController
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      hint: const Text("Pilih Status"),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.08),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () => _update(context),
                    child: const Text("Update"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    required this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: 'http://10.0.2.2:8000/images/${image}', errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 120,),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              )
          ),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}