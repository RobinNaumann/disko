import 'package:elbe/elbe.dart';
import 'package:local_hero/local_hero.dart';

class LocalLimitedHeroScope extends StatelessWidget {
  final Widget child;
  const LocalLimitedHeroScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LocalHeroScope(
        createRectTween: (begin, end) => RectTween(begin: begin, end: end),
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

class LocalLimitedHero extends StatelessWidget {
  static const offset = 52;
  final String tag;
  final Widget child;
  const LocalLimitedHero({required this.tag, required this.child});

  double _yPos(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    final pos = box?.localToGlobal(Offset.zero);
    return pos?.dy ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return LocalHero(
        key: Key(tag),
        tag: tag,
        flightShuttleBuilder: (context, animation, child) {
          return AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final y = _yPos(context);

                return y < 0
                    ? Spaced.zero
                    : ClipRect(clipper: TopClipper(offset - y), child: child);
              });
        },
        child: child);
  }
}

class TopClipper extends CustomClipper<Rect> {
  final double amount;

  const TopClipper(this.amount);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, amount, size.width, size.height - amount);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
