import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/paginationBloc.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class SearchWithHistoryDelegate extends SearchDelegate<String> {
  final OnSearchChanged onSearchChanged;

  List<String> _oldFilters = const [];

  SearchWithHistoryDelegate(
      {required String searchFieldLabel, required this.onSearchChanged})
      : super(searchFieldLabel: searchFieldLabel);

  ///
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  void showResults(BuildContext context) async {
    var bloc = context.read<PaginationBloc<GetParkInfo>>();
    if (query != bloc.api!.getSearchKey()) {
      bloc.add(RequestDataEvent(search: query));
    }
    close(context, query);
  }

  @override
  // ignore: null_check_always_fails
  Widget buildResults(BuildContext context) => null!;

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      // ignore: unnecessary_null_comparison
      future: onSearchChanged != null ? onSearchChanged(query) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data!;
        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
                leading: Icon(Icons.restore),
                title: Text("${_oldFilters[index]}"),
                onTap: () async {
                  var bloc = context.read<PaginationBloc<GetParkInfo>>();
                  if (_oldFilters[index] != bloc.api!.getSearchKey()) {
                    bloc.add(RequestDataEvent(search: _oldFilters[index]));
                  }

                  close(context, _oldFilters[index]);
                });
          },
        );
      },
    );
  }
}
