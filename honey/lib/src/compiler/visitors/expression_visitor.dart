import 'package:honey/src/compiler/antlr.dart';
import 'package:honey/src/compiler/visitors/visitors.dart';
import 'package:honey/src/consts/function.dart';
import 'package:honey/src/consts/param_names.dart';
import 'package:honey/src/consts/property.dart';
import 'package:honey/src/expression/expr.dart';
import 'package:honey/src/expression/function_expr.dart';
import 'package:honey/src/expression/value_expr.dart';

class ExpressionVisitor extends HoneyTalkBaseVisitor<Expr> {
  @override
  Expr visitTermTerm(TermTermContext ctx) {
    return ctx.term()!.accept(this)!;
  }

  @override
  Expr visitExprExpr(ExprExprContext ctx) {
    return ctx.expr()!.accept(this)!;
  }

  @override
  Expr visitExprTerm(ExprTermContext ctx) {
    return super.visitExprTerm(ctx)!;
  }

  @override
  Expr visitExprNot(ExprNotContext ctx) {
    final expr = ctx.expr()!.accept(this)!;
    return func(F.not, {pValue: expr});
  }

  @override
  Expr visitExprNegate(ExprNegateContext ctx) {
    final expr = ctx.expr()!.accept(this)!;
    return func(F.multiply, {pLeft: expr, pRight: val(-1)});
  }

  @override
  Expr visitExprExists(ExprExistsContext ctx) {
    final target = ctx.expr()!.accept(this)!;
    final widgets = func(F.widgets, {pTarget: target});
    final count = func(F.property, {
      pName: val(Property.length.name),
      pValue: widgets,
    });
    if (ctx.isAreNot() == null) {
      return func(F.greater, {pLeft: count, pRight: val(0)});
    } else {
      return func(F.equal, {pLeft: count, pRight: val(0)});
    }
  }

  @override
  Expr visitExprPow(ExprPowContext ctx) {
    final left = ctx.expr(0)!.accept(this)!;
    final right = ctx.expr(1)!.accept(this)!;
    return func(F.pow, {pLeft: left, pRight: right});
  }

  @override
  Expr visitExprBinaryOp(ExprBinaryOpContext ctx) {
    final left = ctx.expr(0)!.accept(this)!;
    final right = ctx.expr(1)!.accept(this)!;
    if (ctx.plus() != null) {
      return func(F.plus, {pLeft: left, pRight: right});
    } else if (ctx.minus() != null) {
      return func(F.minus, {pLeft: left, pRight: right});
    } else if (ctx.times() != null) {
      return func(F.multiply, {pLeft: left, pRight: right});
    } else {
      return func(F.divide, {pLeft: left, pRight: right});
    }
  }

  @override
  Expr visitExprComparison(ExprComparisonContext ctx) {
    final left = ctx.expr(0)!.accept(this)!;
    final right = ctx.expr(1)!.accept(this)!;

    Expr getCmp() {
      if (ctx.eq() != null) {
        return func(F.equal, {pLeft: left, pRight: right});
      } else if (ctx.neq() != null) {
        return func(F.not, {
          pValue: func(F.equal, {pLeft: left, pRight: right})
        });
      } else if (ctx.gt() != null) {
        return func(F.greater, {pLeft: left, pRight: right});
      } else if (ctx.gte() != null) {
        return func(F.or, {
          pLeft: func(F.greater, {pLeft: left, pRight: right}),
          pRight: func(F.equal, {pLeft: left, pRight: right}),
        });
      } else if (ctx.lt() != null) {
        return func(F.less, {pLeft: left, pRight: right});
      } else {
        return func(F.or, {
          pLeft: func(F.less, {pLeft: left, pRight: right}),
          pRight: func(F.equal, {pLeft: left, pRight: right}),
        });
      }
    }

    final expr = getCmp();
    if (ctx.isAreNot() != null) {
      return func(F.not, {pValue: expr});
    } else {
      return expr;
    }
  }

  @override
  Expr visitExprStartsWith(ExprStartsWithContext ctx) {
    final value = ctx.expr(0)!.accept(this)!;
    final prefix = ctx.expr(1)!.accept(this)!;
    final expr = func(F.startsWith, {pValue: value, pInput: prefix});
    if (ctx.isAreNot() != null) {
      return func(F.not, {pValue: expr});
    } else {
      return expr;
    }
  }

