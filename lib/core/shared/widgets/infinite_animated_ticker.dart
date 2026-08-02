import 'package:flutter/material.dart';

class InfiniteTicker extends StatefulWidget {

  const InfiniteTicker({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.speed = 30,
  });
  final Widget child;
  final double speed,width,height;

  @override
  State<InfiniteTicker> createState() => _InfiniteTickerState();
}

class _InfiniteTickerState extends State<InfiniteTicker> {
  late final ScrollController _controller;

  bool _userTouching = false;
  bool _running = false;

  static const int _itemCount = 1000;
  static const int _startIndex = _itemCount ~/ 2;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_startIndex * _itemWidth);
      _start();
    });
  }

  double get _itemWidth => 200; // IMPORTANT: fixed width

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      constraints: BoxConstraints(
        maxWidth:  widget.width,
        // maxHeight: widget.height
      ),
      child: Listener(
        onPointerDown: (_) => _userTouching = true,
        onPointerUp: (_) => _userTouching = false,
        onPointerCancel: (_) => _userTouching = false,
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _itemCount,
            itemBuilder: (context, index) {
              return widget.child; // modulo not needed (same child)
            },
          ),
        ),
      ),
    );
  }

  Future<void> _start() async {
    if (_running) return;
    _running = true;

    while (mounted) {
      if (_userTouching) {
        await Future.delayed(const Duration(milliseconds: 40));
        continue;
      }

      _controller.jumpTo(
        _controller.offset + widget.speed / 60,
      );

      await Future.delayed(const Duration(milliseconds: 16));
    }

    _running = false;
  }
}
