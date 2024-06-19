import 'dart:convert';

List<ListesAbsences> listesAbsencesFromJson(String str) => List<ListesAbsences>.from(json.decode(str).map((x) => ListesAbsences.fromJson(x)));

String listesAbsencesToJson(List<ListesAbsences> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListesAbsences {
    ListesAbsences({
        required this.id,
        required this.seance,
        required this.date,
        required this.createdAt,
        required this.updatedAt,
        required this.roomId,
    });

    int id;
    String seance;
    DateTime date;
    DateTime createdAt;
    DateTime updatedAt;
    int roomId;

    factory ListesAbsences.fromJson(Map<String, dynamic> json) => ListesAbsences(
        date: DateTime.parse(json["date"]),
        seance: json["seance"],
        roomId: json["room_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "seance": seance,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "room_id": roomId,
    };
}
