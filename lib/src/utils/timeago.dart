import 'package:timeago/timeago.dart';

LookupMessages getLocaleStringsClass(String locale) {
  switch (locale) {
    case 'da':
      return DaMessages();
    case 'de':
      return DeMessages();
    case 'es':
      return EsMessages();
    case 'fa':
      return FaMessages();
    case 'fr':
      return FrMessages();
    case 'id':
      return IdMessages();
    case 'it':
      return ItMessages();
    case 'ja':
      return JaMessages();
    case 'nl':
      return NlMessages();
    case 'pl':
      return PlMessages();
    case 'pt_br':
      return PtBrMessages();
    case 'ru':
      return RuMessages();
    case 'tr':
      return TrMessages();
    case 'zh_cn':
      return ZhCnMessages();
    case 'zh':
      return ZhMessages();
    default:
      return EnMessages();
  }
}
