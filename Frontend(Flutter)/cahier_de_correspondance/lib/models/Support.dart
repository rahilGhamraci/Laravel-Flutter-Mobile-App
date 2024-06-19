import 'dart:convert';

List<Support> supportFromJson(String str) => List<Support>.from(json.decode(str).map((x) => Support.fromJson(x)));

String supportToJson(List<Support> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Support {
    Support({
        this.id,
        required this.titreResume,
        required this.titre,
        required this.contenu,
        required this.contenuResume,
        required this.filePath,
        required this.fileName,
        required this.enseignantId,
        required this.enseignantNom,
        required this.enseignantPrenom,
        this.createdAt,
        this.updatedAt,
        required this.roomId,
    });

    int? id;
    String titreResume;
    String titre;
    String contenu;
    String contenuResume;
    String filePath;
    String fileName;
    int enseignantId;
    String enseignantNom;
    String enseignantPrenom;
    DateTime? createdAt;
    DateTime? updatedAt;
    int roomId;

    factory Support.fromJson(Map<String, dynamic> json) => Support(
        id: json["id"],
        titreResume: json["titre_resume"],
        titre: json["titre"],
        contenu: json["contenu"],
        contenuResume: json["contenu_resume"],
        filePath: json["file_path"],
        fileName: json["file_name"],
        enseignantId: json["enseignant_id"] is int? json["enseignant_id"]:int.parse(json["enseignant_id"]),
        enseignantNom: json["enseignant_nom"],
        enseignantPrenom: json["enseignant_prenom"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        roomId: json["room_id"] is int? json["room_id"]:int.parse(json["room_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titre_resume": titreResume,
        "titre": titre,
        "contenu": contenu,
        "contenu_resume": contenuResume,
        "file_path": filePath,
        "file_name": fileName,
        "enseignant_id": enseignantId,
        "enseignant_nom": enseignantNom,
        "enseignant_prenom": enseignantPrenom,
        "room_id": roomId,
    };
}
