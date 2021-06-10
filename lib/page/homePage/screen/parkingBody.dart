import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';

class ParkingBody extends StatelessWidget {
  GetParkingInfo? parkingInfo;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<PaginationBloc, PaginationState>(
        listener: (context, state) {
          if (state is PageLoadingState) {
            Scaffold.of(context)
                .showBottomSheet((context) => Text(state.message));
          } else if (state is SuccessState && state.data == null) {
            Scaffold.of(context)
                .showBottomSheet((context) => Text('no more data'));
          } else if (state is ErrorState) {
            Scaffold.of(context)
                .showBottomSheet((context) => Text(state.error));
            context.read<PaginationBloc>().isFetching = false;
          }
          return;
        },
        builder: (context, state) {
          if (state is PageInitState ||
              state is PageLoadingState && parkingInfo == null) {
            return CircularProgressIndicator();
          } else if (state is SuccessState) {
            parkingInfo = state.data;
            context.read<PaginationBloc>().isFetching = false;
            // ignore: deprecated_member_use
            Scaffold.of(context).hideCurrentSnackBar();
          } else if (state is ErrorState && parkingInfo == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    context.read()<PaginationBloc>()
                      ..isFetching = true
                      ..add(FetchEvent());
                  },
                  icon: Icon(Icons.refresh),
                ),
                const SizedBox(height: 15),
                Text(state.error, textAlign: TextAlign.center),
              ],
            );
          }
          return ListView.separated(
            controller: _scrollController
              ..addListener(() {
                if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent &&
                    !context.read<PaginationBloc>().isFetching) {
                  context.read<PaginationBloc>()
                    ..isFetching = true
                    ..add(FetchEvent());
                }
              }),
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.ac_unit),
              title: Center(
                child: Text('$index'),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemCount: parkingInfo!.dataList!.length,
          );
        },
      ),
    );
  }
}
