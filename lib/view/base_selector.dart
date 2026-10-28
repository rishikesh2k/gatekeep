import 'package:flutter/material.dart';
import 'package:gatekeep/provider/base_provider.dart';
import 'package:provider/provider.dart';

class BaseSelector<T extends BaseProvider, V> extends StatelessWidget {
  final V Function(T model) selector;
  final Widget Function(BuildContext context, V value) builder;

  const BaseSelector({super.key, required this.selector, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Selector<T, V>(
      selector: (context, T model) => selector(model),
      builder: (BuildContext context, V value, Widget? child) => builder(context, value),
    );
  }
}
