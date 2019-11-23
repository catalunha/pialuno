import 'package:flutter/material.dart';
enum JavascriptMode {
  /// JavaScript execution is disabled.
  disabled,

  /// JavaScript execution is not restricted.
  unrestricted,
}
class WebView extends StatefulWidget {
  /// The initial URL to load.
  final String initialUrl;
  
  /// Whether Javascript execution is enabled.
  final JavascriptMode javascriptMode;

  const WebView({
    Key key,
    // this.onWebViewCreated,
    this.initialUrl,
    this.javascriptMode = JavascriptMode.disabled,
    // this.javascriptChannels,
    // this.navigationDelegate,
    // this.gestureRecognizers,
    // this.onPageFinished,
    // this.debuggingEnabled = false,
    // this.userAgent,
    // this.initialMediaPlaybackPolicy =
        // AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
  });



  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}