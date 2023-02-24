

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/general/text_styles.dart';
import 'package:wedding/providers/dashboard_provider.dart';
import 'package:wedding/widgets/custom_sliverappbar.dart';


import 'package:webview_flutter/webview_flutter.dart';

import 'dart:io';
// class InAppWebViewScreenRSVPRSVP extends StatefulWidget {
//   const InAppWebViewScreenRSVPRSVP({required this.marriage_id,Key? key}) : super(key: key);final String marriage_id;

//   @override
//   State<InAppWebViewScreenRSVPRSVP> createState() => _InAppWebViewScreenRSVPRSVPState();
// }

// class _InAppWebViewScreenRSVPRSVPState extends State<InAppWebViewScreenRSVPRSVP> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//             url: Uri.parse(
//                 "http://103.120.178.188/wedding/wedding.html?id=${widget.marriage_id}")),
//       ),
//     );
//   }
// }


// class WebViewScreenRSVP extends StatefulWidget {
//   const WebViewScreenRSVP({required this.marriage_id,Key? key}) : super(key: key);
//   final String marriage_id;

//   @override
//   WebViewExampleState createState() => WebViewExampleState();
// }

// class WebViewExampleState extends State<WebViewScreenRSVP> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     // Enable virtual display.
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//   }

//   JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//     return JavascriptChannel(
//         name: 'Toaster',
//         onMessageReceived: (JavascriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           WebView(
//             initialUrl:
//                 "http://103.120.178.188/wedding/wedding.html?id=${widget.marriage_id}",
//             allowsInlineMediaPlayback: true,
//             javascriptMode: JavascriptMode.unrestricted,
//             gestureNavigationEnabled: true,
//             zoomEnabled: true,
//             initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
//             javascriptChannels: {
//               _toasterJavascriptChannel(context),
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


class WebViewContainer extends StatefulWidget {
  final marriage_id;

  WebViewContainer({this.marriage_id});

  @override
  createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {

  final _key = UniqueKey();

  _WebViewContainerState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: 'http://103.120.178.188/wedding/wedding.html?id=${widget.marriage_id}'))
          ],
        ));
  }
}

class WebViewBlankRSVP extends StatelessWidget {
  const WebViewBlankRSVP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const CustomSliverAppBar(title: ""),
            SliverFillRemaining(
              child: Center(
                child: Text(
                  "No preview available at this time",
                  style: gilroyLight.copyWith(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
