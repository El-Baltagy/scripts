import 'package:flutter/material.dart';

class CreateListViewFromRow extends StatelessWidget {
  const CreateListViewFromRow({super.key,  this.scrollDirection=Axis.horizontal, required this.lengthList,required this.itemBuilder,   this.seperatorBuilder=0, this.controller, this.padding});

  final int lengthList;
  final double seperatorBuilder ;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final Widget   Function( int) itemBuilder;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:padding ,
      controller:controller ,
      scrollDirection: scrollDirection,
      child: Row(
        spacing: seperatorBuilder,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(lengthList, (index) => itemBuilder(index))
      ),
    );

  }
}