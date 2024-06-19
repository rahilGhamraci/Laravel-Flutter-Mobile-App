import 'dart:convert';

List<Edt> edtFromJson(String str) => List<Edt>.from(json.decode(str).map((x) => Edt.fromJson(x)));

String edtToJson(List<Edt> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Edt {
    Edt({
        required this.id,
        required this.trimestre,
        required this.anneeScolaire,
        required this.filePath,
        required this.classeId,
        required this.createdAt,
        required this.updatedAt,
        required this.fileName,
    });

    int id;
    String trimestre;
    String anneeScolaire;
    String filePath;
    int classeId;
    DateTime createdAt;
    DateTime updatedAt;
    String fileName;

    factory Edt.fromJson(Map<String, dynamic> json) => Edt(
        id: json["id"],
        trimestre: json["trimestre"],
        anneeScolaire: json["annee_scolaire"],
        filePath: json["file_path"],
        classeId: json["classe_id"] is int? json["classe_id"]:int.parse(json["classe_id"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fileName: json["file_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "trimestre": trimestre,
        "annee_scolaire": anneeScolaire,
        "file_path": filePath,
        "classe_id": classeId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "file_name": fileName,
    };
}
