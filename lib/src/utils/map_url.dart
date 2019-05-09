enum MapStyles { base, dark, light }

String getUrlByMapStyle(MapStyles style) {
  switch (style) {
    case MapStyles.base:
      return "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png";
    case MapStyles.dark:
      return "https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png";
    case MapStyles.light:
      return "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png";
    default:
      return "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png";
  }
}

MapStyles getMapStyleByString(String styleString) {
  if (styleString == MapStyles.base.toString())
    return MapStyles.base;
  else if (styleString == MapStyles.dark.toString())
    return MapStyles.dark;
  else if (styleString == MapStyles.light.toString())
    return MapStyles.light;
  else
    return null;
}

String getCreditsByMapStyle(MapStyles style) {
  switch (style) {
    case MapStyles.base:
      return "© OpenStreetMap contributors";
    case MapStyles.dark:
      return "Map tiles by Carto, under CC BY 3.0. Data by OpenStreetMap, under ODbL.";
    case MapStyles.light:
      return "Map tiles by Carto, under CC BY 3.0. Data by OpenStreetMap, under ODbL.";
  }
}
