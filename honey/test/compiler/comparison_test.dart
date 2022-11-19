import 'package:flutter_test/flutter_test.dart';
import 'package:honey/honey.dart';
import 'package:honey/src/consts/param_names.dart';

import '../utils.dart';

void main() {
  group('Comparison', () {
    test('exists', () {
      final result = func(F.greater, {
        pLeft: func(F.property, {
          pName: val(Property.length.name),
          pValue: func(F.widgets, {pTarget: val('test')})
        }),
        pRight: val(0),
      });

      expectExpr('there is "test"', result);
      expectExpr('there are "test"', result);
      expectExpr('"test" exist', result);
      expectExpr('"test" exists', result);
      expectExpr('"test" is existing', result);
      expectExpr('"test" is visible', result);
      expectExpr('"test" is there', result);
      expectExpr('"test" are existing', result);
      expectExpr('"test" are visible', result);
      expectExpr('"test" are there', result);
    });

    test('exists not', () {
      final result = func(F.equal, {
        pLeft: func(F.property, {
          pName: val(Property.length.name),
          pValue: func(F.widgets, {pTarget: val('test')})
        }),
        pRight: val(0)
      });

      expectExpr('there isn\'t "test"', result);
      expectExpr('there aren\'t "test"', result);
      expectExpr('"test" doesn\'t exist', result);
      expectExpr('"test" isn\'t existing', result);
      expectExpr('"test" isn\'t visible', result);
      expectExpr('"test" isn\'t there', result);
      expectExpr('"test" aren\'t existing', result);
      expectExpr('"test" aren\'t visible', result);
      expectExpr('"test" aren\'t there', result);
    });

    test('greater than', () {
      final result = func(F.greater, {pLeft: val(10), pRight: val('abc')});

      expectExpr('10 > "abc"', result);
      expectExpr('10 gt "abc"', result);
      expectExpr('10 is gt "abc"', result);
      expectExpr('10 are gt "abc"', result);
      expectExpr('10 greater "abc"', result);
      expectExpr('10 is greater "abc"', result);
      expectExpr('10 are greater "abc"', result);
      expectExpr('10 is greater than "abc"', result);
      expectExpr('10 are greater than "abc"', result);
    });

    test('less than', () {
      final result = func(F.less, {pLeft: val(10), pRight: val('abc')});

      expectExpr('10 < "abc"', result);
      expectExpr('10 lt "abc"', result);
      expectExpr('10 is lt "abc"', result);
      expectExpr('10 are lt "abc"', result);
      expectExpr('10 less "abc"', result);
      expectExpr('10 is less "abc"', result);
      expectExpr('10 are less "abc"', result);
      expectExpr('10 is less than "abc"', result);
      expectExpr('10 are less than "abc"', result);
    });

    test('greater than or equal', () {
      final result = func(F.or, {
        pLeft: func(F.greater, {pLeft: val(10), pRight: val('abc')}),
        pRight: func(F.equal, {pLeft: val(10), pRight: val('abc')}),
      });

      expectExpr('10 >= "abc"', result);
      expectExpr('10 gte "abc"', result);
      expectExpr('10 is gte "abc"', result);
      expectExpr('10 are gte "abc"', result);
      expectExpr('10 greater or equal "abc"', result);
      expectExpr('10 greater than or equal "abc"', result);
      expectExpr('10 greater or equal to "abc"', result);
      expectExpr('10 greater than or equal to "abc"', result);
      expectExpr('10 is greater or equal "abc"', result);
      expectExpr('10 is greater than or equal "abc"', result);
      expectExpr('10 is greater or equal to "abc"', result);
      expectExpr('10 is greater than or equal to "abc"', result);
      expectExpr('10 are greater or equal "abc"', result);
      expectExpr('10 are greater than or equal "abc"', result);
      expectExpr('10 are greater or equal to "abc"', result);
      expectExpr('10 are greater than or equal to "abc"', result);
    });

    test('less than or equal', () {
      final result = func(F.or, {
        pLeft: func(F.less, {pLeft: val(10), pRight: val('abc')}),
        pRight: func(F.equal, {pLeft: val(10), pRight: val('abc')}),
      });

      expectExpr('10 <= "abc"', result);
      expectExpr('10 lte "abc"', result);
      expectExpr('10 is lte "abc"', result);
      expectExpr('10 are lte "abc"', result);
      expectExpr('10 less or equal "abc"', result);
      expectExpr('10 less than or equal "abc"', result);
      expectExpr('10 less or equal to "abc"', result);
      expectExpr('10 less than or equal to "abc"', result);
      expectExpr('10 is less or equal "abc"', result);
      expectExpr('10 is less than or equal "abc"', result);
      expectExpr('10 is less or equal to "abc"', result);
      expectExpr('10 is less than or equal to "abc"', result);
      expectExpr('10 are less or equal "abc"', result);
      expectExpr('10 are less than or equal "abc"', result);
      expectExpr('10 are less or equal to "abc"', result);
      expectExpr('10 are less than or equal to "abc"', result);
    });

    test('equal', () {
      final result = func(F.equal, {pLeft: val(10), pRight: val('abc')});

      expectExpr('10 = "abc"', result);
      expectExpr('10 == "abc"', result);
      expectExpr('10 eq "abc"', result);
      expectExpr('10 equal "abc"', result);
      expectExpr('10 equals "abc"', result);
      expectExpr('10 is eq "abc"', result);
      expectExpr('10 is equal "abc"', result);
      expectExpr('10 is equal to "abc"', result);
      expectExpr('10 are eq "abc"', result);
      expectExpr('10 are equal "abc"', result);
      expectExpr('10 are equal to "abc"', result);
    });

    test('not equal', () {
      final result = func(F.not, {
        pValue: func(F.equal, {pLeft: val(10), pRight: val('abc')})
      });

      expectExpr('10 != "abc"', result);
      expectExpr('10 neq "abc"', result);
      expectExpr('10 not equal "abc"', result);
      expectExpr('10 not equal to "abc"', result);
      expectExpr('10 is neq "abc"', result);
      expectExpr('10 is not equal "abc"', result);
      expectExpr('10 is not equal to "abc"', result);
      expectExpr('10 are neq "abc"', result);
      expectExpr('10 are not equal "abc"', result);
      expectExpr('10 are not equal to "abc"', result);
      expectExpr('10 does not equal "abc"', result);
    });

    test('starts with', () {
      final result = func(F.startsWith, {pValue: val(10), pInput: val('abc')});

      expectExpr('10 start with "abc"', result);
      expectExpr('10 starts with "abc"', result);
      expectExpr('10 does start with "abc"', result);
      expectExpr('10 starting with "abc"', result);
      expectExpr('10 is starting with "abc"', result);
      expectExpr('10 are starting with "abc"', result);
      expectExpr('10 begin with "abc"', result);
      expectExpr('10 begins with "abc"', result);
      expectExpr('10 does begin with "abc"', result);
      expectExpr('10 beginning with "abc"', result);
      expectExpr('10 is beginning with "abc"', result);
      expectExpr('10 are beginning with "abc"', result);
    });

    test('ends with', () {
      final result = func(F.endsWith, {pValue: val(10), pInput: val('abc')});

      expectExpr('10 end with "abc"', result);
      expectExpr('10 ends with "abc"', result);
      expectExpr('10 does end with "abc"', result);
      expectExpr('10 ending with "abc"', result);
      expectExpr('10 is ending with "abc"', result);
      expectExpr('10 are ending with "abc"', result);
    });

    test('contains', () {
      final result = func(F.contains, {pValue: val(10), pInput: val('abc')});

      expectExpr('10 contains "abc"', result);
      expectExpr('10 does contain "abc"', result);
      expectExpr('10 containing "abc"', result);
      expectExpr('10 is containing "abc"', result);
      expectExpr('10 are containing "abc"', result);
      expectExpr('10 includes "abc"', result);
      expectExpr('10 does include "abc"', result);
      expectExpr('10 including "abc"', result);
      expectExpr('10 is including "abc"', result);
      expectExpr('10 are including "abc"', result);
      expectExpr('10 does include "abc"', result);
    });

    test('matches', () {
      final result = func(F.matches, {pValue: val(10), pInput: val('abc')});

      expectExpr('10 match "abc"', result);
      expectExpr('10 matches "abc"', result);
      expectExpr('10 does match "abc"', result);
      expectExpr('10 is matching "abc"', result);
      expectExpr('10 are matching "abc"', result);
    });

    test('attribute', () {
      final result = func(F.equal, {
        pLeft: func(F.property, {
          pValue: func(F.widgets, {pTarget: val('test')}),
          pName: val('clickable')
        }),
        pRight: val(true),
      });

      expectExpr('"test" is clickable', result);
      expectExpr('"test" are clickable', result);
    });

    test('not attribute', () {
      final result = func(F.not, {
        pValue: func(F.equal, {
          pLeft: func(F.property, {
            pValue: func(F.widgets, {pTarget: val('test')}),
            pName: val('clickable')
          }),
          pRight: val(true),
        }),
      });

      expectExpr('"test" is not clickable', result);
      expectExpr('"test" isn\'t clickable', result);
      expectExpr('"test" are not clickable', result);
      expectExpr('"test" aren\'t clickable', result);
    });
  });
}
