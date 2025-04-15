import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final String transitionType;

  CustomPageRoute({
    required this.child,
    this.transitionType = 'slide',
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            switch (transitionType) {
              case 'fade':
                return FadeTransition(
                  opacity: animation.drive(tween),
                  child: child,
                );
              case 'scale':
                return ScaleTransition(
                  scale: animation.drive(tween),
                  child: child,
                );
              case 'slide':
              default:
                const beginOffset = Offset(1.0, 0.0);
                const endOffset = Offset.zero;
                final offsetTween = Tween(begin: beginOffset, end: endOffset)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(offsetTween),
                  child: child,
                );
            }
          },
        );
}

/// Extension method to make navigation with transitions easier
extension NavigatorExtension on BuildContext {
  Future<T?> pushWithTransition<T extends Object?>(
    Widget page, {
    String transitionType = 'slide',
  }) {
    return Navigator.push<T>(
      this,
      CustomPageRoute<T>(
        child: page,
        transitionType: transitionType,
      ),
    );
  }

  Future<T?>
      pushReplacementWithTransition<T extends Object?, TO extends Object?>(
    Widget page, {
    String transitionType = 'slide',
    TO? result,
  }) {
    return Navigator.pushReplacement<T, TO>(
      this,
      CustomPageRoute<T>(
        child: page,
        transitionType: transitionType,
      ),
      result: result,
    );
  }
}
