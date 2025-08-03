import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/core/enum/enum.dart';

final currApiProvider = StateProvider<Api>((ref) => Api.rest);
