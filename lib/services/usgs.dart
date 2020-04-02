import 'package:quake/services/fsdn.dart';

class Usgs extends FSDNews {
  Usgs() : super(Uri(host: 'earthquake.usgs.gov'));
}
