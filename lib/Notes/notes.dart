import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivedb/Notes/boxes.dart';
import 'package:hivedb/Notes/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
        backgroundColor: Colors.blue,
        toolbarHeight: 50,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return Card(
            child: ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].title.toString()),
                  subtitle: Text(data[index].desc.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          editDialogBox(
                            data[index],
                            data[index].title.toString(),
                            data[index].desc.toString(),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      SizedBox(width: 9),
                      IconButton(
                        onPressed: () {
                          delete(data[index]);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogBox();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> editDialogBox(
    NotesModel notesModel,
    String titles,
    String descs,
  ) async {
    title.text = titles;
    desc.text = descs;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Note"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: desc,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                notesModel.title = title.text.toString();
                notesModel.desc = desc.text.toString();
                title.clear();
                desc.clear();
                notesModel.save();
                Navigator.pop(context);
              },
              child: Text("Edit"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialogBox() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Note"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: desc,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final data = NotesModel(
                  title: title.text.toString(),
                  desc: desc.text.toString(),
                );
                final box = Boxes.getData();
                box.add(data);
                data.save();

                title.clear();
                desc.clear();
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
