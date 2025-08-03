import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/core/enum/enum.dart';
import 'package:rick_and_morty/core/provider/is_search_widget_on_provider.dart';
import 'package:rick_and_morty/core/provider/is_searching.dart';

class SearchWidget extends ConsumerStatefulWidget {
  final void Function({
    required CharacterStatus chStatus,
    required CharacterGender chGender,
    required String chName,
  })
  applyFilters;

  final void Function() deleteFilters;

  const SearchWidget({
    super.key,
    required this.applyFilters,
    required this.deleteFilters,
  });

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final TextEditingController _nameController = TextEditingController();

  CharacterStatus characterStatusValue = CharacterStatus.all;
  CharacterGender characterGenderValue = CharacterGender.all;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: width * 0.07),
              IconButton(
                onPressed: () {
                  ref.watch(isSearchWidgetOnProvider.notifier).state = false;
                  ref.watch(isSearchingProvider.notifier).state = false;
                  widget.deleteFilters();
                },
                icon: Icon(Icons.close),
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 10,
                    ),
                  ),
                  cursorHeight: 20,
                ),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  widget.applyFilters(
                    chGender: characterGenderValue,
                    chStatus: characterStatusValue,
                    chName: _nameController.text,
                  );

                  ref.watch(isSearchingProvider.notifier).state = true;
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(90, 35),
                  maximumSize: Size(90, 35),
                ),
                child: Text("поиск"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text("Status"),
                  DropdownButton(
                    value: characterStatusValue,
                    items: CharacterStatus.values
                        .map(
                          (chStatus) => DropdownMenuItem(
                            value: chStatus,
                            child: Text(chStatus.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          characterStatusValue = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  const Text("Gender"),
                  DropdownButton(
                    value: characterGenderValue,

                    items: CharacterGender.values
                        .map(
                          (chGender) => DropdownMenuItem(
                            value: chGender,
                            child: Text(chGender.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          characterGenderValue = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
