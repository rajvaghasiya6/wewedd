import 'dart:convert';

FolderModel folderModelFromJson(String str) =>
    FolderModel.fromJson(json.decode(str));

String folderModelToJson(FolderModel data) => json.encode(data.toJson());

class FolderModel {
  FolderModel({
    required this.folderName,
    required this.folderId,
    required this.marriageId,
  });

  String folderName;
  String marriageId;
  String folderId;

  factory FolderModel.fromJson(Map<String, dynamic> json) => FolderModel(
        folderName: json["folder_name"],
        folderId: json["folder_id"],
        marriageId: json["marriage_id"],
      );

  Map<String, dynamic> toJson() => {
        "folder_name": folderName,
        "folder_id": folderId,
        "marriage_id": marriageId,
      };
}
