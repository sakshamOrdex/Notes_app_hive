import 'package:hive/hive.dart';
import 'package:hivedb/Notes/notes_model.dart';

class Boxes 
{
  static Box<NotesModel> getData() => Hive.box<NotesModel>("notes");
}