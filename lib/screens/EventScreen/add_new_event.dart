import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/event_provider.dart';
import '../../widgets/mytextformfield.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({Key? key}) : super(key: key);

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  TextEditingController eventnameController = TextEditingController();

  TextEditingController eventDateController = TextEditingController();

  TextEditingController taglineController = TextEditingController();

  TextEditingController eventTimeController = TextEditingController();

  TextEditingController eventVenueController = TextEditingController();

  TextEditingController menDresscodeController = TextEditingController();

  TextEditingController womenDresscodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isDresscode = true;

  File? eventLogo;

  void addEvent() {
    final isValid = _formKey.currentState!.validate();
    if (eventLogo == null) {
      Fluttertoast.showToast(msg: 'Upload event logo ');
    } else {
      if (isValid) {
        Provider.of<EventProvider>(context, listen: false)
            .addNewEdvent(
                marriage_id: sharedPrefs.marriageId,
                event_name: eventnameController.text,
                event_tagline: taglineController.text,
                event_date: eventDateController.text,
                event_time: eventTimeController.text,
                is_dress_code: isDresscode,
                event_venue: eventVenueController.text,
                for_men: menDresscodeController.text,
                for_women: womenDresscodeController.text)
            .then((value) {
          if (value.success) {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: "Event added successfully");
          }
        });
        Navigator.pop(context);
      }
    }
  }

  Future<File?> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: eventLogo!.path,
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
      eventLogo = croppedFile;
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      eventLogo = await getFromGallery();
                      if (eventLogo != null) {
                        eventLogo = await _cropImage();
                      }

                      if (eventLogo == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      } else {
                        setState(() {
                          eventLogo;
                        });
                      }
                    },
                    child: eventLogo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(eventLogo!.path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
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
                    height: 10,
                  ),
                  Text(
                    "upload logo",
                    style: poppinsNormal.copyWith(color: white, fontSize: 12),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextFormField(
                    hintText: "Enter Event Name",
                    lable: "Event Name",
                    controller: eventnameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Event Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextFormField(
                    hintText: "Enter Event Tagline",
                    lable: "Event Tagline",
                    controller: taglineController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Event Tagline";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextFormField(
                    hintText: "Enter Event Date",
                    lable: "Event Date",
                    controller: eventDateController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Event Date";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextFormField(
                    hintText: "Enter Event Time",
                    lable: "Event Time",
                    controller: eventTimeController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Event Time";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextFormField(
                    hintText: "Enter Event Venue",
                    lable: "Event Venue",
                    controller: eventVenueController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Event Venue";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: timeGrey,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Enable Dress Code',
                                  style: poppinsNormal.copyWith(
                                      color: white,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Switch(
                                  value: isDresscode,
                                  onChanged: (value) {
                                    setState(() {
                                      isDresscode = !isDresscode;
                                    });
                                  })
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MyTextFormField(
                            hintText: "Dress code for men",
                            lable: "Men Dress code",
                            isEnable: isDresscode,
                            controller: menDresscodeController,
                            validator: (val) {
                              if (val!.isEmpty && isDresscode == true) {
                                return "Please enter dress code";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: MyTextFormField(
                            hintText: "Dress code for women",
                            lable: "Women Dress code",
                            isEnable: isDresscode,
                            controller: womenDresscodeController,
                            validator: (val) {
                              if (val!.isEmpty && isDresscode == true) {
                                return "Please enter dress code";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          addEvent();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xfff3686d),
                    Color(0xffed2831),
                  ]),
            ),
            height: 45,
            child: AutoSizeText(
              "Add",
              style: gilroyBold.copyWith(fontSize: 18, color: white),
            ),
          ),
        ),
      ),
    );
  }
}
