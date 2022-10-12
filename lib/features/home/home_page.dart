import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('bloc/contacts/list'),
              child: const Text('Bloc'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('cubit/contacts/list'),
              child: const Text('Cubit'),
            ),
          ],
        ),
      ),
    );
  }
}
