import 'package:flutter/material.dart';

class EntranceFader extends StatelessWidget {
  const EntranceFader({super.key,
    this.onAnimationEnded,
    this.dx=-32,
    this.dy=0,
    this.delay = const Duration(milliseconds: 200),
    this.duration = const Duration(milliseconds: 500),


    required this.child,   this.enableAnimation=true });
  final Widget child;
  final void Function()? onAnimationEnded;

  /// Delay after which the animation will start
  final Duration delay;

  /// Duration of entrance animation
  final Duration duration;

  final bool enableAnimation;
  final double dx,dy;
  @override
  Widget build(BuildContext context) {
    return enableAnimation?
    _EntranceFader(
      onAnimationEnded: onAnimationEnded,
      delay: delay,
      duration: duration,
      dx: dx,
      dy: dy,
      child: child,
    )
        : child;
  }
}



class _EntranceFader extends StatefulWidget {
  const _EntranceFader({
    required this.child,
    required this.onAnimationEnded, required this.delay, required this.duration,
      required this.dx, required this.dy
   });
  /// Child to be animated on entrance
  final Widget child;
  final void Function()? onAnimationEnded;

  /// Delay after which the animation will start
  final Duration delay;

  /// Duration of entrance animation
  final Duration duration;

   final double dx,dy;

  @override
  _EntranceFaderState createState() {
    return _EntranceFaderState();
  }
}

class _EntranceFaderState extends State<_EntranceFader>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _dxAnimation, _dyAnimation;

  late Offset  offset;

  @override
  void initState() {
    super.initState();
    offset=  Offset(widget.dx, widget.dy) ;
    // offset=  Offset(true?-32:32, 0) ;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _dxAnimation =
        Tween(begin: offset.dx, end: 0.0).animate(_controller!);
    _dyAnimation =
        Tween(begin: offset.dy, end: 0.0).animate(_controller!);
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller!.forward();
        if (widget.onAnimationEnded!=null) {
          widget.onAnimationEnded!();
        }
        // print("wasd............................\n\n\n\n1111");
      }
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) => Opacity(
        opacity: _controller!.value,
        child: Transform.translate(
          offset: Offset(double.parse(_dxAnimation!.value.toString()), double.parse(_dyAnimation!.value.toString())),
          child: widget.child,
        ),
      ),
    );
  }
}
