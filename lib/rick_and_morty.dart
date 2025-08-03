import 'package:flutter/material.dart';
import 'package:rick_and_morty/feature/view/screen/home_screen.dart';

class RickAndMorty extends StatelessWidget {
  const RickAndMorty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
