import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

import '../../../general/color_constants.dart';
import '../../../general/text_styles.dart';
import '../../../widgets/mytextformfield.dart';
import '../add_wedding_screen.dart';

addNewEventDialog(BuildContext context, List<AddEventModel> events) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    context: context,
    builder: (ctx) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: AddNewEventSheet(events: events),
      );
    },
  );
}

class AddNewEventSheet extends StatefulWidget {
  AddNewEventSheet({required this.events, Key? key}) : super(key: key);
  List<AddEventModel> events;
  @override
  State<AddNewEventSheet> createState() => _AddNewEventSheetState();
}

class _AddNewEventSheetState extends State<AddNewEventSheet> {
  TextEditingController eventnameController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController taglineController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();

  TextEditingController menDresscodeController = TextEditingController();
  TextEditingController womenDresscodeController = TextEditingController();
  final _formKeyEvent = GlobalKey<FormState>();
  bool isDresscode = true;
  File? eventLogo;

  @override
  void initState() {
    super.initState();
  }

  void addEvent() {
    final isValid = _formKeyEvent.currentState!.validate();
    if (eventLogo == null) {
      Fluttertoast.showToast(msg: 'Upload event logo ');
    } else {
      if (isValid) {
        widget.events.add(AddEventModel(
          eventVenue: eventVenueController.text.trim(),
          eventDate: DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd-MM-yyyy').parse(eventDateController.text))
              .toString(),
          eventLogo: eventLogo,
          eventName: eventnameController.text.trim(),
          eventTagline: taglineController.text.trim(),
          eventTime: eventTimeController.text.trim(),
          isDresscode: isDresscode,
          menDresscode: menDresscodeController.text.trim(),
          womenDresscode: womenDresscodeController.text.trim(),
        ));
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Padding(
        padding:
            const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 10),
        child: Form(
          key: _formKeyEvent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 4),
                child: AutoSizeText("Add Event",
                    style: gilroyBold.copyWith(fontSize: 22)),
              ),
              GestureDetector(
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
                hintText: "Enter Event Date (dd-MM-yyyy)",
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
              InkWell(
                onTap: () {
                  addEvent();
                },
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
            ],
          ),
        ),
      ),
    ]));
  }
}
