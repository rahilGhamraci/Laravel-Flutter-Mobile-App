import 'dart:convert';

List<AbsTuteur> absTuteurFromJson(String str) => List<AbsTuteur>.from(json.decode(str).map((x) => AbsTuteur.fromJson(x)));

String absTuteurToJson(List<AbsTuteur> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AbsTuteur {
    AbsTuteur({
        required this.id,
        required this.date,
        required this.seance,
        required this.isSelected,
        this.justificationId,
        this.objet,
        this.text,
        this.fileName,
        this.filePath,
        this.tuteurId,
        this.createdAt,
    });

    int id;
    DateTime date;
    String seance;
    bool isSelected;
    int? justificationId;
    String? objet;
    String? text;
    dynamic fileName;
    dynamic filePath;
    int? tuteurId;
    DateTime? createdAt;

    factory AbsTuteur.fromJson(Map<String, dynamic> json) => AbsTuteur(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        seance: json["seance"],
        isSelected: json["is_selected"],
        justificationId: json["justification_id"] == null ? null :json["justification_id"]is int? json["justification_id"]:int.parse(json["justification_id"]),
        objet: json["objet"],
        text: json["text"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        tuteurId: json["tuteur_id"] == null ? null : json["tuteur_id"]is int? json["tuteur_id"]:int.parse(json["tuteur_id"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "seance": seance,
        "is_selected": isSelected,
        "justification_id": justificationId,
        "objet": objet,
        "text": text,
        "file_name": fileName,
        "file_path": filePath,
        "tuteur_id": tuteurId,
        "created_at": createdAt?.toIso8601String(),
    };
}
