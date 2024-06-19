import 'dart:convert';

ResponseMsg responseMsgFromJson(String str) => ResponseMsg.fromJson(json.decode(str));

String responseMsgToJson(ResponseMsg data) => json.encode(data.toJson());

class ResponseMsg {
    ResponseMsg({
        required this.message,
        required this.errors,
    });

    String message;
    Errors errors;

    factory ResponseMsg.fromJson(Map<String, dynamic> json) => ResponseMsg(
        message: json["message"],
        errors: Errors.fromJson(json["errors"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "errors": errors.toJson(),
    };
}

class Errors {
    Errors({
        required this.email,
    });

    List<String> email;

    factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        email: List<String>.from(json["email"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "email": List<dynamic>.from(email.map((x) => x)),
    };
}
