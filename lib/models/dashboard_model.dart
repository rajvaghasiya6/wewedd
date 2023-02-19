import 'dart:convert';

import 'package:collection/collection.dart';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

class DashboardModel {
  DashboardModel(
      {required this.marriageLogo,
      required this.eventManagerName,
      required this.weddingHashtag,
      required this.banner,
      required this.invitationCard,
      required this.isDark,
      required this.secondaryColor,
      required this.brideName,
      required this.groomName,
      required this.weddingVenue,
      required this.mobileNumber,
      required this.isGuestsIdProof,
      required this.isApprovePost,
      required this.liveLink,
      required this.isActive,
      required this.fcmTokenMarriage,
      required this.marriageId,
      required this.marriageName,
      required this.weddingDate,
      required this.groom,
      required this.bride,
      required this.brideFather,
      required this.brideMother,
      required this.groomFather,
      required this.groomMother,
      e});

  final String marriageLogo;
  final String eventManagerName;
  final String weddingHashtag;
  final List<String> banner;
  final List<String> invitationCard;
  final bool isDark;
  final List<String> secondaryColor;
  final String brideName;
  final String groomName;
  final String weddingVenue;
  final String mobileNumber;
  final bool isGuestsIdProof;
  final bool isApprovePost;
  final String liveLink;
  final bool isActive;
  final String fcmTokenMarriage;
  final String marriageId;
  final String marriageName;
  final String weddingDate;
  Side? groom;
  Side? groomFather;
  Side? groomMother;
  Side? brideFather;
  Side? brideMother;
  Side? bride;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        marriageLogo: json["marriage_logo"],
        eventManagerName: json["event_manager_name"],
        weddingHashtag: json["wedding_hashtag"],
        banner: List<String>.from(json["banner"].map((x) => x)),
        invitationCard:
            List<String>.from(json["invitation_card"].map((x) => x)),
        isDark: json["is_dark"],
        secondaryColor:
            List<String>.from(json["secondary_color"].map((x) => x)),
        brideName: json["bride_name"],
        groomName: json["groom_name"],
        weddingVenue: json["wedding_venue"],
        mobileNumber: json["mobile_number"],
        isGuestsIdProof: json["is_guests_id_proof"],
        isApprovePost: json["is_approve_post"],
        liveLink: json["live_link"],
        isActive: json["is_active"],
        fcmTokenMarriage: json["fcm_token_marriage"],
        marriageId: json["marriage_id"],
        marriageName: json["marriage_name"],
        weddingDate: json["wedding_date"],
        bride: List<Side>.from(json["bride_side"].map((x) => Side.fromJson(x)))
            .firstWhereOrNull((element) => element.relation == 'Bride'),
        groom: List<Side>.from(json["groom_side"].map((x) => Side.fromJson(x)))
            .firstWhereOrNull((element) => element.relation == 'Groom'),
        brideFather:
            List<Side>.from(json["bride_side"].map((x) => Side.fromJson(x)))
                .firstWhereOrNull((element) => element.relation == 'father'),
        brideMother:
            List<Side>.from(json["bride_side"].map((x) => Side.fromJson(x)))
                .firstWhereOrNull((element) => element.relation == 'mother'),
        groomFather:
            List<Side>.from(json["groom_side"].map((x) => Side.fromJson(x)))
                .firstWhereOrNull((element) => element.relation == 'father'),
        groomMother:
            List<Side>.from(json["groom_side"].map((x) => Side.fromJson(x)))
                .firstWhereOrNull((element) => element.relation == 'mother'),
      );
}

class Side {
  Side({
    required this.name,
    required this.relation,
    required this.image,
  });

  String name;
  String relation;
  String image;

  factory Side.fromJson(Map<String, dynamic> json) => Side(
        name: json["name"],
        relation: json["relation"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "relation": relation,
        "image": image,
      };
}
