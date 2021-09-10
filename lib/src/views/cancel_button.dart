import 'package:flutter/material.dart';

class FluidCoinsCancelButton extends StatelessWidget {
  const FluidCoinsCancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm'),
              content: Text('Are you sure you want to cancel payment?'),
              actions: <Widget>[
                OutlinedButton(
                  child: const Text(
                    'Yes, cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('No, stay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        'Cancel Payment',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
