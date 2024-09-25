import 'package:flutter/material.dart';

class MoneyBagInitialLoadingView extends StatefulWidget {
  const MoneyBagInitialLoadingView({super.key});

  @override
  State<MoneyBagInitialLoadingView> createState() => _MoneyBagInitialLoadingViewState();
}

class _MoneyBagInitialLoadingViewState extends State<MoneyBagInitialLoadingView> {
  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 24);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          gap,
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ShimmerLoading(size: Size(120, 42)),
              SizedBox(width: 8),
              _ShimmerLoading(size: Size(120, 42)),
            ],
          ),
          gap,
          for (int i = 0; i < 3; i++) ...[
            const SizedBox(height: 8),
            const _ShimmerLoading(size: Size.fromHeight(48)),
          ],
          gap,
          const _ShimmerLoading(size: Size.fromHeight(150)),
          const SizedBox(height: 24),
          const _ShimmerLoading(size: Size.fromHeight(48)),
        ],
      ),
    );
  }
}

class _ShimmerLoading extends StatefulWidget {
  const _ShimmerLoading({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<_ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<_ShimmerLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: const [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
              stops: [_animation.value + 0.3, _animation.value + 0.5, _animation.value + 0.7],
              begin: const Alignment(-1, -1),
              end: const Alignment(1, 1),
              tileMode: TileMode.clamp,
            ),
          ),
          child: child,
        );
      },
      child: SizedBox.fromSize(size: widget.size),
    );
  }
}
