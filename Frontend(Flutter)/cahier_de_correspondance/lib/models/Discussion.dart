import 'dart:convert';

Discussion discussionFromJson(String str) => Discussion.fromJson(json.decode(str));

String discussionToJson(Discussion data) => json.encode(data.toJson());

class Discussion {
    int otherUserId;
    String otherUserName;
    int id;

    Discussion({
        required this.otherUserId,
        required this.otherUserName,
        required this.id,
    });

    factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
        otherUserId: json["other_user_id"],
        otherUserName: json["other_user_name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "other_user_id": otherUserId,
        "other_user_name": otherUserName,
        "id": id,
    };
}
