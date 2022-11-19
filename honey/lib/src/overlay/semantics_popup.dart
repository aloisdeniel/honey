import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:honey/src/consts/property.dart';
import 'package:honey/src/overlay/semantics_color.dart';
import 'package:honey/src/semantics/semantics_extension.dart';

class _SemanticsPopupPositionDelegate extends SingleChildLayoutDelegate {
  _SemanticsPopupPositionDelegate({
    required this.target,
  });

  final Offset target;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: 20,
      preferBelow: false,
    );
  }

  @override
  bool shouldRelayout(_SemanticsPopupPositionDelegate oldDelegate) {
    return target != oldDelegate.target;
  }
}

class SemanticsPopup extends StatelessWidget {
  const SemanticsPopup({
    super.key,
    required this.animation,
    required this.node,
  });

  final SemanticsNode node;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final widget = node.toExp();
    final attrs = _semanticsAttrs
        .map((e) {
          final result = widget.property(e.name);
          if (result.isBool && result.asBool) {
            return e.name;
          }
        })
        .where((e) => e != null)
        .cast<String>()
        .toList();
    final bgolor = node.honeyColor;
    final textColor =
        bgolor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomSingleChildLayout(
          delegate: _SemanticsPopupPositionDelegate(
            target: node.globalRect.center,
          ),
          child: FadeTransition(
            opacity: animation,
            child: Container(
              decoration: BoxDecoration(
                color: bgolor,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              child: DefaultTextStyle(
                style: TextStyle(color: textColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.data.label.isNotEmpty)
                      _Property('label', widget.data.label),
                    if (widget.data.hint.isNotEmpty)
                      _Property('hint', widget.data.hint),
                    if (widget.data.tooltip.isNotEmpty)
                      _Property('tooltip', widget.data.tooltip),
                    if (widget.data.value.isNotEmpty)
                      _Property('value', widget.data.value),
                    if (attrs.isNotEmpty) _Property('attrs', attrs.join(', ')),
                    _Property(
                      'offset',
                      '${widget.rect.topLeft.dx.toStringAsFixed(1)}, '
                          '${widget.rect.topLeft.dy.toStringAsFixed(1)}',
                    ),
                    _Property(
                      'size',
                      '${widget.rect.size.width.toStringAsFixed(1)} x '
                          '${widget.rect.size.height.toStringAsFixed(1)}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Property extends StatelessWidget {
  const _Property(
    this.label,
    this.value,
  ) : super();

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 55,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}

const _semanticsAttrs = [
  Property.widget,
  Property.button,
  Property.link,
  Property.textfield,
  Property.image,
  Property.slider,
  Property.checkable,
  Property.checkbox,
  Property.toggleable,
  Property.sswitch,
  Property.header,
  Property.clickable,
  Property.longClickable,
  Property.scrollable,
  Property.checked,
  Property.unchecked,
  Property.toggled,
  Property.enableable,
  Property.enabled,
  Property.disabled,
  Property.focusable,
  Property.focused,
  Property.multiline,
  Property.selected,
  Property.obscured,
  Property.readonly,
];
