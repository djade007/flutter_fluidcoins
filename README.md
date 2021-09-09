# fluidcoins

This is a flutter library to accept payments using Fluidcoins.

## Try the demo
Checkout the [widget flow](https://fluidcoins.com) to view how the Fluidcoins Widget works. *Click "Try Demo"*

## Getting started

Add the dependency `fluidcoins: ^0.1.0` to your project.

On iOS, opt-in to the embedded views preview by adding a boolean property to the app's Info.plist file with the key     `io.flutter.embedded_views_preview` and the value `true`.

```plist
<dict>  
  <key>io.flutter.embedded_views_preview</key>
  <true/>  
</dict>
```

## Usage

```dart
import 'package:fluidcoins/fluidcoins.dart';

final fluidcoins = FluidCoins(
  apiKey: 'YOUR_API_KEY',
);

main() async {
  final res = await fluidcoins.open(
    context,
    email: 'john@example.net',
    amount: 100000,
  );

  if (res == null) {
    print('payment was cancelled');
    return;
  }

  if (res.hasError) {
    print(res.error);
  }

  if (res.isPaidInFull || res.isOverPaid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment successful'),
      ),
    );

    print('Payment successful');
    print(res.coin);
    print(res.amount);
    print(res.reference);
  }
}
```