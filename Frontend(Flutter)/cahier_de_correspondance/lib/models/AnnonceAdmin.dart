import 'dart:convert';

List<AnnonceAdministrative> annonceAdministrativeFromJson(String str) => List<AnnonceAdministrative>.from(json.decode(str).map((x) => AnnonceAdministrative.fromJson(x)));

String annonceAdministrativeToJson(List<AnnonceAdministrative> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnnonceAdministrative {
    int id;
    String titre;
    String titreResume;
    String contenu;
    String contenuResume;
    String? filePath;
    String? fileName;
    int classeId;
    DateTime createdAt;
    DateTime updatedAt;

    AnnonceAdministrative({
        required this.id,
        required this.titreResume,
        required this.titre,
        required this.contenu,
        required this.contenuResume,
        this.filePath,
        this.fileName,
        required this.classeId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory AnnonceAdministrative.fromJson(Map<String, dynamic> json) => AnnonceAdministrative(
        id: json["id"],
        titreResume: json["titre_resume"],
        titre: json["titre"],
        contenu: json["contenu"],
        contenuResume: json["contenu_resume"],
        filePath: json["file_path"],
        fileName: json["file_name"],
        classeId: json["classe_id"]is int? json["classe_id"]:int.parse(json["classe_id"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titre_resume": titreResume,
        "titre": titre,
        "contenu": contenu,
        "contenu_resume": contenuResume,
        "file_path": filePath,
        "file_name": fileName,
        "classe_id": classeId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
