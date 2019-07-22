import 'package:quake/src/api/fsdnews_common.dart';

class Usgs extends FSDNews {
  Usgs() : super(Uri(host: 'earthquake.usgs.gov'));
}
