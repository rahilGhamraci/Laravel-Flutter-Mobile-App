import 'dart:convert';

List<Conversation> conversationFromJson(String str) => List<Conversation>.from(json.decode(str).map((x) => Conversation.fromJson(x)));

String conversationToJson(List<Conversation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Conversation {
    Conversation({
        required this.id,
        required this.firstUserId,
        required this.secondUserId,
        this.contenuMsg,
        this.userIdMsg,
        this.dateMsg,
        this.read,
        required this.userName,
    });

    int id;
    int firstUserId;
    int secondUserId;
    String? contenuMsg;
    int? userIdMsg;
    DateTime? dateMsg;
    int? read;
    String userName;

    factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        firstUserId: json["first_user_id"]is int? json["first_user_id"]:int.parse(json["first_user_id"]),
        secondUserId: json["second_user_id"]is int? json["second_user_id"]:int.parse(json["second_user_id"]),
        contenuMsg: json["contenu_msg"],
        userIdMsg:  json["user_id_msg"] == null ? null : json["user_id_msg"]is int? json["user_id_msg"]:int.parse(json["user_id_msg"]),
        dateMsg:  DateTime.parse(json["date_msg"]),
        read: json["read"] == null ? null :json["read"] is int? json["read"]:int.parse(json["read"]),
        userName: json["user_name"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "first_user_id": firstUserId,
        "second_user_id": secondUserId,
        "contenu_msg": contenuMsg,
        "user_id_msg": userIdMsg,
        "date_msg": dateMsg,
        "read":read,
        "user_name": userName,
    };
}
