# Testplan

## Konfiguration und Hardware

- [x] `esphome config` läuft ohne Warnungen oder Fehler durch.
- [x] Firmware kompiliert für den erkannten ESP32 mit 4 MB Flash.
- [ ] Matrixorientierung und Farben stimmen.
- [ ] Beim Booten bleibt der Buzzer still.
- [ ] Links, Mitte und Rechts werden zuverlässig erkannt.
- [ ] RTC, Lichtsensor und SHT3x werden auf dem I²C-/ADC-Bus erkannt.
- [ ] Temperatur und Luftfeuchte erscheinen in Home Assistant und werden aufgezeichnet.
- [ ] Der Temperatur-Offset ist gegen ein Referenzthermometer kalibriert.

## Uhr und Persistenz

- [ ] Nach Netzzeitsynchronisation stimmt die Uhrzeit inklusive Zeitzone.
- [ ] Kaltstart ohne WLAN liest eine gültige Zeit aus dem DS1307.
- [ ] Beide Weckzeiten und Aktivschalter überstehen einen Neustart.
- [ ] Helligkeit und Schlummerdauer überstehen einen Neustart.
- [ ] Batteriestand und Batteriespannung erscheinen in Home Assistant und im Webinterface.
- [ ] Unter 20 Prozent ertönt einmal pro Minute ein kurzer Akkuhinweis.
- [ ] Während Alarm oder Snooze wird der Akkuhinweis unterdrückt.
- [ ] Alarmprüfung läuft an Sekunde 00 jeder Minute und löst ohne Bootzeit-Drift aus.
- [ ] Das reguläre Matrixbild wird nur am Minutenwechsel übertragen.
- [ ] Tasten sowie Wecker-, Zeit-, Schlafmodus- und Helligkeitsänderungen aktualisieren das Display sofort.
- [ ] Alarmstatus wechselt beim Klingeln, Schlummern und Beenden sofort in Home Assistant.
- [ ] Webinterface und ESPHome-API bleiben mit WLAN-Sparmodus HIGH stabil erreichbar.
- [x] Schlafmodus-Zeiten, Vorlauf und RTTTL-Felder werden per API veröffentlicht.
- [ ] Schlafmodus-Zeiten, Vorlauf und RTTTL-Felder überstehen einen Neustart.

## Bedienung und Schlafmodus

- [ ] Links zeigt beim ersten Druck Weckzeit 1 und schaltet beim zweiten Druck Wecker 1 um.
- [ ] Rechts zeigt beim ersten Druck Weckzeit 2 und schaltet beim zweiten Druck Wecker 2 um.
- [ ] Außerhalb des Schlafmodus zeigt Mitte direkt das Datum.
- [ ] Im Schlafmodus zeigt Mitte zuerst die Uhrzeit und beim zweiten Druck das Datum.
- [ ] Nach vier Sekunden kehrt eine temporäre Seite zur passenden Standardanzeige zurück.
- [ ] Im Schlafmodus bleiben ohne Tastendruck nur die beiden Weckermarker sichtbar.
- [ ] Das Nachtfenster funktioniert über Mitternacht, beispielsweise 22:00 bis 07:00 Uhr.
- [ ] Der Vorlauf aktiviert den Schlafmodus zur erwarteten Minute vor dem nächsten aktiven Wecker.
- [ ] Ein aktiver Wecker vor dem Ende des Nachtfensters beendet den Schlafmodus zu seiner Weckzeit.
- [ ] Bei zwei aktiven Weckern beendet die frühere Weckzeit den Schlafmodus.

## Alarmfälle

