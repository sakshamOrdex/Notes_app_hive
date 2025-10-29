import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:hivedb/homescreen.dart';
import 'package:hivedb/Notes/notes.dart';
import 'package:hivedb/Notes/notes_model.dart';
import 'package:path_provider/path_provider.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  var directory=await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>("notes");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: Notes(),
    );
  }
}
