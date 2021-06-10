import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_search_delgates.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Future<void> _showSearch() async {
    final searchText = await showSearch<String>(
      context: context,
      delegate: SearchWithSuggestionDelegate(
        onSearchChanged: _getRecentSearchesLike,
        searchFieldLabel: '',
      ),
    );

    //Save the searchText to SharedPref so that next time you can use them as recent searches.
    await _saveToRecentSearches(searchText == null ? '' : searchText);

    //Do something with searchText. Note: This is not a result.
  }

  Future<List<String>> _getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches!.where((search) => search.startsWith(query)).toList();
  }

  Future<void> _saveToRecentSearches(String searchText) async {
    if (searchText == '') return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("서울주차장검색"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: _showSearch,
        ),
      ],
    );
  }
}
