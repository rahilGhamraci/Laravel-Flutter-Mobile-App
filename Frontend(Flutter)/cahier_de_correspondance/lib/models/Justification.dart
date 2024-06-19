import 'dart:convert';

Justification justificationFromJson(String str) => Justification.fromJson(json.decode(str));

String justificationToJson(Justification data) => json.encode(data.toJson());

class Justification {
    Justification({
        required this.objet,
        required this.text,
        required this.tuteurId,
        this.filePath,
        this.fileName,
        this.updatedAt,
        this.createdAt,
        required this.id,
    });

    String objet;
    String text;
    int tuteurId;
    String? filePath;
    String? fileName;
    DateTime? updatedAt;
    DateTime? createdAt;
    int id;

    factory Justification.fromJson(Map<String, dynamic> json) => Justification(
        objet: json["objet"],
        text: json["text"],
        tuteurId: json["tuteur_id"] is int? json["tuteur_id"]:int.parse(json["tuteur_id"]),
        filePath: json["file_path"],
        fileName: json["file_name"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "objet": objet,
        "text": text,
        "tuteur_id": tuteurId,
        "file_path": filePath,
        
    };
}
