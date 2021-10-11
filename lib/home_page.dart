import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noteapp/add_note_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> notes = [];
  Timer timer;
  Future<void> getStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = jsonDecode(prefs.getString("note"));
    });
  }

  deleteNoteFirst(int index) {
    deleteNote(index);
  }

  deleteNote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notes = jsonDecode(prefs.getString("note"));
    print(notes[index]);
    await notes.removeAt(index);
    if (notes.isNotEmpty) {
      prefs.setString('note', jsonEncode(notes));
    } else {
      prefs.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getStringToSF());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (notes.isEmpty) {
      return Scaffold(
          appBar: appBarHome(width),
          body: Container(
            color: Colors.black87,
            child: Center(
              child: Text(
                "Notunuz Bulunmamaktadır",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ));
    } else {
      return Scaffold(
        appBar: appBarHome(width),
        body: Container(
          color: Colors.black87,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: width * 0.02,
                  mainAxisSpacing: height * 0.01),
              itemCount: notes.length,
              primary: false,
              padding: EdgeInsets.all(20),
              itemBuilder: (BuildContext context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey,
                  ),
                  height: width * 0.45,
                  width: height * 0.2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
                              width: width * 0.40,
                              height: height * 0.07,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(notes[index]["title"]),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          deleteNote(index);
                                        });
                                      })
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: width * 0.02),
                              width: width * 0.40,
                              height: height * 0.11,
                              child: Text(notes[index]["note"]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
                // return Center(
                //   child: Text(
                //     "Notunuz Bulunmamaktadır",
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                // );
              }),
        ),
      );
    }
  }

  AppBar appBarHome(double width) {
    return AppBar(
      actions: [
        IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: width * 0.08,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    new MaterialPageRoute(builder: (_) => new AddNote()),
                  )
                  .then((val) => {
                        setState(() {
                          getStringToSF();
                        })
                      });
            })
      ],
      backgroundColor: Colors.black54,
      centerTitle: true,
      title: Text("Not Al"),
    );
  }
}