- [ ] Wecker 1 und Wecker 2 lösen einzeln aus.
- [ ] Beide in Home Assistant geänderten RTTTL-Klingeltöne werden korrekt abgespielt.
- [ ] Beide Wecker können gleichzeitig aktiv sein.
- [ ] Identische Zeiten werden als gemeinsamer Alarm dargestellt.
- [ ] Ein kurzer Tastendruck schlummert einen klingelnden Alarm.
- [ ] Ein langer Tastendruck beendet Klingeln oder Snooze.
- [ ] Die maximale Klingeldauer stoppt den Alarm automatisch.
- [ ] Ein Neustart während Snooze setzt Snooze korrekt fort.
- [ ] Ein Neustart im Nachholfenster löst genau einmal aus.
- [x] Eine auf später am selben Tag geänderte Weckzeit löst erneut aus, auch wenn
      der Wecker heute bereits geklingelt hat.
- [x] Der Klingelton wird ohne `rtttl`-Fehler im Log abgespielt.
- [ ] Eine erneute Zeit- oder WLAN-Synchronisation löst nicht doppelt aus.
- [ ] Bei aktiviertem Werktagsmodus erfolgt am Wochenende kein Alarm.

## Lesetimer

- [ ] Die Presets 10/20/30 Minuten starten den Countdown korrekt.
- [ ] `Lesezeit` plus `Lesetimer starten` übernimmt die eingestellte Dauer.
- [ ] Beim Start blendet das Display vier Sekunden die Restzeit ein.
- [ ] Der violette Balken unten startet bei vollen 32 Pixeln und schrumpft mit der Restdauer, solange der Timer läuft.
- [ ] Der Balken bleibt auch im Schlafmodus sichtbar.
- [ ] `Verbleibende Lesezeit` zählt in Home Assistant minütlich herunter.
- [ ] Der Lesetimer klingelt mit der eigenen RTTTL-Melodie.
- [ ] Kurzer und langer Tastendruck beenden das Klingeln gleichermaßen.
- [ ] `Lesetimer abbrechen` stoppt sowohl Countdown als auch Klingeln.
- [ ] Die maximale Lesetimer-Klingeldauer stoppt nach zwei Minuten.
- [ ] Ein Neustart während des Countdowns setzt ihn korrekt fort.
- [ ] Ein Lesetimer, der über eine Stunde überfällig ist, klingelt nicht mehr.
- [ ] Der Lesetimer läuft auch am Wochenende bei aktivem Werktagsmodus.
- [ ] Fällt ein Weckalarm in dieselbe Minute, gewinnt der Weckalarm.
- [ ] Ein Weckalarm verdrängt einen bereits klingelnden Lesetimer sofort.
- [ ] `Klingelt` bleibt beim Lesetimer aus, `Lesetimer klingelt` geht an.

## Klingelbild

- [ ] Beim Klingeln erscheinen Weckerkennung und aktuelle Uhrzeit, z. B. `W1 06:15`.
- [ ] `W12 06:15` passt bei gleichzeitigem Alarm ohne Überlauf auf die Matrix.
- [ ] Die Uhrzeit im Klingelbild läuft während des Alarms mit.
- [ ] Der Regenbogen läuft oben und unten gegenläufig und ruckelt nicht.
- [ ] Nach Stop oder Snooze endet die Animation sofort.
- [ ] Nach einem Neustart im Klingelzustand läuft die Animation wieder an.
- [ ] Bei ungültiger Zeit zeigt das Klingelbild `--:--` statt einer Falschzeit.

## Ausfalltests

- [ ] Home Assistant vor der Weckzeit stoppen: lokaler Alarm funktioniert.
- [ ] WLAN vor der Weckzeit abschalten: lokaler Alarm funktioniert.
- [ ] USB kurz unterbrechen: Gerät läuft über Akku weiter.
- [ ] Gerät 24 bis 48 Stunden mit aktivierter Anzeige betreiben.

## Abnahme im Kinderzimmer

- [ ] Nacht-Helligkeit ist lesbar, stört aber nicht beim Schlafen.
- [ ] Beide Statusmarker sind aus der üblichen Entfernung verständlich.
- [ ] Buzzerlautstärke ist ausreichend und nicht schmerzhaft.
- [ ] Das Zwei-Klick-Umschalten verhindert versehentliche Änderungen beim Nachsehen.
