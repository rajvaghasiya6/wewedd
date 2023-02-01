import 'package:flutter/material.dart';

class GuestRequestAllTab extends StatefulWidget {
  const GuestRequestAllTab({Key? key}) : super(key: key);

  @override
  State<GuestRequestAllTab> createState() => _GuestRequestAllTabState();
}

class _GuestRequestAllTabState extends State<GuestRequestAllTab>
    with AutomaticKeepAliveClientMixin<GuestRequestAllTab> {
  @override
  bool get wantKeepAlive => true;

  bool isLoaded = false, isLoading = false;
  //List<GuestFeedModel> allRequest = [];

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(milliseconds: 0)).then((value) {
    //   if (!isLoaded) {
    //     setState(() {
    //       isLoading = true;
    //     });
    //     Provider.of<UserFeedProvider>(context, listen: false)
    //         .getGuestFeed(type: "All")
    //         .then((value) {
    //       images = value.data!;
    //       setState(() {
    //         isLoaded = true;
    //         isLoading = false;
    //       });
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return
        //isLoading
        // ? const Loader()
        // : images.isEmpty && isLoaded
        //    ?
        const Center(child: Text("No request found..."));
    // : SquareImage(
    //     images: images,
    //   );
  }
}
