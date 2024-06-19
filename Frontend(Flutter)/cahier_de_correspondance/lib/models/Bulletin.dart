import 'dart:convert';

List<Bulletin> bulletinFromJson(String str) => List<Bulletin>.from(json.decode(str).map((x) => Bulletin.fromJson(x)));

String bulletinToJson(List<Bulletin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bulletin {
    Bulletin({
        required this.trimestre,
        required this.anneeScolaire,
    });

    String trimestre;
    String anneeScolaire;

    factory Bulletin.fromJson(Map<String, dynamic> json) => Bulletin(
        trimestre: json["trimestre"],
        anneeScolaire: json["annee_scolaire"],
    );

    Map<String, dynamic> toJson() => {
        "trimestre": trimestre,
        "annee_scolaire": anneeScolaire,
    };
}
