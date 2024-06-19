import 'dart:convert';

List<Convocation> convocationFromJson(String str) => List<Convocation>.from(json.decode(str).map((x) => Convocation.fromJson(x)));

String convocationToJson(List<Convocation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Convocation {
    Convocation({
        required this.id,
        required this.titre,
        required this.contenu,
        required this.tuteurId,
        this.createdAt,
        this.updatedAt,
        this.filePath,
        required this.roomId,
        this.fileName,
        required this.nom,
        required this.prenom,
    });

    int id;
    String titre;
    String contenu;
    int tuteurId;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? filePath;
    int roomId;
    String? fileName;
    String nom;
    String prenom;

    factory Convocation.fromJson(Map<String, dynamic> json) => Convocation(
        id: json["id"],
        titre: json["titre"],
        contenu: json["contenu"],
        tuteurId: json["tuteur_id"] is int? json["tuteur_id"]:int.parse(json["tuteur_id"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        filePath: json["file_path"],
        roomId: json["room_id"] is int? json["room_id"]:int.parse(json["room_id"]),
        fileName: json["file_name"],
        nom: json["nom"],
        prenom: json["prenom"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titre": titre,
        "contenu": contenu,
        "tuteur_id": tuteurId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "file_path": filePath,
        "room_id": roomId,
        "file_name": fileName,
        "nom": nom,
        "prenom": prenom,
    };
}
