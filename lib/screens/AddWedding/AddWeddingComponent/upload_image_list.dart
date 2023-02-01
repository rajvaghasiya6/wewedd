import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';

class UploadImageList extends StatefulWidget {
  UploadImageList({required this.imageList, Key? key}) : super(key: key);
  List<File> imageList = [];
  @override
  State<UploadImageList> createState() => _UploadImageListState();
}

class _UploadImageListState extends State<UploadImageList> {
  File? newImage;
  Future<File?> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: newImage!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.ratio3x2,
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.ratio3x2,
              ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.white,
          backgroundColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          hideBottomControls: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        iosUiSettings: const IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      newImage = croppedFile;
    }
    return croppedFile;
  }

  Future<File?> getFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              newImage = await getFromGallery();
              if (newImage != null) {
                newImage = await _cropImage();
              }

              if (newImage == null) {
                Fluttertoast.showToast(msg: "failed to pick image");
              } else {
                widget.imageList.add(newImage!);
                setState(() {
                  widget.imageList;
                });
              }
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: timeGrey,
              ),
              child: Center(
                child: Text(
                  "+",
                  style: poppinsNormal.copyWith(
                      color: eventGrey,
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          widget.imageList.isNotEmpty
              ? SizedBox(
                  height: 100,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: widget.imageList.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(widget.imageList[index].path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ));
                      }),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
