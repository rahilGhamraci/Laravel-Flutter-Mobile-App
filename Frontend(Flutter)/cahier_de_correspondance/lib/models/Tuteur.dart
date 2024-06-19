import 'dart:convert';

List<Tuteur> tuteurFromJson(String str) => List<Tuteur>.from(json.decode(str).map((x) => Tuteur.fromJson(x)));

String tuteurToJson(List<Tuteur> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tuteur {
    Tuteur({
        required this.id,
        required this.nom,
        required this.prenom,
        required this.dateNaissance,
        required this.nss,
        this.createdAt,
        required this.updatedAt,
        required this.userId,
    });

    int id;
    String nom;
    String prenom;
    DateTime dateNaissance;
    int nss;
    dynamic createdAt;
    DateTime? updatedAt;
    int userId;

    factory Tuteur.fromJson(Map<String, dynamic> json) => Tuteur(
        id: json["id"],
        nom: json["nom"],
        prenom: json["prenom"],
        dateNaissance: DateTime.parse(json["date_naissance"]),
        nss: json["nss"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userId: json["user_id"] is int? json["user_id"]:int.parse(json["user_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "date_naissance": "${dateNaissance.year.toString().padLeft(4, '0')}-${dateNaissance.month.toString().padLeft(2, '0')}-${dateNaissance.day.toString().padLeft(2, '0')}",
        "nss": nss,
        "user_id": userId,
    };
}
