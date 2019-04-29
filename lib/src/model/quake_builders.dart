import 'dart:async';

import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

/// This function is called when loading data.
typedef LoadingCallback = Widget Function();

/// This function is called when occurred an error (details inside [error]).
typedef ErrorCallback = Widget Function(Object error);

/// This function is called to build the child.
///
/// You'll have a [context] and the [data] (of type [T]).
typedef QuakeBuilderType<T> = Widget Function(BuildContext context, T data);

/// Utility class to abstract the two builders.
///
/// Might be useful for testing.
abstract class QuakeBuilderBase<T> {
  /// See [LoadingCallback]
  final LoadingCallback onLoading;

  /// See [ErrorCallback]
  final ErrorCallback onError;

  /// See [QuakeBuilderType]
  final QuakeBuilderType<T> builder;

  QuakeBuilderBase(this.onLoading, this.onError, this.builder);

  Widget build(BuildContext context);
}

/// This widget rebuilds itself when new data comes from the [stream].
/// Unlike [StreamBuilder] it has some utilities such as handling loading and error.
///
/// The two required parameters are [stream] and [builder] which will give you
/// context and the data (of type [T]). You can pass an [initialData] to
/// return while there is no data in the stream, and you can also "override" the
/// default [onLoading] and [onError] methods.
///
/// Use this as:
/// ```
/// QuakeStreamBuilder<int>(
///   stream: myStream,
///   onLoading: () => CircularProgressIndicator(),
///   builder: (context, data) => Text(data.toString()),
/// )
/// ```
class QuakeStreamBuilder<T> extends StatelessWidget
    implements QuakeBuilderBase<T> {
  /// The stream where the data will flow.
  final Stream<T> stream;

  /// Useful to show something while waiting the first data to come out
  /// from the [stream].
  final T initialData;

  /// See [LoadingCallback]
  final LoadingCallback onLoading;

  /// This function will be called when the stream has an error,
  /// see [ErrorCallback]
  final ErrorCallback onError;

  /// Called to build the child, see [QuakeBuilderType]
  final QuakeBuilderType<T> builder;

  /// Creates a new [QuakeStreamBuilder]
  ///
  /// [builder] and [stream] should not be null.
  const QuakeStreamBuilder({
    @required this.stream,
    @required this.builder,
    this.initialData,
    this.onLoading,
    this.onError,
    Key key,
  })  : assert(builder != null),
        assert(stream != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      key: key,
      stream: stream,
      initialData: initialData,
      builder: (context, snapshot) {
        // an error occurred so call onError
        if (snapshot.hasError) 
          return onError != null ? onError(snapshot.error) : Container();
        // stream doesn't have data yet
        if (!snapshot.hasData)
          return onLoading != null
              ? onLoading()
              : Center(child: CircularProgressIndicator());

        // got data with no errors, so the widget is ready to call the builder
        return builder(context, snapshot.data);
      },
    );
  }
}

/// This widget rebuilds itself when the [future] returns data.
/// Unlike [FutureBuilder] it has some utilities such as handling loading and error.
///
/// The two required parameters are [future] and [builder] which will give you
/// context and the data (of type [T]). You can pass an [initialData] to
/// return while there is no data in the stream, and you can also "override" the
/// default [onLoading] and [onError] methods.
///
/// Use this as:
/// ```
/// QuakeFutureBuilder<int>(
///   future: myFutureFunction(),
///   onLoading: () => CircularProgressIndicator(),
///   builder: (context, data) => Text(data.toString()),
/// )
/// ```
class QuakeFutureBuilder<T> extends StatelessWidget
    implements QuakeBuilderBase<T> {
  /// The [Future] of type [T] that will return the data asyncronously
  final Future<T> future;

  /// Useful to show something while waiting the data from the [future].
  final T initialData;

  /// See [LoadingCallback]
  final LoadingCallback onLoading;

  /// This function will be called when the future errored,
  /// see [ErrorCallback]
  final ErrorCallback onError;

  /// Called to build the child, see [QuakeBuilderType]
  final QuakeBuilderType<T> builder;

  /// Creates a new [QuakeFutureBuilder]
  ///
  /// builder should not be null
  const QuakeFutureBuilder({
    @required this.future,
    @required this.builder,
    this.initialData,
    this.onLoading,
    this.onError,
    Key key,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: key,
      future: future,
      initialData: initialData,
      builder: (context, snapshot) {
        // the snapshot has an error, so call the onError function
        if (snapshot.hasError)
          return onError != null ? onError(snapshot.error) : Container();
        // the snapshot has a connection active and no data, so it's still loading
        if (!snapshot.hasData)
          return onLoading != null
              ? onLoading()
              : const CircularProgressIndicator();

        // got data with no errors, so the widget is ready to call the builder
        return builder(context, snapshot.data);
      },
    );
  }
}
