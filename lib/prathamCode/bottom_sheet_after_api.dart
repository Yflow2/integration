
import 'package:flutter/material.dart';

void showBottomSheetWidget(BuildContext context) {
  final List<String> words = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return BottomSheetContent(words: words);
    },
  );
}

class BottomSheetContent extends StatefulWidget {
  final List<String> words;

  BottomSheetContent({required this.words});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late List<String> filteredWords;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredWords = widget.words;
    searchController.addListener(_filterWords);
  }

  void _filterWords() {
    List<String> results = [];
    if (searchController.text.isEmpty) {
      results = widget.words;
    } else {
      results = widget.words
          .where((word) =>
          word.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredWords = results;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredWords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredWords[index]),
                    onTap: () {
                      // Handle item tap
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}