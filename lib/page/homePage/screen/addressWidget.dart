import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking/page/homePage/bloc/geoCodingBloc/exportGeoCodingBloc.dart';

// ignore: must_be_immutable
class AddressWidget extends StatelessWidget {
  const AddressWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeoCodingBloc, GeoCodingState>(
      builder: (context, state) {
        if (state is SuccessState) {
          return Text('${state.addr}',
              style: TextStyle(color: Colors.white70, fontSize: 13));
        }
        return Container(
          child: Text(''),
        );
      },
    );
  }
}
