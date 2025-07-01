import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MaterialApp(home: WebAppWithCamera()));
}

class WebAppWithCamera extends StatefulWidget {
  const WebAppWithCamera({super.key});

  @override
  State<WebAppWithCamera> createState() => _WebAppWithCameraState();
}

class _WebAppWithCameraState extends State<WebAppWithCamera> {
  InAppWebViewController? webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(
              "https://atto-ocr-stage.codesncoffee.com/?data=YoyCD8%2FcGptFCKEdK44q%2BZZQ0aMCIjZowYKoNQXqbd27E5RdYzw7kO0%2Fvdmw93NdaPKE0E%2FXs9nhExPWYelRXwJD4niFmk7xQz6AJjc48SLz4oMw70qc495ZCqzYbSsJUWSNRIf1uaoQ%2BIDyXJblITfO2cSbih%2FCJiKw1F%2ByPmA%3D&projectid=2",
            ),
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
            ),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
              mixedContentMode:
                  AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            ),
          ),

          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
        ),
      ),
    );
  }
}
