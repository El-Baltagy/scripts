import 'package:flutter/material.dart';

/// Grid View with auto aspect ratio [dynamic height]
///
/// Usage is almost same as [GridView.count]
class AutoHeightGridView extends StatelessWidget {
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final EdgeInsetsGeometry  padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool enableScrool;

  const AutoHeightGridView({
    Key? key,
    required this.itemCount,
    this.enableScrool=true,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
    this.shrinkWrap = false,
    this.physics = const BouncingScrollPhysics(),
    this.padding = const EdgeInsets.all(10),
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !enableScrool?
    Padding(
      padding: padding,
      child: Column(
          children: List.generate(_columnLength(), (index) {
            return GridRow(
              columnIndex: index,
              builder: builder,
              itemCount: itemCount,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisAlignment: rowCrossAxisAlignment,
            );
          },)
      ),
    )
        :ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemBuilder: (ctx, columnIndex) {
        return GridRow(
          columnIndex: columnIndex,
          builder: builder,
          itemCount: itemCount,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisAlignment: rowCrossAxisAlignment,
        );
      },
      itemCount: _columnLength(),
    );
  }

  int _columnLength() {
    if (itemCount % crossAxisCount == 0) {
      return itemCount ~/ crossAxisCount;
    } else {
      return (itemCount ~/ crossAxisCount) + 1;
    }
  }
}
class GridRow extends StatelessWidget {
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final CrossAxisAlignment crossAxisAlignment;
  final int columnIndex;

  const GridRow({
    Key? key,
    required this.columnIndex,
    required this.builder,
    required this.itemCount,
    required this.crossAxisCount,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.crossAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: EdgeInsets.zero,
      padding: EdgeInsets.only(
        // bottom:100,
        top: (columnIndex == 0) ? 0 : mainAxisSpacing,
      ),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: List.generate(
          (crossAxisCount * 2) - 1,
              (rowIndex) {
            final rowNum = rowIndex + 1;
            if (rowNum % 2 == 0) {
              return SizedBox(width: crossAxisSpacing);
            }
            final rowItemIndex = ((rowNum + 1) ~/ 2) - 1;
            final itemIndex = (columnIndex * crossAxisCount) + rowItemIndex;
            if (itemIndex > itemCount - 1) {
              return const Expanded(child: SizedBox());
            }
            return Expanded(
              child: builder(context, itemIndex),
            );
          },
        ),
      ),
    );
  }
}