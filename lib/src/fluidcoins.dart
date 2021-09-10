import 'package:fluidcoins/src/models/fluid_response.dart';
import 'package:fluidcoins/src/views/fluidcoins_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The base class for this package
class FluidCoins {
  /// The api key.
  final String apiKey;

  /// Class instance.
  const FluidCoins({
    required this.apiKey,
  });

  /// Opens the fluidcoins widget.
  Future<FluidResponse?> open(
    BuildContext context, {
    required String email,
    required int amount,
    String name: '',
    String phone: '',
    Map<String, dynamic> metadata: const {},
    Widget? errorWidget,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FluidCoinsWidget(
          apiKey: apiKey,
          email: email,
          amount: amount,
          name: name,
          phone: phone,
          metadata: metadata,
          errorWidget: errorWidget,
        ),
      ),
    );
  }
}
