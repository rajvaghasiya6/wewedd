import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/event_provider.dart';
import '../../providers/theme_provider.dart';
import 'add_new_event.dart';
import 'event_components/event_component.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = context.watch<ThemeProvider>().darkTheme;
    var events = context.watch<EventProvider>().events;
    return Container(
      decoration: BoxDecoration(gradient: greyToWhite),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              CupertinoIcons.back,
              // color: Colors.white,
            ),
          ),
          title: Text(
            "Events",
            style: poppinsBold.copyWith(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<EventProvider>().getEvents();
              },
              child: Column(
                children: [
                  !context.watch<EventProvider>().isLoaded
                      ? const Center(child: CupertinoActivityIndicator())
                      : context.watch<EventProvider>().events.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: !theme
                                      ? BoxDecoration(gradient: greyToWhite)
                                      : const BoxDecoration(),
                                  child: EventComponent(
                                    cIndex: index,
                                    event: events.elementAt(index),
                                  ),
                                );
                              })
                          // !context.watch<EventProvider>().isLoaded
                          //     ? const SliverFillRemaining(
                          //         child: Center(child: CupertinoActivityIndicator()))
                          //     : context.watch<EventProvider>().events.isNotEmpty
                          //         ? ListView(
                          //             children: [
                          //               SliverFixedExtentList(
                          //                 itemExtent: 174.0,
                          //                 delegate: SliverChildBuilderDelegate(
                          //                   (BuildContext context, int eindex) {
                          //                     return Container(
                          //                       decoration: !theme
                          //                           ? BoxDecoration(gradient: greyToWhite)
                          //                           : const BoxDecoration(),
                          //                       child: EventComponent(
                          //                         cIndex: eindex,
                          //                         event: events.elementAt(eindex),
                          //                       ),
                          //                     );
                          //                   },
                          //                   childCount: events.length,
                          //                 ),
                          //               ),
                          //             ],
                          //           )
                          : const Center(child: Text("Data not found..."))
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: sharedPrefs.isAdmin == true
            ? ElevatedButton(
                onPressed: () {
                  nextScreen(context, const AddNewEvent());
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
                    "+ Add New Event",
                    style: poppinsNormal.copyWith(color: grey, fontSize: 14),
                  ),
                ))
            : const SizedBox(),
      ),
    );
  }
}
