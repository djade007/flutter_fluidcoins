import 'dart:convert';
import 'dart:io';

import 'package:fluidcoins/src/models/fluid_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'cancel_button.dart';

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

  /// Transaction reference [optional].
  final String reference;

  /// Additional metadata [optional].
  final Map<String, dynamic> metadata;

  /// Widget to display when payment page fails to load.
  final Widget? errorWidget;

  const FluidCoinsWidget({
    Key? key,
    required this.apiKey,
    required this.email,
    required this.amount,
    required this.name,
    required this.phone,
    required this.metadata,
    this.errorWidget,
    this.reference: '',
  }) : super(key: key);

  @override
  _FluidCoinsWidgetState createState() => _FluidCoinsWidgetState();
}

class _FluidCoinsWidgetState extends State<FluidCoinsWidget> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 5),
            FluidCoinsCancelButton(),
            Expanded(
              child: Stack(
                children: [
                  _buildWebview(),
                  if (_isLoading && !_error)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (_error)
                    widget.errorWidget ??
                        Center(
                          child: Text('Failed to load payment gateway'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebview() {
    return WebView(
      initialUrl: 'https://hosted-sdk.fluidcoins.com/flutter.html',
      debuggingEnabled: true,
      onWebResourceError: (e) {
        setState(() {
          _error = true;
        });
      },
      onPageFinished: (response) {
        setState(() {
          _isLoading = false;
        });
        final jsonOptions = json.encode(
          {
            'key': widget.apiKey,
            'email': widget.email,
            'amount': widget.amount,
            'name': widget.name,
            'metadata': widget.metadata,
            'reference': widget.reference,
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
      },
    );
  }
}
