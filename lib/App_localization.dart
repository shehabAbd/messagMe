import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Applocalization {
final Locale locale;
  Applocalization(this.locale);
  static Applocalization? of(BuildContext context) {
    return Localizations.of<Applocalization>(context, Applocalization);
  }
  static LocalizationsDelegate<Applocalization>delegate = _ApplocalizationDelegate();

   Map<String, String>? _localizationStrings;

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');

        Map<String ,dynamic>jsonMap = json.decode(jsonString);
        _localizationStrings = jsonMap.map((key, value){
                  return MapEntry(key, value.toString());
        });
        return true;
          }

          String? translate(String key){
         return _localizationStrings![key];
        }
}
class _ApplocalizationDelegate extends LocalizationsDelegate<Applocalization>{
  @override
  bool isSupported(Locale locale) {
      return ['en' , 'ar'].contains(locale.languageCode);
    }
  
    @override
    Future<Applocalization> load(Locale locale)async {
      Applocalization  localization = new Applocalization(locale); 
      await localization;
      return localization;
    }
  
    @override
    bool shouldReload(covariant LocalizationsDelegate<Applocalization> old) {
     return false;
  }
}
        