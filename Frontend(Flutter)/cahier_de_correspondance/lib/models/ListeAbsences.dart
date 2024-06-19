import 'dart:convert';

ListeAbsences listeAbsencesFromJson(String str) => ListeAbsences.fromJson(json.decode(str));

String listeAbsencesToJson(ListeAbsences data) => json.encode(data.toJson());

class ListeAbsences {
    ListeAbsences({
        required this.date,
        required this.seance,
        required this.roomId,
         this.updatedAt,
         this.createdAt,
         this.id,
    });

    DateTime date;
    String seance;
    String roomId;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    factory ListeAbsences.fromJson(Map<String, dynamic> json) => ListeAbsences(
        date: DateTime.parse(json["date"]),
        seance: json["seance"],
        roomId: json["room_id"] ,
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "seance": seance,
        "room_id": roomId,
       
    };
}
