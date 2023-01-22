import 'package:hive/hive.dart';

part 'recent_search_model.g.dart';

@HiveType(typeId: 0)
class RecentSearch {
  @HiveField(0)
  final String hashtag;
  @HiveField(1)
  final String weddingName;
  @HiveField(2)
  final String weddingDate;
  @HiveField(3)
  final String marriageId;
  @HiveField(4)
  final DateTime searchTime;

  RecentSearch(
      {required this.hashtag,
      required this.weddingName,
      required this.weddingDate,
      required this.marriageId,
      required this.searchTime});
}
