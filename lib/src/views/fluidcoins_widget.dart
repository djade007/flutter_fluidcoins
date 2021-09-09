import 'dart:convert';

import 'package:fluidcoins/src/models/fluid_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Fluidcoins webview widget.
class FluidCoinsWidget extends StatefulWidget {
  /// The api key.
  final String apiKey;

  /// The customer's email address.
  final String email;

  /// The amount to charge in kobo.
  final int amount;

  /// The customer's name [optional].
  final String name;

  /// The customer's phone number [optional].
  final String phone;

  /// Additional metadata [optional].
  final Map<String, dynamic> metadata;

  const FluidCoinsWidget({
    Key? key,
    required this.apiKey,
    required this.email,
    required this.amount,
    required this.name,
    required this.phone,
    required this.metadata,
  }) : super(key: key);

  @override
  _FluidCoinsWidgetState createState() => _FluidCoinsWidgetState();
}

class _FluidCoinsWidgetState extends State<FluidCoinsWidget> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: WebView(
                initialUrl: 'https://hosted-sdk.fluidcoins.com/flutter.html',
                debuggingEnabled: true,
                onPageFinished: (response) {
                  setState(() {
                    isLoading = false;
                  });
                  final jsonOptions = json.encode(
                    {
                      'key': widget.apiKey,
                      'email': widget.email,
                      'amount': widget.amount,
                      'name': widget.name,
                      'metadata': widget.metadata,
                    },
                  );
                  _controller.evaluateJavascript("setUpFC('$jsonOptions')");
                },
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: [
                  Factory(() => VerticalDragGestureRecognizer()),
                  Factory(() => TapGestureRecognizer()),
                ].toSet(),
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'FlutterOnSuccess',
                      onMessageReceived: (JavascriptMessage message) {
                        Navigator.pop(
                          context,
                          FluidResponse.fromJson(
                            jsonDecode(message.message),
                          ),
                        );
                      }),
                  JavascriptChannel(
                      name: 'FlutterOnError',
                      onMessageReceived: (JavascriptMessage message) {
                        final data = jsonDecode(message.message);
                        Navigator.pop(
                          context,
                          FluidResponse.error(
                            data['type'] ?? 'Failed',
                          ),
                        );
                      }),
                  JavascriptChannel(
                      name: 'FlutterOnClose',
                      onMessageReceived: (JavascriptMessage message) {
                        Navigator.pop(context);
                      })
                ]),
                onWebViewCreated: (webViewController) {
                  _controller = webViewController;
                }),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: 0,
                  height: 0,
                  color: Colors.transparent,
                ),
        ],
      ),
    );
  }
}
