import 'package:quake/services/fsdn.dart';

class Ingv extends FSDNews {
  Ingv() : super(Uri(host: 'webservices.ingv.it'));
}
