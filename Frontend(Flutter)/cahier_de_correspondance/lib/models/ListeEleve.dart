import 'dart:convert';

List<ListeEleve> listeEleveFromJson(String str) => List<ListeEleve>.from(json.decode(str).map((x) => ListeEleve.fromJson(x)));

String listeEleveToJson(List<ListeEleve> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListeEleve {
    ListeEleve({
        required this.id,
        required this.nom,
        required this.prenom,
        required this.dateNaissance,
        required this.lieuNaissance,
        required this.classeId,
        required this.tuteurId,
        this.createdAt,
        this.updatedAt,
        required this.userId,
    });

    int id;
    String nom;
    String prenom;
    DateTime dateNaissance;
    String lieuNaissance;
    int classeId;
    int tuteurId;
    dynamic createdAt;
    DateTime? updatedAt;
    int userId;

    factory ListeEleve.fromJson(Map<String, dynamic> json) => ListeEleve(
        id: json["id"],
        nom: json["nom"],
        prenom: json["prenom"],
        dateNaissance: DateTime.parse(json["date_naissance"]),
        lieuNaissance: json["lieu_naissance"],
        classeId: json["classe_id"] is int? json["classe_id"]:int.parse(json["classe_id"]),
        tuteurId: json["tuteur_id"] is int? json["tuteur_id"]:int.parse(json["tuteur_id"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userId: json["user_id"] is int? json["user_id"]:int.parse(json["user_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "date_naissance": "${dateNaissance.year.toString().padLeft(4, '0')}-${dateNaissance.month.toString().padLeft(2, '0')}-${dateNaissance.day.toString().padLeft(2, '0')}",
        "lieu_naissance": lieuNaissance,
        "classe_id": classeId,
        "tuteur_id": tuteurId,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
        "user_id": userId,
    };
}
