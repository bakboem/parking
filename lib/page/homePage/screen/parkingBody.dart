import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/model/parkingModel/getParkingInfo.dart';
import 'package:parking/page/homePage/bloc/pagenationBloc/exportPaginationBloc.dart';

// ignore: must_be_immutable
class ParkingBody extends StatelessWidget {
  GetParkingInfo? parkingInfo;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<PaginationBloc<GetParkingInfo>,
          PaginationState<GetParkingInfo>>(
        listener: (context, state) {
          if (state is PageInitState<GetParkingInfo>) {
            context
                .read<PaginationBloc<GetParkingInfo>>()
                .add(RequestDataEvent<GetParkingInfo>(search: ''));
          }
          if (state is ProcessDataState<GetParkingInfo>) {
            context
                .read<PaginationBloc<GetParkingInfo>>()
                .add(AppendDataEvent<GetParkingInfo>(data: state.data));
          }
          if (state is SuccessState<GetParkingInfo>) {}
          //  else if (state is SuccessState<GetParkingInfo> &&
          //     // ignore: unnecessary_null_comparison
          //     state.data == null) {
          //   Scaffold.of(context)
          //       .showBottomSheet((context) => Text('no more data'));
          // } else if (state is ErrorState<GetParkingInfo>) {
          //   Scaffold.of(context)
          //       .showBottomSheet((context) => Text(state.error));
          //   context.read<PaginationBloc<GetParkingInfo>>().isFetching = false;
          // }
          return;
        },
        builder: (context, state) {
          if (state is PageInitState<GetParkingInfo> ||
              state is LoadingState<GetParkingInfo> && parkingInfo == null) {
            return CircularProgressIndicator();
          } else if (state is SuccessState<GetParkingInfo>) {
            context.read<PaginationBloc<GetParkingInfo>>().isFetching = false;
            return ListView.separated(
              controller: _scrollController
                ..addListener(() {
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      !context
                          .read<PaginationBloc<GetParkingInfo>>()
                          .isFetching) {
                    context.read<PaginationBloc<GetParkingInfo>>()
                      ..isFetching = true
                      ..add(RequestDataEvent<GetParkingInfo>(search: ''));
                  }
                }),
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.ac_unit),
                title: Center(
                  child: Text('$index'),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: state.data.dataList!.length,
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
