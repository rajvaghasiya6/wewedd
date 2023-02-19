class GuestRequest {
  GuestRequest({
    required this.guestId,
    required this.guestName,
    required this.guestMobileNumber,
    required this.guestProfileImage,
    required this.guestIdProof,
    required this.guestStatus,
    required this.id,
    required this.guestSide,
  });

  final String guestId;
  final String guestName;
  final String guestMobileNumber;
  final String guestProfileImage;
  final List<String> guestIdProof;
  final String guestStatus;
  final String id;
  final String guestSide;

  factory GuestRequest.fromJson(Map<String, dynamic> json) => GuestRequest(
        guestId: json["guest_id"],
        guestName: json["guest_name"],
        guestMobileNumber: json["guest_mobile_number"],
        guestProfileImage: json["guest_profile_image"],
        guestIdProof: List<String>.from(json["guest_id_proof"].map((x) => x)),
        guestStatus: json["guest_status"],
        id: json["_id"],
        guestSide: json['guest_from'],
      );

  Map<String, dynamic> toJson() => {
        "guest_id": guestId,
        "guest_name": guestName,
        "guest_mobile_number": guestMobileNumber,
        "guest_profile_image": guestProfileImage,
        "guest_id_proof": List<dynamic>.from(guestIdProof.map((x) => x)),
        "guest_status": guestStatus,
        "_id": id,
        "guest_from": guestSide,
      };
}
