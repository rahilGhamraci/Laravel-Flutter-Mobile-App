import 'dart:convert';

List<Message> messageFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String messageToJson(List<Message> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
    Message({
        required this.id,
        required this.contenu,
        required this.read,
        required this.userId,
        required this.conversationId,
         this.createdAt,
       this.updatedAt,
        required this.type,
        this.reponse
    });

    int id;
    String contenu;
    bool read;
    int userId;
    int conversationId;
    DateTime? createdAt;
    String? updatedAt;
    String type;
    String? reponse;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        contenu: json["contenu"],
        read: json["read"],
        userId:  json["user_id"] is int? json["user_id"]:int.parse(json["user_id"]),
        conversationId: json["conversation_id"] is int? json["conversation_id"]:int.parse(json["conversation_id"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        type: json["type"],
        reponse: json["reponse"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "contenu": contenu,
        "read": read,
        "user_id": userId,
        "conversation_id": conversationId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "type": type,
        "reponse": reponse,
    };
}
