import 'package:connectivity/connectivity.dart';

/// Helper class for the connectivity package
class QuakeConnectivityHelper {
  /// returns an instance of [QuakeConnectivityHelper]
  factory QuakeConnectivityHelper() => _instance;

  QuakeConnectivityHelper._();

  /// Constains and initializes an instance of [QuakeConnectivityHelper]
  static QuakeConnectivityHelper _instance =QuakeConnectivityHelper._();

  /// Contains the current connection type (null if not set).
  ConnectivityResult _connectionType;

  /// Store connectionType obtained from [Connectivity.onConnectivityChanged]
  /// 
  /// This MUST be set initially by the main method and updated everytime
  /// the connection changes (optional).
  set connectivity(ConnectivityResult connectivityResult) =>
      this._connectionType = connectivityResult;

  /// Get saved connection type syncronously
  /// 
  /// This function requires that [connectivity] setter is
  /// called before getting it.
  /// Do not rely just on saved connection type because it
  /// might change at runtime, just use this to pass as
  /// `initialData` to the streambuilder which will listen to
  /// [Connectivity.onConnectivityChanged] stream.
  ConnectivityResult get connectivity => this._connectionType;
}