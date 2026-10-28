import 'package:flutter/material.dart';
import 'package:gatekeep/locator.dart';
import 'package:gatekeep/provider/base_provider.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseProvider> extends StatefulWidget {
  final WidgetBuilder builder;
  final void Function(T model)? onModelReady;
  final void Function(T model)? onDispose;
  final T? overrideModel;

  const BaseView({super.key, required this.builder, this.onModelReady, this.onDispose, this.overrideModel});

  @override
  State<BaseView<T>> createState() => BaseViewState<T>();
}

class BaseViewState<T extends BaseProvider> extends State<BaseView<T>> {
  late final T model;

  @override
  void initState() {
    super.initState();
    model = widget.overrideModel ?? locator<T>();
    widget.onModelReady?.call(model);
  }

  @override
  void dispose() {
    widget.onDispose?.call(model);
    if (widget.overrideModel == null) {
      model.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(value: model, child: Builder(builder: widget.builder));
  }
}
