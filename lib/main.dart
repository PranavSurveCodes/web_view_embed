import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_view_app/web_view.dart';

void main() {
  runApp(MaterialApp(home: MyWebViewScreen()));
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
              "https://atto-ocr-stage.codesncoffee.com/??data=PZU2p1LMUKdK%2BxBgqUTW%2FY6ZqsdYIDtApMkoVC3og67xpAijNpN%2FGyLjjZfkCIjtBC%2FzXBiFPBmlT%2FCjyiOpCgAlNE5tNvokodM5ysiJw5VKXnrZ1J0Ple6JDsMahJ2OiEJDBlelmyrUTtDAUrGhFh7Sw60iLS3B5%2BE01CLObrA%2FfcIMRgZfCrLZqkKnyoPpu%2BNkc3Y4RpI6UaCaPQxA08Lr3TC4B8LPWgG1yQCU%2B30pJ2viBgXr2z8yuJBq%2FW6L0L0Bot01Oe6er3ZijKcpQXGLyKxpJo1wTsg3ZryIkwhaZiJtzMRGy57DflCs5y2e2aocbf66YC2oe4gDkex4Vw%3D%3D&projectid=5",
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
