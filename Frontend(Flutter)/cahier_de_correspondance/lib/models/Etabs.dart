import 'dart:convert';

List<Etabs> etabsFromJson(String str) => List<Etabs>.from(json.decode(str).map((x) => Etabs.fromJson(x)));

String etabsToJson(List<Etabs> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Etabs {
    Etabs({
        required this.id,
        required this.nom,
        required this.commune,
        required this.daira,
        required this.wilaya,
        required this.fax,
        this.createdAt,
        this.updatedAt,
        required this.cycle,
        required this.email,
        required this.accessAppPassword,
    });

    int id;
    String nom;
    String commune;
    String daira;
    String wilaya;
    int fax;
    dynamic createdAt;
    dynamic updatedAt;
    String cycle;
    String email;
    String accessAppPassword;

    factory Etabs.fromJson(Map<String, dynamic> json) => Etabs(
        id: json["id"],
        nom: json["nom"],
        commune: json["commune"],
        daira: json["daira"],
        wilaya: json["wilaya"],
        fax: json["fax"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        cycle: json["cycle"],
        email: json["email"],
        accessAppPassword: json["access_app_password"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "commune": commune,
        "daira": daira,
        "wilaya": wilaya,
        "fax": fax,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "cycle": cycle,
        "email": email,
        "access_app_password": accessAppPassword,
    };
}
