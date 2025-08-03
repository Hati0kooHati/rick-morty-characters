import 'package:flutter/material.dart';
import 'package:rick_and_morty/rick_and_morty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: RickAndMorty()));
}
