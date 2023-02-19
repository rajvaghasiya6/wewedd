import 'dart:convert';

import 'package:collection/collection.dart';

WeddingAllDetailModel weddingAllDetailModelFromJson(String str) =>
    WeddingAllDetailModel.fromJson(json.decode(str));

class WeddingAllDetailModel {
  WeddingAllDetailModel({
    required this.marriageLogo,
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
    required this.isPrivate,
    required this.marriageTime,
    required this.fcmTokenMarriage,
    required this.marriageId,
    required this.marriageName,
    required this.weddingDate,
    required this.groomSibling,
    required this.brideSibling,
    required this.brideRelative,
    required this.groomRelative,
    required this.groom,
    required this.bride,
    required this.brideFather,
    required this.brideMother,
    required this.groomFather,
    required this.groomMother,
  });

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
  final bool isPrivate;
  final String fcmTokenMarriage;
  final String marriageId;
  final String marriageTime;
  final String marriageName;
  final String weddingDate;
  List<Side> groomSibling;
  List<Side> brideSibling;
  List<Side> groomRelative;
  List<Side> brideRelative;
  Side? groom;
  Side? groomFather;
  Side? groomMother;
  Side? brideFather;
  Side? brideMother;
  Side? bride;

  factory WeddingAllDetailModel.fromJson(Map<String, dynamic> json) =>
      WeddingAllDetailModel(
        marriageLogo: json["marriage_logo"],
        eventManagerName: json["event_manager_name"],
        weddingHashtag: json["wedding_hashtag"],
        banner: List<String>.from(json["banner"].map((x) => x)),
        invitationCard:
            List<String>.from(json["invitation_card"].map((x) => x)),
        isDark: json["is_dark"],
        marriageTime: json["wedding_time"],
        secondaryColor:
            List<String>.from(json["secondary_color"].map((x) => x)),
        brideName: json["bride_name"],
        groomName: json["groom_name"],
        weddingVenue: json["wedding_venue"],
        mobileNumber: json["mobile_number"],
        isGuestsIdProof: json["is_guests_id_proof"],
        isApprovePost: json["is_approve_post"],
        liveLink: json["live_link"],
        isPrivate: json["is_private"],
        fcmTokenMarriage: json["fcm_token_marriage"],
        marriageId: json["marriage_id"],
        marriageName: json["marriage_name"],
        weddingDate: json["wedding_date"],
        groomSibling:
            List<Side>.from(json["groom_side"].map((x) => Side.fromJson(x)))
                .where((element) => element.relation == 'sibling')
                .toList(),
        brideSibling:
            List<Side>.from(json["bride_side"].map((x) => Side.fromJson(x)))
                .where((element) => element.relation == 'sibling')
                .toList(),
        groomRelative:
            List<Side>.from(json["groom_side"].map((x) => Side.fromJson(x)))
                .where((element) => element.relation == 'relative')
                .toList(),
        brideRelative:
            List<Side>.from(json["bride_side"].map((x) => Side.fromJson(x)))
                .where((element) => element.relation == 'relative')
                .toList(),
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
