import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen_2());
  }
}

class HomeScreen_2 extends StatelessWidget {
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: Text('Alert Title'),
          content: Text('This is the alert dialog content.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Handle OK action
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alert Dialog Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showAlertDialog(context),
          child: Text('Show Alert'),
        ),
      ),
    );
  }
}
