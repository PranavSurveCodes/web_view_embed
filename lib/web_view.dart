import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class MyWebViewScreen extends StatefulWidget {
  @override
  _MyWebViewScreenState createState() => _MyWebViewScreenState();
}

class _MyWebViewScreenState extends State<MyWebViewScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request Camera permission
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    // Request Photos permission (for gallery on iOS and Android 13+)
    var photosStatus = await Permission.photos.status;
    if (!photosStatus.isGranted) {
      await Permission.photos.request();
    }

    // For Android < 13, request Storage permissions
    if (Theme.of(context).platform == TargetPlatform.android &&
        (await Permission.storage.status).isDenied) {
      await Permission.storage.request();
    }
    // For Android 13+, READ_MEDIA_IMAGES and READ_MEDIA_VIDEO are preferred
    if (Theme.of(context).platform == TargetPlatform.android &&
        (await Permission.videos.status).isDenied) {
      await Permission.videos.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(
            "https://atto-ocr-stage.codesncoffee.com/?data=PZU2p1LMUKdK%2BxBgqUTW%2FY6ZqsdYIDtApMkoVC3og67xpAijNpN%2FGyLjjZfkCIjtBC%2FzXBiFPBmlT%2FCjyiOpCgAlNE5tNvokodM5ysiJw5VKXnrZ1J0Ple6JDsMahJ2OiEJDBlelmyrUTtDAUrGhFh7Sw60iLS3B5%2BE01CLObrA%2FfcIMRgZfCrLZqkKnyoPpu%2BNkc3Y4RpI6UaCaPQxA08Lr3TC4B8LPWgG1yQCU%2B30pJ2viBgXr2z8yuJBq%2FW6L0L0Bot01Oe6er3ZijKcpQXGLyKxpJo1wTsg3ZryIkwhaZiJtzMRGy57DflCs5y2e2aocbf66YC2oe4gDkex4Vw%3D%3D&projectid=5",
          ),
        ),
        // These callbacks are for the InAppWebView's *internal* permission handling
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT, // MUST GRANT
          );
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT, // MUST GRANT
          );
        },
        // This is critical if the Flutter web app also requests geolocation
        onGeolocationPermissionsShowPrompt: (controller, origin) async {
          return GeolocationPermissionShowPromptResponse(
            origin: origin,
            allow: true,
            retain: true,
          );
        },

        // The onShowFileChooser is less likely to be directly invoked by Flutter web's image_picker
        // but keep it as a fallback/safety measure just in case.
        // However, the primary focus for Flutter web's camera will be the InAppWebViewOptions.
        // onShowFileChooser: (controller, fileChooserParams) async {
        //   // ... (previous onShowFileChooser implementation with image_picker) ...
        //   // Keep this if you want to explicitly override file picking,
        //   // but it might not be the primary way Flutter web handles it.
        //   return [];
        // },
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture:
                false, // Important for camera streams
            javaScriptCanOpenWindowsAutomatically: true,
            cacheEnabled: true,
            supportZoom: true,
            transparentBackground: true,
            // These are CRUCIAL for allowing the web view to access local files/media
            // allowFileAccess: true,
            // allowContentAccess: true,
            allowUniversalAccessFromFileURLs: true,
            allowFileAccessFromFileURLs: true,
            // Allow media devices access (camera/mic)
            // mediaDevices: MediaDevicesOptions(
            //   audio: true, // If your web app might also use audio
            //   video: true, // ESSENTIAL for camera
            // ),
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
            defaultFontSize: 16,
            loadWithOverviewMode: true,
            domStorageEnabled: true,
            databaseEnabled: true,
            allowFileAccess: true, // Redundant but good to be explicit
            allowContentAccess: true, // Redundant but good to be explicit
            builtInZoomControls: true,
            displayZoomControls: false,
            clearSessionCache: false,
            thirdPartyCookiesEnabled: true,
            loadsImagesAutomatically: true,
            mixedContentMode:
                AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            // This is important for Android to allow file/content URIs to be accessed
            // when returned from system pickers/camera.
            // forceDark: AndroidForceDark.OFF, // Or adaptive
          ),
          ios: IOSInAppWebViewOptions(
            allowsLinkPreview: false,
            allowsInlineMediaPlayback: true,
            // Camera/Photo library usage descriptions are handled in Info.plist,
            // but these options ensure media playback generally works.
          ),
        ),
      ),
    );
  }
}
