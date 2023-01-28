import 'dart:convert';

HostedMarriages HostedMarriagesFromJson(String str) =>
    HostedMarriages.fromJson(json.decode(str));

String HostedMarriagesToJson(HostedMarriages data) =>
    json.encode(data.toJson());

class HostedMarriages {
  HostedMarriages({
    required this.totalRegisterGuestNumber,
    required this.pendingRequestNumber,
    required this.marriageId,
    required this.hashtag,
    required this.weddingDate,
    required this.weddingName,
  });

  int pendingRequestNumber;
  String hashtag;
  String marriageId;
  int totalRegisterGuestNumber;
  String weddingDate;
  String weddingName;

  factory HostedMarriages.fromJson(Map<String, dynamic> json) =>
      HostedMarriages(
        pendingRequestNumber: json["pending_request_number"],
        hashtag: json["hashtag"],
        marriageId: json["marriage_id"],
        totalRegisterGuestNumber: json["total_register_guest_number"],
        weddingDate: json["wedding_date"],
        weddingName: json["wedding_name"],
      );

  Map<String, dynamic> toJson() => {
        "pending_request_number": pendingRequestNumber,
        "hashtag": hashtag,
        "total_register_guest_number": totalRegisterGuestNumber,
        "marriage_id": marriageId,
        "wedding_date": weddingDate,
        "wedding_name": weddingName,
      };
}
