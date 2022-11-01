import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:honey/src/consts/click_type.dart';
import 'package:honey/src/consts/direction.dart';
import 'package:honey/src/expression/expr.dart';
import 'package:honey/src/expression/widget_expr.dart';

abstract class HoneyContext {
  var _canceled = false;
  bool get canceled => _canceled;

  String message = '';

  void cancel() {
    _canceled = true;
  }

  Size get screenSize;

  Rect get screenRect =>
      Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);

  SemanticsNode get semanticsTree;

  EvaluatedExpr getVariable(String name);

  void setVariable(String name, EvaluatedExpr expression);

  void deleteVariable(String name);

  bool hasVariable(String name);

  void dispatchPointerEvent(PointerEvent e);

  void dispatchSemanticAction(Offset offset, SemanticsAction action);

  Future<void> delay(Duration duration);

  Future<void> click({
    WidgetExpr? widget,
    Offset? offset,
    ClickType type = ClickType.single,
  }) async {
    final rect = widget?.rect ?? screenRect;
    var clickOffset = offset;
    if (clickOffset != null) {
      if (clickOffset.dx <= 1 && clickOffset.dy <= 1) {
        clickOffset = Offset(
          clickOffset.dx * rect.width,
          clickOffset.dy * rect.height,
        );
      }
      clickOffset = rect.shift(clickOffset).center;
    }

    final downEvent = PointerDownEvent(position: clickOffset ?? rect.center);
    dispatchPointerEvent(downEvent);
    const upEvent = PointerUpEvent();
    dispatchPointerEvent(upEvent);
  }

  Future<void> swipe({
    WidgetExpr? widget,
    Offset? offset,
    Direction direction = Direction.left,
    double distance = 0.0,
  }) async {
    final rect = widget?.rect ?? screenRect;
    if (offset != null) {
      if (offset.dx <= 1 && offset.dy <= 1) {
        offset = Offset(offset.dx * rect.width, offset.dy * rect.height);
      }
      offset = rect.shift(offset).center;
    }

    offset ??= rect.center;
    //we're doing swipe twice so we need to devide distance
    final halfDistance = distance / 2;
    final delta = Offset(
      direction.xValue * (halfDistance != 0.0 ? halfDistance : rect.width),
      direction.yValue * (halfDistance != 0.0 ? halfDistance : rect.height),
    );

    dispatchPointerEvent(PointerDownEvent(position: offset));
    dispatchPointerEvent(PointerMoveEvent(position: offset));
    offset = Offset(offset.dx + delta.dx, offset.dy + delta.dy);
    dispatchPointerEvent(
      PointerMoveEvent(
        position: offset,
        delta: delta,
      ),
    );
    // ignore: parameter_assignments
    offset = Offset(offset.dx + delta.dx, offset.dy + delta.dy);
    dispatchPointerEvent(
      PointerMoveEvent(
        position: offset,
        delta: delta,
      ),
    );
    dispatchPointerEvent(const PointerUpEvent());
  }

  Future<EvaluatedExpr> eval(Expr? expression);

  HoneyContext clone({WidgetExpr? referenceWidget});
}
