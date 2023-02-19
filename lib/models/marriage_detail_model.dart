import 'dart:convert';

MarriageDetail marriageDetailFromJson(String str) =>
    MarriageDetail.fromJson(json.decode(str));

String marriageDetailToJson(MarriageDetail data) => json.encode(data.toJson());

class MarriageDetail {
  MarriageDetail(
      {required this.eventManagerName,
      required this.weddingHashtag,
      required this.mobileNumber,
      required this.password,
      required this.isActive,
      required this.marriageId,
      required this.marriageName,
      required this.weddingDate,
      required this.weddingLogo});

  String? eventManagerName;
  String? weddingHashtag;
  String? mobileNumber;
  String? password;
  bool? isActive;
  String? marriageId;
  String? marriageName;
  String? weddingDate;
  String? weddingLogo;

  factory MarriageDetail.fromJson(Map<String, dynamic> json) => MarriageDetail(
        eventManagerName: json["event_manager_name"],
        weddingHashtag: json["wedding_hashtag"],
        mobileNumber: json["mobile_number"],
        password: json["password"],
        isActive: json["is_active"],
        marriageId: json["marriage_id"],
        marriageName: json["marriage_name"],
        weddingDate: json["wedding_date"],
        weddingLogo: json['marriage_logo'],
      );

  Map<String, dynamic> toJson() => {
        "event_manager_name": eventManagerName,
        "wedding_hashtag": weddingHashtag,
        "mobile_number": mobileNumber,
        "password": password,
        "is_active": isActive,
        "marriage_id": marriageId,
        "marriage_name": marriageName,
        "wedding_date": weddingDate,
        "marriage_logo": weddingLogo,
      };
}
