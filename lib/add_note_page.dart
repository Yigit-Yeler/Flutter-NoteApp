import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddNote extends StatefulWidget {
  const AddNote({Key key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  List<Object> notes = [];
  @override
  void initState() {
    super.initState();
    getStringToSF();
  }

  getStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notes = jsonDecode(prefs.getString("note"));
  }

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> note = {
      'title': titleController.text,
      'note': noteController.text,
    };
    notes.add(note);
    prefs.setString('note', jsonEncode(notes));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Not Ekle"),
        centerTitle: true,
        backgroundColor: Colors.black54,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.black87,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  addNoteTextField(
                      1, width, height * 0.002, "Başlık", titleController),
                  addNoteTextField(
                      15, width, height * 0.002, "Not", noteController),
                  addNoteButton(height, width),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container addNoteTextField(int maxLines, double width, double height,
      String hintText, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white, height: height),
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Container addNoteButton(double height, double width) {
    return Container(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: height * 0.12,
              width: width * 0.5,
              padding: EdgeInsets.only(bottom: height * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    addStringToSF();
                  });
                },
                child: Text(
                  "Not Ekle",
                  style: TextStyle(fontSize: width * 0.05),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
