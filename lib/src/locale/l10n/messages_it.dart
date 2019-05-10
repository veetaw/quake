// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'it';

  static m0(location, magnitude, country, time) =>
      "${time}: A ${location} (${country}) è stato Registrato un terremoto di magnitudo ${magnitude} sulla scala Richter.\n\nCondiviso con Quake.";

  static m1(e) =>
      "Qualcosa di non aspettato è successo.\nDettagli tecnici: ${e}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "advancedSearch":
            MessageLookupByLibrary.simpleMessage("Ricerca avanzata"),
        "alertCancelButton": MessageLookupByLibrary.simpleMessage("annulla"),
        "alertOkButton": MessageLookupByLibrary.simpleMessage("ok"),
        "all": MessageLookupByLibrary.simpleMessage("Tutti"),
        "allEarthquakesError": MessageLookupByLibrary.simpleMessage(
            "Impossibile ottenere la lista dei terremoti, prova di nuvovo più tardi."),
        "appStatusDescription": MessageLookupByLibrary.simpleMessage(
            "The app is in an active development state. Help the developer by reporting bug or suggesting features to add."),
        "appStatusTitle":
            MessageLookupByLibrary.simpleMessage("You can make Quake better!"),
        "appearance": MessageLookupByLibrary.simpleMessage("Aspetto"),
        "applicationName": MessageLookupByLibrary.simpleMessage("Terremoti"),
        "badResponse": MessageLookupByLibrary.simpleMessage(
            "Risposta del server non valida, riprova tra qualche minuto."),
        "baseMap": MessageLookupByLibrary.simpleMessage("Mappa base"),
        "chooseTheme": MessageLookupByLibrary.simpleMessage("Scegli tema"),
        "chooseThemeLong":
            MessageLookupByLibrary.simpleMessage("Cambia l\'aspetto dell\'app"),
        "dark": MessageLookupByLibrary.simpleMessage("Scuro"),
        "darkMap": MessageLookupByLibrary.simpleMessage("Mappa scura"),
        "depth": MessageLookupByLibrary.simpleMessage("Profondità"),
        "depthKm": MessageLookupByLibrary.simpleMessage("Profondità (km)"),
        "depthSettingsTile": MessageLookupByLibrary.simpleMessage(
            "Unità di misura per la profondità"),
        "distanceMapSettingsTile": MessageLookupByLibrary.simpleMessage(
            "Distanza per i terremoti nelle vicinanze"),
        "earthquake": MessageLookupByLibrary.simpleMessage("Terremoto"),
        "earthquakesCountSettingsTile": MessageLookupByLibrary.simpleMessage(
            "Numero di terremoti da caricare per volta"),
        "finish": MessageLookupByLibrary.simpleMessage("termina"),
        "general": MessageLookupByLibrary.simpleMessage("Generale"),
        "githubTileDescription": MessageLookupByLibrary.simpleMessage(
            "Quake è un progetto open source, delle PR con tue modifiche sono ben accette. Se stai riscontrando problemi con l\'applicazione controlla l\'issue tracker."),
        "githubTileTitle":
            MessageLookupByLibrary.simpleMessage("Contribuisci a Quake"),
        "indigoLight": MessageLookupByLibrary.simpleMessage("Blu chiaro"),
        "kilometers": MessageLookupByLibrary.simpleMessage("kilometri"),
        "kilometersShort": MessageLookupByLibrary.simpleMessage("km"),
        "light": MessageLookupByLibrary.simpleMessage("Chiaro"),
        "lightMap": MessageLookupByLibrary.simpleMessage("Mappa chiara"),
        "loadingEarthquakeInfos": MessageLookupByLibrary.simpleMessage(
            "Carico le informazioni del terremoto..."),
        "loadingWithDots":
            MessageLookupByLibrary.simpleMessage("Caricamento..."),
        "locationNotEnabled": MessageLookupByLibrary.simpleMessage(
            "Non hai concesso il permesso di localizzazione, concedilo per poter vedere i terremoti nelle vicinanze."),
        "locationPromptAlertContent": MessageLookupByLibrary.simpleMessage(
            "Quake ha bisogno del permesso di localizzazione per mostrare i terremoti nelle vicinanze, i dati sono salvati nello storage locale."),
        "locationPromptAlertTitle":
            MessageLookupByLibrary.simpleMessage("Localizzazione"),
        "magnitude": MessageLookupByLibrary.simpleMessage("Magnitudo"),
        "malformedResponse": MessageLookupByLibrary.simpleMessage(
            "Brutte notizie, il server ha risposto in un modo che non riconosco. Controlla se ci sono aggiornamenti dell\'applicazione e contatta lo sviluppatore."),
        "map": MessageLookupByLibrary.simpleMessage("Mappa"),
        "mapProviderSettingsTile":
            MessageLookupByLibrary.simpleMessage("Provider mappe"),
        "maxDepth": MessageLookupByLibrary.simpleMessage("Profondità massima"),
        "maxMagnitude":
            MessageLookupByLibrary.simpleMessage("Magnitudo massimo"),
        "meters": MessageLookupByLibrary.simpleMessage("metri"),
        "metersShort": MessageLookupByLibrary.simpleMessage("m"),
        "miles": MessageLookupByLibrary.simpleMessage("miglia"),
        "milesShort": MessageLookupByLibrary.simpleMessage("mi"),
        "minDepth": MessageLookupByLibrary.simpleMessage("Profondità minima"),
        "minMagnitude":
            MessageLookupByLibrary.simpleMessage("Magnitudo minimo"),
        "minMagnitudeSettingsTile": MessageLookupByLibrary.simpleMessage(
            "Magnitudo minimo per il marker sulla mappa"),
        "nearby": MessageLookupByLibrary.simpleMessage("Nei dintorni"),
        "next": MessageLookupByLibrary.simpleMessage("prossimo"),
        "noEarthquakes": MessageLookupByLibrary.simpleMessage(
            "Non ci sono stati terremoti negli ultimi giorni."),
        "noInternetConnection": MessageLookupByLibrary.simpleMessage(
            "Non sei connesso ad internet, devi avere una connessione attiva per poter vedere gli ultimi terremoti."),
        "noResponse": MessageLookupByLibrary.simpleMessage(
            "Il server non ha risposto, questo potrebbe essere un problema di connessione o un problema del server. Riprova tra qualche minuto."),
        "notAvailable":
            MessageLookupByLibrary.simpleMessage("Non disponibile."),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifiche"),
        "notificationsSettingsTile": MessageLookupByLibrary.simpleMessage(
            "Abilità/Disabilita notifiche."),
        "other": MessageLookupByLibrary.simpleMessage("Altro"),
        "peopleInvolved":
            MessageLookupByLibrary.simpleMessage("Persone coinvolte"),
        "promptForLocationPermissionButton":
            MessageLookupByLibrary.simpleMessage(
                "Concedi permesso di localizzazione."),
        "search": MessageLookupByLibrary.simpleMessage("Cerca terremoti"),
        "searchBoxLabel":
            MessageLookupByLibrary.simpleMessage("Cerca per posizione"),
        "searchTooltip": MessageLookupByLibrary.simpleMessage("Ricerca"),
        "settings": MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "settingsTooltip": MessageLookupByLibrary.simpleMessage("impostazioni"),
        "shareIntentText": m0,
        "shareNotAvailable": MessageLookupByLibrary.simpleMessage(
            "Azione non disponibile per questo terremoto..."),
        "skip": MessageLookupByLibrary.simpleMessage("salta"),
        "specialThanks":
            MessageLookupByLibrary.simpleMessage("Ringraziamenti speciali"),
        "specialThanksTile":
            MessageLookupByLibrary.simpleMessage("Collaboratori"),
        "title": MessageLookupByLibrary.simpleMessage("Quake"),
        "unexpectedException": m1,
        "welcomeDescription": MessageLookupByLibrary.simpleMessage(
            "Keep track of the earthquakes near you to stay safe."),
        "welcomeTitle":
            MessageLookupByLibrary.simpleMessage("Welcome to Quake!")
      };
}
