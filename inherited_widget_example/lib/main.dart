import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(
      MaterialApp(
        title: "Random Squares",
        home: StatefulRootWidget(),
      ),
    );

class StatefulRootWidget extends StatefulWidget {
  @override
  StatefulRootWidgetState createState() => StatefulRootWidgetState();
}

/// [StatefulRootWidget]
/// ||
/// [InheritedWidget]
/// ||
/// [BoxTree]
/// ||
/// [Box] & [Box]

class StatefulRootWidgetState extends State<StatefulRootWidget> {
  final Random _random = Random();
  Color color = Colors.amber;

  void onTap() {
    setState(() {
      color = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorState(
      color: color,
      onTap: onTap,
      // the decendent widget below inherited widget (first decendent)
      child: BoxTree(),
    );
  }
}

//! Every widget keeps a map _inheritedWidgets, which stores all ancestor
//! InheritedWidget instances indexed by their type.

/// [InheritedWidget] is an immutable class so it will not update , it will rebuild
/// It can efficiently deliver this context to every widget in that subtree
/// InheritedWidget is just a simple widget that does nothing but holding data
class ColorState extends InheritedWidget {
  ColorState({
    Key key,
    this.color,
    this.onTap,
    Widget child,
  }) : super(key: key, child: child);

  final Color color;
  final Function onTap;

  /// lets the decendent widgets to know wheater they need update or not
  /// call decendent [didChangeDependencies] method if return true
  @override
  bool updateShouldNotify(ColorState oldWidget) => color != oldWidget.color;

  /// it acts like singleton class
  static ColorState of(BuildContext context) {
    /// enables a descendant widget to access the closest ancestor MyInheritedWidget
    /// instance enclosed in its BuildContext.
    /// this context is only accessable for [InheritedWidget]s
    // return context.inheritFromWidgetOfExactType(ColorState); => deprecated
    return context.dependOnInheritedWidgetOfExactType<ColorState>();

    /// expensive method
    // return context.ancestorWidgetOfExactType(targetType); => deprecated
    return context.findAncestorWidgetOfExactType<ColorState>();
  }
}

class BoxTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const NotRebuildBox(),
          SizedBox(height: 50),
          Row(children: <Widget>[Box(), Box()]),
        ],
      ),
    );
  }
}

class NotRebuildBox extends StatelessWidget {
  const NotRebuildBox();

  @override
  Widget build(BuildContext context) {
    print('should not rebuild');
    return Text('this text Widget should not rebuild');
  }
}

class Box extends StatefulWidget {
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  ColorState _colorState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _colorState = ColorState.of(context);
    return GestureDetector(
      onTap: _colorState.onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        margin: EdgeInsets.only(left: 100.0),
        color: _colorState.color,
      ),
    );
  }
}
