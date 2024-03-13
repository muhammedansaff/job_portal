import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchQueryController = TextEditingController();
  String searchQuery = 'Search Query';

  Widget _buildSearchField() {
    return TextField(
      controller: searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
          hintFadeDuration: Durations.extralong1,
          hintText: 'click here to Search',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey)),
      style: const TextStyle(color: Colors.black, fontSize: 16),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  void clearSearchquery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  Widget _buildActions() {
    return IconButton(
        onPressed: () {
          clearSearchquery();
        },
        icon: const Icon(Icons.clear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5B6),
      appBar: AppBar(
        title: _buildSearchField(),
        actions: [_buildActions()],
        elevation: 2,
        toolbarHeight: 40,
        shadowColor: const Color(0xFFF5F5DC),
        backgroundColor: Colors.white,
      ),
    );
  }
}
