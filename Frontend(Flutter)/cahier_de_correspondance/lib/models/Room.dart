import 'dart:convert';

List<Room> roomFromJson(String str) => List<Room>.from(json.decode(str).map((x) => Room.fromJson(x)));

String roomToJson(List<Room> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Room {
    Room({
        required this.id,
        required this.classeId,
        required this.enseignantId,
        required this.niveau,
        required this.section,
        required this.nom,
        required this.prenom,
        required this.matiere,
    });

    int id;
    int classeId;
    int enseignantId;
    String niveau;
    String section;
    String nom;
    String prenom;
    String matiere;

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        classeId: json["classe_id"] is int? json["classe_id"]:int.parse(json["classe_id"]),
        enseignantId: json["enseignant_id"] is int? json["enseignant_id"]:int.parse(json["enseignant_id"]),
        niveau: json["niveau"],
        section: json["section"],
        nom: json["nom"],
        prenom: json["prenom"],
        matiere: json["matiere"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "classe_id": classeId,
        "enseignant_id": enseignantId,
        "niveau": niveau,
        "section": section,
        "nom": nom,
        "prenom": prenom,
        "matiere": matiere,
    };
}
