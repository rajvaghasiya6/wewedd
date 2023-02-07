import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../general/color_constants.dart';
import '../../general/navigation.dart';
import '../../general/shared_preferences.dart';
import '../../general/text_styles.dart';
import '../../providers/event_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_sliverappbar.dart';
import '../../widgets/loader.dart';
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
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<EventProvider>().getEvents();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CustomSliverAppBar(
                  title: "Events",
                ),
                !context.watch<EventProvider>().isLoaded
                    ? const SliverFillRemaining(child: Loader())
                    : context.watch<EventProvider>().events.isNotEmpty
                        ? SliverFixedExtentList(
                            itemExtent: 174.0,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int eindex) {
                                return Container(
                                  decoration: !theme
                                      ? BoxDecoration(gradient: greyToWhite)
                                      : const BoxDecoration(),
                                  child: EventComponent(
                                    cIndex: eindex,
                                    event: events.elementAt(eindex),
                                  ),
                                );
                              },
                              childCount: events.length,
                            ),
                          )
                        : const SliverFillRemaining(
                            child: Center(child: Text("Data not found...")))
              ],
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
