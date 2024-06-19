import 'dart:convert';

List<EnfantsTuteur> enfantsTuteurFromJson(String str) => List<EnfantsTuteur>.from(json.decode(str).map((x) => EnfantsTuteur.fromJson(x)));

String enfantsTuteurToJson(List<EnfantsTuteur> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EnfantsTuteur {
    EnfantsTuteur({
        required this.id,
        required this.nom,
        required this.prenom,
        required this.dateNaissance,
        required this.lieuNaissance,
        required this.classeId,
        required this.tuteurId,
        required this.userId,
        this.createdAt,
        this.updatedAt,
        required this.section,
        required this.niveau,
    });

    int id;
    String nom;
    String prenom;
    DateTime dateNaissance;
    String lieuNaissance;
    int classeId;
    int tuteurId;
    int userId;
    DateTime? createdAt;
    DateTime? updatedAt;
    String section;
    String niveau;

    factory EnfantsTuteur.fromJson(Map<String, dynamic> json) => EnfantsTuteur(
        id: json["id"],
        nom: json["nom"],
        prenom: json["prenom"],
        dateNaissance: DateTime.parse(json["date_naissance"]),
        lieuNaissance: json["lieu_naissance"],
        classeId: json["classe_id"] is int? json["classe_id"]:int.parse(json["classe_id"]),
        tuteurId: json["tuteur_id"] is int? json["tuteur_id"]:int.parse(json["tuteur_id"]),
        userId: json["user_id"] is int? json["user_id"]:int.parse(json["user_id"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        section: json["section"],
        niveau: json["niveau"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "date_naissance": "${dateNaissance.year.toString().padLeft(4, '0')}-${dateNaissance.month.toString().padLeft(2, '0')}-${dateNaissance.day.toString().padLeft(2, '0')}",
        "lieu_naissance": lieuNaissance,
        "classe_id": classeId,
        "tuteur_id": tuteurId,
        "user_id": userId,
        "section": section,
        "niveau": niveau,
    };
}
