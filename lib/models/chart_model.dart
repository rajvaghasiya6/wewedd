// To parse this JSON data, do
//
//     final ChartModel = ChartModelFromJson(jsonString);

class ChartModel {
  ChartModel({
    required this.brideSide,
    required this.groomSide,
  });

  Side brideSide;
  Side groomSide;

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        brideSide: Side.fromJson(json["bride_side"]),
        groomSide: Side.fromJson(json["groom_side"]),
      );

  Map<String, dynamic> toJson() => {
        "bride_side": brideSide.toJson(),
        "groom_side": groomSide.toJson(),
      };
}

class Side {
  Side({
    required this.guests,
    required this.points,
  });

  List<int> guests;
  List<int> points;

  factory Side.fromJson(Map<String, dynamic> json) => Side(
        guests: List<int>.from(json["guests"].map((x) => x)),
        points: List<int>.from(json["points"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "guests": List<dynamic>.from(guests.map((x) => x)),
        "points": List<dynamic>.from(points.map((x) => x)),
      };
}
