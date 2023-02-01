import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';
import '../../../widgets/mytextformfield.dart';

class TextFieldWithImage extends StatefulWidget {
  TextFieldWithImage(
      {required this.newImage,
      required this.nameController,
      required this.hintText,
      required this.lable,
      required this.validatorMsg,
      Key? key})
      : super(key: key);
  final TextEditingController nameController;
  File? newImage;
  String hintText;
  String lable;
  String validatorMsg;
  @override
  State<TextFieldWithImage> createState() => _TextFieldWithImageState();
}

class _TextFieldWithImageState extends State<TextFieldWithImage> {
  File? image;
  Future<File?> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
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
      image = croppedFile;
    }
    return image;
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
    return MyTextFormField(
      hintText: widget.hintText,
      lable: widget.lable,
      controller: widget.nameController,
      suffixIcon: GestureDetector(
        onTap: () async {
          image = await getFromGallery();
          if (image != null) {
            image = await _cropImage();
            setState(() {
              widget.newImage = image;
            });
          } else {
            Fluttertoast.showToast(msg: "failed to pick image");
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 15.0),
          child: Container(
            height: 40,
            width: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: lightBlack,
            ),
            child: Center(
              child: widget.newImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(widget.newImage!.path),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      "+",
                      style: poppinsBold.copyWith(color: white, fontSize: 22),
                    ),
            ),
          ),
        ),
      ),
      validator: (phone) {
        if (phone!.isEmpty) {
          return widget.validatorMsg;
        }
        return null;
      },
    )
        //   ],
        // )
        ;
  }
}
