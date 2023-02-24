import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:wedding/screens/webview_screen/webview_screen_rsvp.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/show_notification.dart';
import '../../general/string_constants.dart';
import '../../general/text_styles.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/galleryProvider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/user_button.dart';
import '../EventScreen/event_screen.dart';
import '../GalleryScreen/gallery_screen.dart';
import '../NotificationScreen/notification_screen.dart';
import '../ProfileScreen/profile_screen.dart';
import '../VideoScreen/video_screen.dart';
import '../WardrobeScreen/wardrobe_screen.dart';
import '../webview_screen/in_app_webview.dart';
import '../webview_screen/webview_screen.dart';
import 'home_components/clay_icon.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin<DashboardScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    ShowNotification.initialize();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<DashboardProvider>().getDashboard();
    });
    _loadEvents();
    _loadFolder();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(const AssetImage("assets/thumbnail.jpeg"), context);
  }

  _loadEvents() {
    Provider.of<EventProvider>(context, listen: false).getEvents();
  }

  _loadFolder() {
    Provider.of<GalleryProvider>(context, listen: false).getFolder();
  }

  bool isVideo(String filename) {
    if (filename.contains("mkv")) {
      return true;
    }
    if (filename.contains("mp4")) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = context.watch<ThemeProvider>().darkTheme;
    var dashboard = context.watch<DashboardProvider>();
    var dashboardData = context.watch<DashboardProvider>().dashboardModel;
    var isCountdown = context.watch<DashboardProvider>().isCountdown;
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: !dashboard.isLoaded
              ? const Center(child: CupertinoActivityIndicator())
              : dashboard.dashboardModel == null
                  ? const Center(
                      child: Text("Data load failed"),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await context.read<DashboardProvider>().getDashboard();
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 30, right: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Future.delayed(const Duration(
                                                  milliseconds: 0))
                                              .then((value) {
                                            context
                                                .read<ThemeProvider>()
                                                .setDark();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.back,
                                          // color: Colors.white,
                                        ),
                                      ),
                                      UserButton(
                                        url: sharedPrefs.guestProfileImage,
                                        size: 45,
                                        pushScreen: () {
                                          nextScreen(
                                              context, const ProfileScreen());
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          nextScreen(context,
                                              const NotificationScreen());
                                        },
                                        child: SvgPicture.asset(
                                          theme
                                              ? "icons/bell.svg"
                                              : "icons/white_bell.svg",
                                          height: 45,
                                          width: 45,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            HomeScreen.pageControl.currentState!
                                                .jumpToFeed();
                                          },
                                          child: SvgPicture.asset(
                                            theme
                                                ? "icons/feed.svg"
                                                : "icons/white_feed.svg",
                                            height: 45,
                                            width: 45,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //  if (date != null)
                            // if (!date!.isNegative)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                height: 210,
                                width: MediaQuery.of(context).size.width * 0.84,
                                padding: const EdgeInsets.only(
                                    top: 25, left: 30, bottom: 25, right: 30),
                                decoration: BoxDecoration(
                                    color: theme ? white : black,
                                    gradient:
                                        theme ? blackToBlack : greyToWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      if (!theme)
                                        const BoxShadow(
                                            color: Color(0x66a9aaaf),
                                            spreadRadius: 8,
                                            blurRadius: 8,
                                            offset: Offset(3, 3),
                                            blurStyle: BlurStyle.normal),
                                      if (!theme)
                                        const BoxShadow(
                                            color: Color(0xd3ffffff),
                                            spreadRadius: 15,
                                            blurRadius: 15,
                                            offset: Offset(-3, -3),
                                            blurStyle: BlurStyle.normal),
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                "Time",
                                                style: theme
                                                    ? gilroyBold
                                                    : gilroyBold.copyWith(
                                                        color: timeGrey),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                "remaining",
                                                style: theme
                                                    ? gilroyLight
                                                    : gilroyLight.copyWith(
                                                        color: timeGrey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 70,
                                          width: 70,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: theme
                                                ? white
                                                : timeGrey.withOpacity(0.07),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: dashboard.dashboardModel!
                                                    .marriageLogo.isNotEmpty
                                                ? CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        StringConstants.apiUrl +
                                                            dashboard
                                                                .dashboardModel!
                                                                .marriageLogo,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CupertinoActivityIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Text(
                                                      'LOGO',
                                                      style: greyBold.copyWith(
                                                          color: black),
                                                    ),
                                                  )
                                                : Text(
                                                    'LOGO',
                                                    style: greyBold.copyWith(
                                                        color: black),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    DateTime.parse(dashboardData!.weddingDate)
                                            .difference(DateTime.now())
                                            .isNegative
                                        ? const Text('Wedding Over')
                                        : Row(
                                            children: [
                                              isCountdown
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SlideCountdownSeparated(
                                                          textStyle: theme
                                                              ? gilroyBold
                                                              : gilroyBold.copyWith(
                                                                  color:
                                                                      timeGrey),
                                                          height: 45,
                                                          width: 45,
                                                          showZeroValue: true,
                                                          decoration: BoxDecoration(
                                                              color: grey
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          duration: (DateTime.parse(
                                                                  dashboardData
                                                                      .weddingDate)
                                                              .difference(
                                                                  DateTime
                                                                      .now())),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Days",
                                                              style: TextStyle(
                                                                  color: grey,
                                                                  fontSize: 11),
                                                            ),
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            Text(
                                                              "Hours",
                                                              style: TextStyle(
                                                                  color: grey,
                                                                  fontSize: 11),
                                                            ),
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            Text(
                                                              "Mins",
                                                              style: TextStyle(
                                                                  color: grey,
                                                                  fontSize: 11),
                                                            ),
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            Text(
                                                              "Secs",
                                                              style: TextStyle(
                                                                  color: grey,
                                                                  fontSize: 11),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox(),
                                              const Spacer(),
                                              Switch(
                                                activeColor:
                                                    theme ? white : grey,
                                                value: isCountdown,
                                                onChanged: (bool value) {
                                                  context
                                                      .read<DashboardProvider>()
                                                      .isCountdownChange();
                                                },
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            dashboardData.banner.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "#" +
                                          dashboard
                                              .dashboardModel!.weddingHashtag,
                                      style: gilroyBold.copyWith(
                                        fontSize: 20,
                                        color: theme
                                            ? white.withOpacity(0.12)
                                            : eventGrey.withOpacity(0.3),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Stack(
                                      alignment: Alignment.topLeft,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 35.0, bottom: 10),
                                          child: Text(
                                            "#" +
                                                dashboard.dashboardModel!
                                                    .weddingHashtag,
                                            style: gilroyBold.copyWith(
                                              fontSize: 20,
                                              color: theme
                                                  ? white.withOpacity(0.12)
                                                  : eventGrey.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: CarouselSlider.builder(
                                            options: CarouselOptions(
                                              enlargeStrategy:
                                                  CenterPageEnlargeStrategy
                                                      .height,
                                              //height: 220,
                                              aspectRatio: 1.78,
                                              viewportFraction: 0.87,
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                            ),
                                            itemCount:
                                                dashboardData.banner.length,
                                            itemBuilder: (context, itemIndex,
                                                realIndex) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                // clipBehavior: Clip.antiAlias,
                                                margin: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 14.0,
                                                    top: 14),
                                                decoration: theme
                                                    ? BoxDecoration(
                                                        color: scaffoldBlack,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Color(
                                                                  0xff332e34),
                                                              blurRadius: 6,
                                                              spreadRadius: 1,
                                                              offset: Offset(
                                                                  -2, -2)),
                                                          BoxShadow(
                                                              color: Color(
                                                                  0xff050509),
                                                              blurRadius: 6,
                                                              spreadRadius: 2,
                                                              offset:
                                                                  Offset(3, 3)),
                                                        ],
                                                      )
                                                    : BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        gradient: greyToWhite,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    -2, -2),
                                                            blurRadius: 6,
                                                            spreadRadius: 2,
                                                            color: white,
                                                          ),
                                                          BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    3, 3),
                                                            blurRadius: 6,
                                                            spreadRadius: 1,
                                                            color: grey
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ],
                                                      ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 11),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    child: isVideo(dashboardData
                                                            .banner
                                                            .elementAt(
                                                                itemIndex))
                                                        ? GestureDetector(
                                                            behavior:
                                                                HitTestBehavior
                                                                    .opaque,
                                                            onTap: () {
                                                              nextScreen(
                                                                context,
                                                                VideoScreen(
                                                                    url:
                                                                        "${StringConstants.apiUrl}${dashboardData.banner.elementAt(itemIndex)}"),
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: theme
                                                                  ? BoxDecoration(
                                                                      color:
                                                                          black)
                                                                  : BoxDecoration(
                                                                      color:
                                                                          white),
                                                              child: Center(
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/thumbnail.jpeg",
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      height:
                                                                          1080,
                                                                      width:
                                                                          1920,
                                                                    ),
                                                                    const Icon(
                                                                      CupertinoIcons
                                                                          .play,
                                                                      size: 30,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                "${StringConstants.apiUrl}${dashboardData.banner.elementAt(itemIndex)}",
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(),
                                                          ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClayIcon(
                                    name: "Events",
                                    path: theme
                                        ? "icons/events.svg"
                                        : "icons/events_grey.svg",
                                    pushTo: const EventScreen(),
                                  ),
                                  ClayIcon(
                                    name: "Wardrobe\nPlanner",
                                    path: theme
                                        ? "icons/angle.svg"
                                        : "icons/angle_grey.svg",
                                    pushTo: const WardrobeScreen(),
                                  ),
                                  ClayIcon(
                                    name: "Gallery",
                                    path: theme
                                        ? "icons/gallery.svg"
                                        : "icons/gallery_grey.svg",
                                    pushTo: const GalleryScreen(
                                      index: 0,
                                    ),
                                  ),
                                  ClayIcon(
                                    name: "View\nLive",
                                    path: theme
                                        ? "icons/eye.svg"
                                        : "icons/eye_grey.svg",
                                    url:
                                        dashboard.dashboardModel!.liveLink != ""
                                            ? dashboard.dashboardModel!.liveLink
                                            : null,
                                    pushTo: (dashboard.dashboardModel != null &&
                                            dashboard
                                                    .dashboardModel!.liveLink !=
                                                "")
                                        ? const InAppWebViewScreen()
                                        : const WebViewBlank(),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                AutoSizeText(
                                  "#" +
                                      dashboard.dashboardModel!.weddingHashtag,
                                  maxLines: 1,
                                  style: theme
                                      ? gilroyBold.copyWith(
                                          fontSize: 32,
                                          color: black.withOpacity(0.27))
                                      : gilroyBold.copyWith(
                                          fontSize: 32,
                                          color: black.withOpacity(0.11)),
                                ),
                                AutoSizeText(
                                  "Itinerary",
                                  style: theme
                                      ? hastan.copyWith(
                                          color: context
                                              .watch<ThemeProvider>()
                                              .secondaryColor,
                                          fontSize: 32)
                                      : hastan.copyWith(
                                          color: context
                                              .watch<ThemeProvider>()
                                              .secondaryColor
                                              .withOpacity(0.58),
                                          fontSize: 32),
                                )
                              ],
                            ),
                            dashboardData.invitationCard.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, left: 8, right: 8, top: 8),
                                    child: CarouselSlider(
                                      carouselController: _controller,
                                      options: CarouselOptions(
                                        height: 460.0,
                                        aspectRatio: 16 / 9,
                                        enlargeCenterPage: true,
                                        viewportFraction: 0.9,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        autoPlay: true,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.height,
                                      ),
                                      items: dashboardData.invitationCard.map((
                                        bannerData,
                                      ) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  margin: const EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                      top: 3,
                                                      bottom: 3),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        grey.withOpacity(0.01),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
                                                    boxShadow: [
                                                      if (theme)
                                                        const BoxShadow(
                                                            color: Color(
                                                                0xff332e34),
                                                            blurRadius: 6,
                                                            spreadRadius: 1,
                                                            offset:
                                                                Offset(-2, -2)),
                                                      if (theme)
                                                        const BoxShadow(
                                                            color: Color(
                                                                0xff050509),
                                                            blurRadius: 6,
                                                            spreadRadius: 2,
                                                            offset:
                                                                Offset(3, 3)),
                                                      if (!theme)
                                                        BoxShadow(
                                                          offset: const Offset(
                                                              -2, -2),
                                                          blurRadius: 6,
                                                          spreadRadius: 2,
                                                          color: white,
                                                        ),
                                                      if (!theme)
                                                        BoxShadow(
                                                          offset: const Offset(
                                                              3, 3),
                                                          blurRadius: 6,
                                                          spreadRadius: 1,
                                                          color: grey
                                                              .withOpacity(0.3),
                                                        ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    decoration: theme
                                                        ? BoxDecoration(
                                                            color:
                                                                scaffoldBlack,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0),
                                                          )
                                                        : BoxDecoration(
                                                            color: white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14.0),
                                                            gradient:
                                                                greyToWhiteDiagonal,
                                                          ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "${StringConstants.apiUrl}$bannerData",
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 190.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: black,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: lightBlack,
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: grey
                                                                  .withOpacity(
                                                                      0.4),
                                                            ),
                                                            child: const Icon(Icons
                                                                .broken_image),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: dashboardData.invitationCard
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () =>
                                      _controller.animateToPage(entry.key),
                                  child: Container(
                                    width: 7.0,
                                    height: 7.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(_current == entry.key
                                                ? 0.9
                                                : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Groom Side",
                                    style: poppinsBold.copyWith(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      dashboardData.groom != null
                                          ? PersonTitle(
                                              theme: theme,
                                              image: dashboardData.groom?.image,
                                              name: dashboardData.groom?.name,
                                              relation:
                                                  dashboardData.groom?.relation)
                                          : const SizedBox(),
                                      dashboardData.groomFather != null
                                          ? PersonTitle(
                                              theme: theme,
                                              image: dashboardData
                                                  .groomFather?.image,
                                              name: dashboardData
                                                  .groomFather?.name,
                                              relation: dashboardData
                                                  .groomFather?.relation)
                                          : const SizedBox(),
                                      dashboardData.groomMother != null
                                          ? PersonTitle(
                                              theme: theme,
                                              image: dashboardData
                                                  .groomMother?.image,
                                              name: dashboardData
                                                  .groomMother?.name,
                                              relation: dashboardData
                                                  .groomMother?.relation)
                                          : const SizedBox(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Bride Side",
                                    style: poppinsBold.copyWith(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      dashboardData.bride != null
                                          ? PersonTitle(
                                              theme: theme,
                                              image: dashboardData.bride?.image,
                                              name: dashboardData.bride?.name,
                                              relation:
                                                  dashboardData.bride?.relation)
                                          : const SizedBox(),
                                      dashboardData.brideFather != null
                                          ? PersonTitle(
                                              theme: theme,
                                              image: dashboardData
                                                  .brideFather?.image,
                                              name: dashboardData
                                                  .brideFather?.name,
                                              relation: dashboardData
                                                  .brideFather?.relation)
                                          : const SizedBox(),
                                      dashboardData.brideMother != null
                                          ? PersonTitle(
                                              theme: theme,
                                              image: dashboardData
                                                  .brideMother?.image,
                                              name: dashboardData
                                                  .brideMother?.name,
                                              relation: dashboardData
                                                  .brideMother?.relation)
                                          : const SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: theme
                                            ? timeGrey
                                            : timeGrey.withOpacity(0.07),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18, horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${dashboardData.groom!.name.split(' ').length > 1 ? dashboardData.groom!.name.split(' ')[1] : dashboardData.groom!.name} & ${dashboardData.bride!.name.split(' ').length > 1 ? dashboardData.bride!.name.split(' ')[1] : dashboardData.bride!.name} Family Welcomes you",
                                              style: poppinsBold.copyWith(
                                                  color: theme ? white : grey,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: InkWell(onTap:(){if(dashboardData.marriageId!=null||dashboardData.marriageId!=''){
                                nextScreen(context, WebViewContainer(marriage_id: dashboardData.marriageId,));
                              }else{
                                nextScreen(context, WebViewBlankRSVP());
                                        
                              }}
                              ,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: theme
                                                    ? lightBlack
                                                    : timeGrey.withOpacity(0.07),
                                                width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "RSVP",
                                                style: poppinsBold.copyWith(
                                                    color: theme ? white : grey,
                                                    fontSize: 15),
                                              ),
                                              Icon(Icons.keyboard_arrow_right,
                                                  color: theme ? white : grey),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

Widget PersonTitle(
    {required bool theme,
    required String? image,
    required String? name,
    required String? relation}) {
  return Column(
    children: [
      Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: grey.withOpacity(0.01),
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: [
                if (theme)
                  const BoxShadow(
                      color: Color(0xff332e34),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: Offset(-2, -2)),
                if (theme)
                  const BoxShadow(
                      color: Color(0xff050509),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(3, 3)),
                if (!theme)
                  BoxShadow(
                    offset: const Offset(-2, -2),
                    blurRadius: 6,
                    spreadRadius: 2,
                    color: white,
                  ),
                if (!theme)
                  BoxShadow(
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                    spreadRadius: 1,
                    color: grey.withOpacity(0.3),
                  ),
              ],
            ),
            child: Container(
              decoration: theme
                  ? BoxDecoration(
                      color: scaffoldBlack,
                      borderRadius: BorderRadius.circular(14.0),
                    )
                  : BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(14.0),
                      gradient: greyToWhiteDiagonal,
                    ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: CachedNetworkImage(
                    imageUrl: "${StringConstants.apiUrl}$image",
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: 190.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: black,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightBlack,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: grey.withOpacity(0.4),
                      ),
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 16,
            child: Text(
              relation ?? '',
              style: poppinsBold.copyWith(color: white, fontSize: 12),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        name ?? '',
        style: poppinsNormal.copyWith(color: grey),
      ),
    ],
  );
}
