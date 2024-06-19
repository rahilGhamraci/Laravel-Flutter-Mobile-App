import 'dart:convert';

List<ListeElvAbs> listeElvAbsFromJson(String str) => List<ListeElvAbs>.from(json.decode(str).map((x) => ListeElvAbs.fromJson(x)));

String listeElvAbsToJson(List<ListeElvAbs> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListeElvAbs {
    ListeElvAbs({
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
        this.isSelected,
        this.justificationCreatedAt,
        this.justificationUpdatedAt,
        this.justificationId,
        this.objet,
        this.text,
        this.fileName,
        this.filePath,
        required this.tuteurNom,
        required this.tuteurPrenom,
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
    bool? isSelected;
    DateTime? justificationCreatedAt;
    DateTime? justificationUpdatedAt;
    int? justificationId;
    String? objet;
    String? text;
    dynamic fileName;
    dynamic filePath;
    String tuteurNom;
    String tuteurPrenom;

    factory ListeElvAbs.fromJson(Map<String, dynamic> json) => ListeElvAbs(
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
        isSelected: json["is_selected"],
        justificationCreatedAt: json["justification_created_at"] == null ? null : DateTime.parse(json["justification_created_at"]),
        justificationUpdatedAt: json["justification_updated_at"] == null ? null : DateTime.parse(json["justification_updated_at"]),
        justificationId:  json["justification_id"] == null ? null :json["justification_id"] is int? json["justification_id"]:int.parse(json["justification_id"]),
        objet: json["objet"],
        text: json["text"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        tuteurNom: json["tuteur_nom"],
        tuteurPrenom: json["tuteur_prenom"],
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
        "created_at": createdAt,
        "is_selected": isSelected,
        "justification_id": justificationId,
        "objet": objet,
        "text": text,
        "file_name": fileName,
        "file_path": filePath,
        "tuteur_nom": tuteurNom,
        "tuteur_prenom": tuteurPrenom,
    };
}