  @override
  Expr visitExprEndsWith(ExprEndsWithContext ctx) {
    final value = ctx.expr(0)!.accept(this)!;
    final postfix = ctx.expr(1)!.accept(this)!;
    final expr = func(F.endsWith, {pValue: value, pInput: postfix});
    if (ctx.isAreNot() != null) {
      return func(F.not, {pValue: expr});
    } else {
      return expr;
    }
  }

  @override
  Expr visitExprContains(ExprContainsContext ctx) {
    final value = ctx.expr(0)!.accept(this)!;
    final substr = ctx.expr(1)!.accept(this)!;
    final expr = func(F.contains, {pValue: value, pInput: substr});
    if (ctx.isAreNot() != null) {
      return func(F.not, {pValue: expr});
    } else {
      return expr;
    }
  }

  @override
  Expr visitExprMatches(ExprMatchesContext ctx) {
    final value = ctx.expr(0)!.accept(this)!;
    final regex = ctx.expr(1)!.accept(this)!;
    final expr = func(F.matches, {pValue: value, pInput: regex});
    if (ctx.isAreNot() != null) {
      return func(F.not, {pValue: expr});
    } else {
      return expr;
    }
  }

  @override
  Expr visitExprIsAttr(ExprIsAttrContext ctx) {
    final target = ctx.expr()!.accept(this)!;
    final property = ctx.property()!.name;
    final expr = func(F.equal, {
      pLeft: func(F.property, {
        pValue: func(F.widgets, {pTarget: target}),
        pName: val(property)
      }),
      pRight: val(true)
    });
    if (ctx.isAreNot() != null) {
      return func(F.not, {pValue: expr});
    } else {
      return expr;
    }
  }

  @override
  Expr visitExprAnd(ExprAndContext ctx) {
    final left = ctx.expr(0)!.accept(this)!;
    final right = ctx.expr(1)!.accept(this)!;
    return func(F.and, {pLeft: left, pRight: right});
  }

  @override
  Expr visitExprOr(ExprOrContext ctx) {
    final left = ctx.expr(0)!.accept(this)!;
    final right = ctx.expr(1)!.accept(this)!;
    return func(F.or, {pLeft: left, pRight: right});
  }

  @override
  Expr visitTermLiteral(TermLiteralContext ctx) {
    return ctx.literal()!.accept(literalVisitor)!;
  }

  @override
  Expr visitTermNegate(TermNegateContext ctx) {
    final exp = ctx.term()!.accept(this)!;
    return func(F.multiply, {pLeft: exp, pRight: val(-1)});
  }

  @override
  Expr visitTermFunction(TermFunctionContext ctx) {
    return ctx.function()!.accept(functionVisitor)!;
  }

  @override
  Expr visitTermOrdinal(TermOrdinalContext ctx) {
    final target = ctx.term()!.accept(this)!;
    final ordinalValue = literalVisitor.visitOrdinal(ctx.ordinal()!);
    return func(F.property, {pTarget: target, pValue: ordinalValue ?? val(0)});
  }

  @override
  Expr visitTermSymbol(TermSymbolContext ctx) {
    final name = ctx.ID()?.text ?? ctx.VARIABLE()!.text!.substring(1);
    return func(F.variable, {pName: val(name)});
  }

  @override
  Expr visitTermProperty(TermPropertyContext ctx) {
    final target = ctx.term()!.accept(this)!;
    final prop = ctx.property()!.name;
    return func(F.property, {pValue: target, pName: val(prop)});
  }

  @override
  Expr visitTermWidget(TermWidgetContext ctx) {
    return ctx.widgetTerm()!.accept(widgetVisitor)!;
  }
}

extension on PropertyContext {
  String get name {
    if (length() != null) {
      return Property.length.name;
    } else if (character() != null) {
      return Property.characters.name;
    } else if (word() != null) {
      return Property.words.name;
    } else if (line() != null) {
      return Property.lines.name;
    } else {
      return ID()!.text!;
    }
  }
}
