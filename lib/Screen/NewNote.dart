import 'package:flutter/material.dart';
import '../Model/Note.dart';
import '../Database/Db.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final titleContrioller = TextEditingController();
  final noteContrioller = TextEditingController();

  Note? _existingNote;

  AppBar appbar = AppBar(title: const Text("Add Note"));

  @override
  initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _existingNote = ModalRoute.of(context)?.settings.arguments != null
            ? ModalRoute.of(context)?.settings.arguments as Note
            : null;

        if (_existingNote != null) {
          titleContrioller.text = _existingNote!.title;
          noteContrioller.text = _existingNote!.note;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //update
    _updateNote() async {
      if (titleContrioller.text.trim() == "" ||
          noteContrioller.text.trim() == "") {
        // Navigator.of(context).pop();
      } else {
        Db db = Db.db;
        Note updatedNote = Note(
            id: _existingNote!.id,
            title: titleContrioller.text,
            note: noteContrioller.text);
        int val = await db.updateById(updatedNote);

        if (val == 1) {}
        _existingNote = updatedNote;
        Navigator.of(context).pop();
      }
    }

    _addNote() async {
      final _title = titleContrioller.text;
      final _note = noteContrioller.text;
      final _id = DateTime.now().microsecond;

      if (_title.trim() == "") {
        Navigator.of(context).pop();
      } else if (_note.trim() == "") {
        Navigator.of(context).pop();
      } else {
        Note note = Note(id: _id, note: _note, title: _title);
        Db db = Db.db;

        int id = await db.insert(note);

        if (id != 0) {}
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: const BoxDecoration(color: Colors.black87),
            width: double.infinity,
            height: MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).viewPadding.top,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  width: double.infinity,
                  child: TextField(
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: .9),
                      cursorColor: Colors.white,
                      controller: titleContrioller,
                      autofocus: false,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: .9),
                        border: InputBorder.none,
                      )),
                ),
                const Divider(color: Colors.white),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                        maxLines: null,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                            letterSpacing: .2),
                        cursorColor: Colors.white,
                        controller: noteContrioller,
                        autofocus: false,
                        decoration: const InputDecoration(
                          hintText: "Note...",
                          hintStyle: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54,
                              letterSpacing: .1),
                          border: InputBorder.none,
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: _existingNote != null ? _updateNote : _addNote,
                  child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      height: MediaQuery.of(context).size.height * .08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _existingNote != null ? "Update" : "Add",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: .9),
                          ),
                        ],
                      )),
                )
              ],
            ),
          )),
    );
  }
}
