import 'dart:convert';

List<DevoirsRemis> devoirsRemisFromJson(String str) => List<DevoirsRemis>.from(json.decode(str).map((x) => DevoirsRemis.fromJson(x)));

String devoirsRemisToJson(List<DevoirsRemis> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DevoirsRemis {
    DevoirsRemis({
        required this.id,
        required this.filePath,
        required this.eleveId,
        required this.devoirId,
        required this.fileName,
        required this.createdAt,
        required this.updatedAt,
        required this.elvNom,
        required this.elvPrenom,
    });

    int id;
    String filePath;
    int eleveId;
    int devoirId;
    String fileName;
    String createdAt;
    String updatedAt;
    String elvNom;
    String elvPrenom;

    factory DevoirsRemis.fromJson(Map<String, dynamic> json) => DevoirsRemis(
        id: json["id"],
        filePath: json["file_path"],
        eleveId: json["eleve_id"] is int? json["eleve_id"]:int.parse(json["eleve_id"]),
        devoirId:json["devoir_id"] is int? json["devoir_id"]:int.parse(json["devoir_id"]),
        fileName: json["file_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        elvNom: json["elv_nom"],
        elvPrenom: json["elv_prenom"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file_path": filePath,
        "eleve_id": eleveId,
        "devoir_id": devoirId,
        "file_name": fileName,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "elv_nom": elvNom,
        "elv_prenom": elvPrenom,
    };
}
