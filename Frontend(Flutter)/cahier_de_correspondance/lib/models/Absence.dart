import 'dart:convert';

Absence absenceFromJson(String str) => Absence.fromJson(json.decode(str));

String absenceToJson(Absence data) => json.encode(data.toJson());

class Absence {
    Absence({
         this.id,
         this.createdAt,
         this.updatedAt,
         this.eleveId,
         this.listeAbsencesId,
        this.justificationId,
    });

    int? id;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? eleveId;
    int? listeAbsencesId;
    int? justificationId;

    factory Absence.fromJson(Map<String, dynamic> json) => Absence(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        eleveId:  json["eleve_id"] == null ? null :json["eleve_id"]is int? json["eleve_id"]:int.parse(json["eleve_id"]),
        listeAbsencesId: json["liste_absences_id"] == null ? null :json["liste_absences_id"]is int? json["liste_absences_id"]:int.parse(json["liste_absences_id"]),
        justificationId: json["justification_id"] == null ? null :json["justification_id"]is int? json["justification_id"]:int.parse(json["justification_id"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "eleve_id": eleveId,
        "liste_absences_id": listeAbsencesId,
        "justification_id": justificationId,
    };
}
