class FeedRequest {
  FeedRequest({
    required this.guestId,
    required this.guestName,
    required this.feedId,
    required this.feedImage,
    required this.guestMobileNumber,
    required this.createdDateTime,
    required this.guestProfileImage,
    required this.feedStatus,
    required this.MarriageId,
  });

  final String guestId;
  final String guestName;
  final String feedId;
  final String feedImage;
  final String guestMobileNumber;
  final String createdDateTime;
  final String guestProfileImage;
  final String feedStatus;
  final String MarriageId;

  factory FeedRequest.fromJson(Map<String, dynamic> json) => FeedRequest(
        guestId: json["guest_id"],
        guestName: json["guest_name"],
        guestMobileNumber: json["guest_mobile_number"],
        guestProfileImage: json["guest_profile_image"],
        feedId: json["feed_id"],
        feedImage: json["feed_image"],
        MarriageId: json["marriage_id"],
        createdDateTime: json["created_date_time"],
        feedStatus: json["feed_status"],
      );

  Map<String, dynamic> toJson() => {
        "guest_id": guestId,
        "guest_name": guestName,
        "guest_mobile_number": guestMobileNumber,
        "guest_profile_image": guestProfileImage,
        "feed_id": guestId,
        "feed_image": feedImage,
        "marriage_id": MarriageId,
        "created_date_time": createdDateTime,
        "feed_status": feedStatus,
      };
}
