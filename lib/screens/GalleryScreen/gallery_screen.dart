import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/event_provider.dart';
import '../../providers/galleryProvider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/GradientTabIndicator.dart';
import '../../widgets/mytextformfield.dart';
import 'gallery_tabs/all_tab.dart';

class GalleryScreen extends StatefulWidget {
  final int index;

  const GalleryScreen({required this.index, Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController folderNameController = TextEditingController();
  File? pickedImage;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) async {
      await Provider.of<GalleryProvider>(context, listen: false).getFolder();

      await Provider.of<EventProvider>(context, listen: false).getEvents();
    });
    tabController = TabController(
        vsync: this,
        length: context.read<EventProvider>().events.length +
            1 +
            context.read<GalleryProvider>().folders.length,
        initialIndex: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;

    return Container(
      decoration: BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        body: SafeArea(
          child: DefaultTabController(
            length: Provider.of<EventProvider>(context).events.length +
                1 +
                Provider.of<GalleryProvider>(context).folders.length,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  expandedHeight: 100,
                  flexibleSpace: !theme
                      ? Container(
                          decoration: BoxDecoration(gradient: greyToWhite),
                        )
                      : const SizedBox(),
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.back,
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Gallery",
                      style: gilroyBold.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 7),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Add New Folder",
                                            style: gilroyNormal.copyWith(
                                                fontSize: 18,
                                                letterSpacing: 0.5)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            MyTextFormField(
                                              hintText: "Enter Folder name",
                                              lable: "Folder Name",
                                              controller: folderNameController,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Please Enter Your folder name";
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          if (folderNameController.text
                                                  .trim() !=
                                              '') {
                                            Provider.of<GalleryProvider>(
                                                    context,
                                                    listen: false)
                                                .addFolder(
                                                    marriage_id:
                                                        sharedPrefs.marriageId,
                                                    folder_name:
                                                        folderNameController
                                                            .text
                                                            .trim())
                                                .then((value) async {
                                              if (value.success == true) {
                                                await Provider.of<
                                                            GalleryProvider>(
                                                        context,
                                                        listen: false)
                                                    .getFolder();

                                                Fluttertoast.showToast(
                                                    msg: "Folder Added");

                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                nextScreen(
                                                    context,
                                                    const GalleryScreen(
                                                        index: 0));
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Something Went Wrong");
                                              }
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Enter Folder Name");
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xfff3686d),
                                                  Color(0xffed2831),
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 18),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    'Add',
                                                    textAlign: TextAlign.center,
                                                    style: poppinsBold.copyWith(
                                                      color: white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                        child: SvgPicture.asset(
                          theme
                              ? "icons/add_feed.svg"
                              : "icons/add_feed_white.svg",
                          height: 45,
                          width: 45,
                        ),
                      ),
                    ),
                  ],
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight - 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TabBar(
                          controller: tabController,
                          isScrollable: true,
                          physics: const BouncingScrollPhysics(),
                          indicatorWeight: 2,
                          indicator: MyCustomIndicator(
                            color: theme ? Colors.white : Colors.black,
                            height: 1,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle: gilroyBold.copyWith(fontSize: 13),
                          tabs: List.generate(
                              Provider.of<EventProvider>(context)
                                      .events
                                      .length +
                                  Provider.of<GalleryProvider>(context)
                                      .folders
                                      .length +
                                  1,
                              (index) => index == 0
                                  ? SizedBox(
                                      height: kTextTabBarHeight - 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Text("All"),
                                          SizedBox(
                                            height: 6,
                                          ),
                                        ],
                                      ),
                                    )
                                  : index <=
                                          Provider.of<EventProvider>(context)
                                              .events
                                              .length
                                      ? SizedBox(
                                          height: kTextTabBarHeight - 4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(Provider.of<EventProvider>(
                                                      context)
                                                  .events
                                                  .elementAt(index - 1)
                                                  .eventName),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: kTextTabBarHeight - 4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(Provider.of<GalleryProvider>(
                                                      context)
                                                  .folders
                                                  .elementAt(index -
                                                      1 -
                                                      Provider.of<EventProvider>(
                                                              context)
                                                          .events
                                                          .length)
                                                  .folderName),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                            ],
                                          ),
                                        )),
                        ),
                      ),
                    ),
                  ),
                )
              ],
              floatHeaderSlivers: true,
              body: TabBarView(
                  controller: tabController,
                  children: List.generate(
                    Provider.of<EventProvider>(context).events.length +
                        1 +
                        Provider.of<GalleryProvider>(context).folders.length,
                    (index) => AllTab(
                      index: index,
                    ),
                  ).toList()),
            ),
          ),
        ),
      ),
    );
  }
}
