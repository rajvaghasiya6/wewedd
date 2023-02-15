import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';

import '../../../general/color_constants.dart';
import '../../../general/navigation.dart';
import '../../../general/shared_preferences.dart';
import '../../../general/string_constants.dart';
import '../../../general/text_styles.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/galleryProvider.dart';
import '../../../providers/theme_provider.dart';
import '../gallery_image.dart';
import '../gallery_screen.dart';

class AllTab extends StatefulWidget {
  final int index;

  const AllTab({required this.index, Key? key}) : super(key: key);

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab>
    with AutomaticKeepAliveClientMixin<AllTab> {
  @override
  bool get wantKeepAlive => true;
  bool isLoaded = false;
  bool isLoading = false;
  bool isLoadingMore = false;
  List images = [];
  int page = 1;
  int maxLimit = 1;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    await Future.delayed(const Duration(milliseconds: 0)).then((value) async {
      if (!isLoaded) {
        if (widget.index != 0) {
          if (widget.index <=
              Provider.of<EventProvider>(context, listen: false)
                  .events
                  .length) {
            setState(() {
              isLoading = true;
            });
            await Provider.of<GalleryProvider>(context, listen: false)
                .getGalleryByEvent(
                    eventId: context
                        .read<EventProvider>()
                        .events[widget.index - 1]
                        .eventId,
                    page: 1)
                .then((value) {
              images = value.data!;
              setState(() {
                if (value.pagination != null) {
                  maxLimit = value.pagination!.last!.page;
                }
                isLoading = false;
                isLoaded = true;
              });
            });
          }
          // else{
          //   setState(() {
          //     isLoading = true;
          //   });
          //   await Provider.of<GalleryProvider>(context, listen: false)
          //       .getGallery(
          //           eventId: context
          //               .read<EventProvider>()
          //               .events[widget.index - 1]
          //               .eventId,
          //           page: 1)
          //       .then((value) {
          //     images = value.data!;
          //     setState(() {
          //       if (value.pagination != null) {
          //         maxLimit = value.pagination!.last!.page;
          //       }
          //       isLoading = false;
          //       isLoaded = true;
          //     });
          //   });
          // }

        } else {
          setState(() {
            isLoading = true;
          });
          await Provider.of<GalleryProvider>(context, listen: false)
              .getGalleryByEvent(eventId: "", page: 1)
              .then((value) {
            images = value.data!;
            setState(() {
              if (value.pagination != null) {
                maxLimit = value.pagination!.last!.page;
              }
              isLoading = false;
            });
          });
        }
      }
    });
  }

  _loadMore() async {
    if (page < maxLimit) {
      setState(() {
        page++;
      });
      if (widget.index != 0) {
        setState(() {
          isLoadingMore = true;
        });
        await Provider.of<GalleryProvider>(context, listen: false)
            .getGalleryByEvent(
                eventId: context
                    .read<EventProvider>()
                    .events[widget.index - 1]
                    .eventId,
                page: page)
            .then((value) {
          if (value.data != null) {
            images.addAll(value.data!);
          }
          setState(() {
            isLoadingMore = false;
          });
        });
      } else {
        setState(() {
          isLoadingMore = true;
        });
        await Provider.of<GalleryProvider>(context, listen: false)
            .getGalleryByEvent(eventId: "", page: page)
            .then((value) {
          if (value.data != null) {
            images.addAll(value.data!);
          }
          setState(() {
            isLoadingMore = false;
          });
        });
      }
    }
  }

