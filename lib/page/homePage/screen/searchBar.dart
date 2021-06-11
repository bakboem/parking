import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'searchDelgates.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Future<void> _showSearch() async {
    final searchText = await showSearch<String>(
      context: context,
      delegate: SearchWithHistoryDelegate(
        onSearchChanged: _getLike,
        searchFieldLabel: '예: 구로 강남',
      ),
    );

    await _saveToSearches(searchText == null ? '' : searchText);
  }

  Future<List<String>> _getLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches!.where((search) => search.startsWith(query)).toList();
  }

  Future<void> _saveToSearches(String searchText) async {
    final pref = await SharedPreferences.getInstance();

    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: _showSearch,
    );
  }
}
