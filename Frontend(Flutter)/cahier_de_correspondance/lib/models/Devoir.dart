import 'dart:convert';

List<Devoir> devoirFromJson(String str) => List<Devoir>.from(json.decode(str).map((x) => Devoir.fromJson(x)));

String devoirToJson(List<Devoir> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Devoir {
    Devoir({
        this.id,
        required this.titreResume,
        required this.titre,
        required this.contenu,
        required this.contenuResume,
        this.filePath,
        this.fileName,
        required this.enseignantId,
        required this.enseignantNom,
        required this.enseignantPrenom,
        this.createdAt,
        this.updatedAt,
        required this.roomId,
        required this.delai,
    });

    int? id;
    String titreResume;
    String titre;
    String contenu;
    String contenuResume;
    String? filePath;
    String? fileName;
    int enseignantId;
    String enseignantNom;
    String enseignantPrenom;
    DateTime? createdAt;
    DateTime? updatedAt;
    int roomId;
     bool delai;

    factory Devoir.fromJson(Map<String, dynamic> json) => Devoir(
        id: json["id"],
        titreResume: json["titre_resume"],
        titre: json["titre"],
        contenu: json["contenu"],
        contenuResume: json["contenu_resume"],
        filePath: json["file_path"],
        fileName: json["file_name"],
        enseignantId:  json["enseignant_id"] is int? json["enseignant_id"]:int.parse(json["enseignant_id"]),
        enseignantNom: json["enseignant_nom"],
        enseignantPrenom: json["enseignant_prenom"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        roomId: json["room_id"] is int? json["room_id"]:int.parse(json["room_id"]),
        delai: json["delai"] ==0? false:true,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titre-resume": titreResume,
        "titre": titre,
        "contenu": contenu,
        "contenu_resume": contenuResume,
        "file_path": filePath,
        "file_name": fileName,
        "enseignant_id": enseignantId,
        "enseignant_nom": enseignantNom,
        "enseignant_prenom": enseignantPrenom,
        "room_id": roomId,
        "delai": delai,
    };
}
