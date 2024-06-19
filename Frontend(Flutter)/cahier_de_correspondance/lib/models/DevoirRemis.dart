import 'dart:convert';

DevoirRemis devoirRemisFromJson(String str) => DevoirRemis.fromJson(json.decode(str));

String devoirRemisToJson(DevoirRemis data) => json.encode(data.toJson());

class DevoirRemis {
    DevoirRemis({
        required this.id,
        required this.filePath,
        required this.eleveId,
        required this.devoirId,
        required this.createdAt,
        required this.updatedAt,
        required this.fileName,
    });

    int id;
    String filePath;
    int eleveId;
    int devoirId;
    DateTime createdAt;
    DateTime updatedAt;
    String fileName;

    factory DevoirRemis.fromJson(Map<String, dynamic> json) => DevoirRemis(
        id: json["id"],
        filePath: json["file_path"],
        eleveId:  json["eleve_id"] is int? json["eleve_id"]:int.parse(json["eleve_id"]),
        devoirId: json["devoir_id"] is int? json["devoir_id"]:int.parse(json["devoir_id"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fileName: json["file_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file_path": filePath,
        "eleve_id": eleveId,
        "devoir_id": devoirId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "file_name": fileName,
    };
}
