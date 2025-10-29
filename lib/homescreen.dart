import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hive DB",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: Hive.openBox("Try"),
            builder: (context, snapshot) {
              return ListTile(
                title: Text(snapshot.data!.get("name").toString()),
                subtitle: Text(snapshot.data!.get("age").toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        snapshot.data!.put(
                          "name",
                          "New Name",
                        ); //update the data
                        setState(() {});
                      },
                      icon: Icon(Icons.edit),
                      color: Colors.blueGrey,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        snapshot.data!.delete("name"); //delete the data
                        setState(() {});
                      },
                      icon: Icon(Icons.delete, color: Colors.pink),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("Try"); // creation of box
          box.put("name", "Old Name"); // insertion of the data
          box.put("age", 21);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