  Future<void> _cropImage(bool isFirst) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedImage!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio7x5,
              ]
            : [
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio7x5,
              ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.white,
          backgroundColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          hideBottomControls: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
        ),
        iosUiSettings: const IOSUiSettings(
          title: '',
        ));
    if (croppedFile != null) {
      pickedImage = croppedFile;
      _addGallery();
    }
  }

  _addGallery() async {
    if (widget.index <=
        Provider.of<EventProvider>(context, listen: false).events.length) {
      var eventid = Provider.of<EventProvider>(context, listen: false)
          .events
          .elementAt(widget.index - 1)
          .eventId;
      FormData data = FormData.fromMap(
          {"marriage_id": sharedPrefs.marriageId, "event_id": eventid});
      data.files.add(MapEntry(
        "gallery_image",
        await MultipartFile.fromFile(pickedImage!.path),
      ));

      Provider.of<GalleryProvider>(context, listen: false)
          .addGalleryPhoto(formData: data)
          .then((value) {
        if (value.success) {
          Navigator.pop(context);
          nextScreen(context, GalleryScreen(index: widget.index));
        } else {
          Fluttertoast.showToast(msg: "Fail to Upload Image");
        }
      });
    } else {
      var folderid = Provider.of<GalleryProvider>(context, listen: false)
          .folders
          .elementAt(widget.index -
              1 -
              Provider.of<EventProvider>(context, listen: false).events.length)
          .folderId;
      FormData data = FormData.fromMap(
          {"marriage_id": sharedPrefs.marriageId, "folder_id": folderid});
      data.files.add(MapEntry(
        "gallery_image",
        await MultipartFile.fromFile(pickedImage!.path),
      ));

      Provider.of<GalleryProvider>(context, listen: false)
          .addGalleryPhoto(formData: data)
          .then((value) {
        if (value.success) {
          Navigator.pop(context);
          nextScreen(context, GalleryScreen(index: widget.index));
        } else {
          Fluttertoast.showToast(msg: "Fail to Upload Image");
        }
      });
    }
  }

  Future<File?> getFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> getFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  void _imagePick() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      pickedImage = await getFromCamera();
                      _cropImage(true);

                      if (pickedImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      }
                      setState(() {});

                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                      title: Text(
                        "Take Photo",
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      pickedImage = await getFromGallery();
                      _cropImage(true);

                      if (pickedImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 15),
                        child: Icon(Icons.image),
                      ),
                      title: Text(
                        "Choose from Gallery",
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0, bottom: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = context.watch<ThemeProvider>().darkTheme;
    var isUpload = context.watch<GalleryProvider>().isUploading;
    return Scaffold(
      body: isUpload
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Container(
              decoration: theme
                  ? const BoxDecoration()
                  : BoxDecoration(gradient: greyToWhite),
              child: isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _loadData();
                      },
                      child: Provider.of<GalleryProvider>(context,
                                  listen: false)
                              .galleryData
                              .isNotEmpty
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (scrollNotification) {
                                if (scrollNotification
                                        .metrics.maxScrollExtent ==
                                    scrollNotification.metrics.pixels) {
                                  _loadMore();
                                }
                                return false;
                              },
                              child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        right: 20,
                                        left: 20,
                                        bottom: 0),
                                    child: MasonryGrid(
                                      column: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      // staggered: true,
                                      children: List.generate(
                                        isLoadingMore
                                            ? images.length + 1
                                            : images.length,
                                        (i) => (i == images.length)
                                            ? const CupertinoActivityIndicator()
                                            : GestureDetector(
                                                onTap: () {
                                                  nextScreen(
                                                      context,
                                                      GalleryImage(
                                                        imageData: images,
                                                        currentIndex: i,
                                                      ));
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        StringConstants.apiUrl +
                                                            images.elementAt(i),
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 100,
                                                      width: 100,
                                                      color: grey,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(
                                                            Icons.broken_image),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )),
                              ),
                            )
                          : const Center(child: Text("No image found...")),
                    ),
            ),
      floatingActionButton: sharedPrefs.isAdmin == true && widget.index != 0
          ? ElevatedButton(
              onPressed: () {
                _imagePick();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: timeGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 15.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "+ Add New Photo",
                  style: poppinsNormal.copyWith(color: grey, fontSize: 14),
                ),
              ))
          : const SizedBox(),
    );
  }
}
