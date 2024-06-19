import 'dart:convert';

List<Note> noteFromJson(String str) => List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
    Note({
        required this.id,
        required this.cc,
        required this.tp,
        required this.moyDevoirs,
        required this.examen,
        required this.matiere,
    });

    int id;
    int cc;
    int tp;
    int moyDevoirs;
    int examen;
    String matiere;

    factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        cc: json["cc"],
        tp: json["tp"],
        moyDevoirs: json["moy_devoirs"],
        examen: json["examen"],
        matiere: json["matiere"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cc": cc,
        "tp": tp,
        "moy_devoirs": moyDevoirs,
        "examen": examen,
        "matiere": matiere,
    };
}
