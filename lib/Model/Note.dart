class Note {
  final int id;
  final String title;
  final String note;
  static final columns = ["id", "title", "note"];

  Note({required this.id, required this.title, required this.note});

  factory Note.fromMap(Map<dynamic, dynamic> data) {
    return Note(id: data["id"], note: data["note"], title: data["title"]);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "note": note};
  }
}
