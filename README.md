# Kinder-Wecker für Ulanzi TC001

Eigenständige Kinder-Wecker auf Basis von ESPHome und der Ulanzi TC001 Pixel
Clock. Die zwei Weckzeiten sind als „1. Stunde“ und „2. Stunde“ modelliert und
können unabhängig voneinander aktiviert werden.

Es gibt zwei baugleiche Geräte mit identischer Firmware:

| Gerät | Konfiguration | Adresse |
|---|---|---|
| Wecker 1 | `esphome/wecker-1.yaml` | 192.168.1.51 |
| Wecker 2 | `esphome/wecker-2.yaml` | 192.168.1.52 |

Jede dieser Dateien enthält nur Name, Adresse und die gerätespezifischen
Zugangsdaten. Alles Gemeinsame liegt in `esphome/packages/base.yaml`, sodass
eine Änderung an Hardware, Anzeige oder Alarmlogik beide Wecker zugleich trifft.

Der eigentliche Alarm läuft vollständig auf dem TC001. Home Assistant wird zum
Einstellen, Anzeigen und für optionale Aktionen wie Licht oder Lautsprecher
verwendet, ist aber zum Weckzeitpunkt nicht erforderlich.

## Funktionen

- zwei lokal gespeicherte Weckzeiten
- unabhängige Aktivierung beider Wecker
- optional nur Montag bis Freitag
- lokaler DS1307 als Zeit-Fallback ohne WLAN
- Netzzeitsynchronisation mit Rückschreiben in den RTC
- lokale Melodie über den eingebauten Buzzer
- Snooze, Stop und Testalarm
- Lesetimer mit lokalem Countdown, per Home Assistant gestartet
- Uhr als permanente Hauptanzeige
- animiertes Klingelbild mit Wecker, Uhrzeit und Regenbogenrahmen
- Statusmarker links und rechts für beide Wecker
- Datum und Weckzeitvorschau über die Gerätetasten
- Schlafmodus per Nachtfenster und Vorlauf vor dem nächsten aktiven Wecker
- drei in Home Assistant änderbare RTTTL-Klingeltöne
- automatische Helligkeit über den eingebauten Lichtsensor
- sichtbarer Akku-Prozentwert mit Warnsignal unter 20 Prozent
- native Home-Assistant-Entitäten über die ESPHome-API

## Bedienung

| Taste | Kurz | Lang |
|---|---|---|
| Links | 1. Druck: Weckzeit 1; 2. Druck: Wecker 1 umschalten | laufenden Alarm beenden |
| Mitte | Uhrzeit, beim zweiten Druck Datum (bei "Uhr nur auf Tastendruck" oder Schlafmodus; sonst direkt Datum) | laufenden Alarm beenden |
| Rechts | 1. Druck: Weckzeit 2; 2. Druck: Wecker 2 umschalten | laufenden Alarm beenden |

Jede eingeblendete Seite kehrt nach vier Sekunden zur Standardanzeige zurück.
Der zweite Druck muss deshalb innerhalb dieser vier Sekunden erfolgen; danach
beginnt die Sequenz wieder beim Anzeigen. Das ist beabsichtigt und verhindert,
dass beim bloßen Nachsehen versehentlich ein Wecker umgeschaltet wird.

Während der Wecker klingelt, aktiviert ein kurzer Druck auf eine beliebige Taste
Snooze. Ein langer Druck von mindestens 0,7 Sekunden beendet den Alarm oder
einen bereits schlummernden Alarm; der Wecker bleibt für den nächsten Tag aktiv.

Auf der normalen Uhranzeige gehört der linke Marker zum Wecker für die erste
Stunde, der rechte zum Wecker für die zweite Stunde. Ein heller Zwei-Pixel-Balken
bedeutet aktiv, ein schwacher roter Punkt bedeutet aus.

Während ein Weckalarm klingelt, zeigt das Display den auslösenden Wecker und
die aktuelle Uhrzeit — `W1 06:15`, `W2 07:15` oder `W12 06:15`, wenn beide
gleichzeitig fällig waren. Oben und unten läuft dazu ein gegenläufiger
Regenbogen. Solange der Alarm klingelt, wird die Matrix rund achtmal pro
Sekunde neu übertragen statt einmal pro Minute; die Animation endet von selbst,
sobald der Alarm beendet oder geschlummert wird. Der Lesetimer bleibt bewusst
ruhig und zeigt weiterhin nur seinen violetten Rahmen.

Standardmäßig ist das Display dunkel (Schalter "Uhr nur auf Tastendruck"): Es zeigt nur die Weckermarker und den Lesetimer-Balken; die Uhrzeit erscheint per Mitteltaste für 4 s, und bei klingelndem Wecker/Lesetimer schaltet sich das Display selbst ein. Ist der Schalter aus, zeigt die Uhr dauerhaft die Zeit, außer im Schlafmodus.

Der Schlafmodus ist standardmäßig von 22:00 bis 07:00 Uhr aktiv und beginnt
zusätzlich bis zu 480 Minuten vor dem nächsten aktiven Wecker. Liegt der erste
aktive Wecker vor dem Ende des Nachtfensters, beendet er den Schlafmodus bereits
zu seiner Weckzeit. Im Schlafmodus bleiben nur die beiden Weckermarker sichtbar.
Die Uhr lässt sich mit der mittleren Taste kurz einblenden; ein weiterer Druck
zeigt das Datum.

## Lesetimer

Wenn abends noch gelesen werden darf, lässt sich über Home Assistant — zum
Beispiel über ein NSPanel am Türrahmen — ein Lesetimer starten. Nach Ablauf
klingelt der TC001 mit einer eigenen, bewusst leiseren Melodie.

Zum Starten gibt es drei feste Schaltflächen für 10, 20 und 30 Minuten sowie
die Kombination aus der Zahl `Lesezeit` und `Lesetimer starten` für jede andere
Dauer. `Lesetimer abbrechen` stoppt einen laufenden Countdown und ein bereits
klingelndes Signal.

Der Countdown läuft vollständig auf dem Gerät. Er überlebt einen Neustart und
klingelt auch dann, wenn Home Assistant oder das WLAN zu diesem Zeitpunkt nicht
erreichbar sind. Geprüft wird wie beim Wecker zum Minutenwechsel, der Alarm
kann also bis zu eine Minute nach der eingestellten Dauer ertönen. War das
Gerät beim Ablauf länger als eine Stunde aus, entfällt der Timer.

Sobald der Lesetimer klingelt, beendet **jeder** kurze oder lange Tastendruck das
Signal. Während der Countdown noch läuft, behalten die Tasten ihre normalen
Uhr- und Weckerfunktionen; abbrechen lässt er sich über Home Assistant. Anders
als beim Wecker gibt es bewusst kein Schlummern: Verlängern bleibt eine
Entscheidung der Eltern. Ein echter Weckalarm hat immer Vorrang und verdrängt
auch einen bereits klingelnden Lesetimer.

Auf der Uhranzeige zeigt ein dezenter violetter Balken in der untersten Zeile
einen laufenden Lesetimer an. Seine Länge entspricht der Restdauer (32 Pixel =
volle Zeit, er schrumpft von rechts); er bleibt auch im Schlafmodus sichtbar. Beim Starten
blendet das Display für vier Sekunden die verbleibenden Minuten ein.

## Schnellstart

1. Die Originalfirmware wie in [docs/flashing.md](docs/flashing.md) sichern.
2. `esphome/secrets.example.yaml` nach `esphome/secrets.yaml` kopieren.
3. WLAN-Zugangsdaten sowie je Gerät API-Schlüssel und OTA-Passwort eintragen.
4. Konfiguration prüfen:

   ```shell
   esphome config esphome/wecker-1.yaml
   esphome config esphome/wecker-2.yaml
   ```

5. Über USB installieren und anschließend in Home Assistant hinzufügen.
6. Beide Testalarm-Schaltflächen ausprobieren, bevor echte Weckzeiten aktiviert werden.

## ESPHome Builder (direkt von GitHub)

Im ESPHome Builder von Home Assistant braucht jedes Gerät nur eine kleine Datei
mit Name, Zugangsdaten und – optional – fester Adresse. Die Firmware selbst
kommt aus diesem Repository und wird einmal täglich aktualisiert; der Builder
zeigt dann ein Update an.

```yaml
substitutions:
  device_name: wecker-1
  friendly_name: Wecker 1
  timezone: Europe/Berlin

packages:
  wecker:
    url: https://github.com/k3mpaxl/HA-Wecker
    ref: main
    files: [esphome/packages/base.yaml]
    refresh: 1d

api:
  reboot_timeout: 0s
  encryption:
    key: !secret wecker_1_api_encryption_key

ota:
  - platform: esphome
    password: !secret wecker_1_ota_password
```

Die Schriften liegen neben den Paketen (`esphome/packages/fonts/`), damit ESPHome
sie auch beim Laden von GitHub findet. Die Secrets gehören in die `secrets.yaml` des Builders.

## Home Assistant

Nach der ESPHome-Erkennung erscheinen unter anderem zwei Zeitentitäten, zwei
Weckerschalter, Snooze-/Stop-Schaltflächen, die Lesetimer-Schaltflächen,
Alarmstatus, Helligkeit und Diagnosesensoren.

`Klingelt` meldet nur die beiden Weckalarme, `Lesetimer klingelt` nur den
Lesetimer. So kann Home Assistant morgens das Licht ein- und abends
ausschalten.

Beispiele befinden sich in:

- `home-assistant/dashboard-wecker-1.yaml`
- `home-assistant/dashboard-wecker-2.yaml`
- `home-assistant/example-automations.yaml` (auf Wecker 1 verdrahtet; für Wecker 2 die
  Entity-IDs von `wecker_1_` auf `wecker_2_` umstellen)

Home Assistant kann bei Alarm zusätzlich Licht, Rollläden oder einen Lautsprecher
steuern. Diese Automationen sind bewusst kein Ersatz für den lokalen Buzzer.

## Annahmen des ersten Releases

- Beide Wecker wiederholen sich an erlaubten Wochentagen.
- „Nur Montag bis Freitag“ ist standardmäßig aktiv.
- Weckzeiten werden in Home Assistant eingestellt; am Gerät werden sie nur
  angezeigt und aktiviert/deaktiviert.
- Snooze dauert standardmäßig fünf Minuten; der Lesetimer kennt kein Snooze.
- Der Lesetimer klingelt standardmäßig höchstens zwei Minuten.
- Der Alarm endet spätestens nach 15 Minuten.
- Ein Alarm wird nach einem kurzen Neustart bis zu zwei Minuten nachgeholt.

Aufbau und Abläufe der Firmware sind in
[docs/architecture.md](docs/architecture.md) mit Flussdiagrammen dokumentiert.

Eine spätere Version kann einen Wochenplan, Schulferien aus Home Assistant oder
den exklusiven Modus `Aus / 1. Stunde / 2. Stunde` ergänzen, ohne die lokale
Alarmsteuerung zu ersetzen.

## Hardware

| Funktion | TC001-Anschluss |
|---|---|
| 32×8 WS2812-Matrix | GPIO32 |
| Buzzer | GPIO15 |
| Tasten links/mitte/rechts | GPIO26 / GPIO27 / GPIO14 |
| Lichtsensor | GPIO35 |
| Batteriespannung | GPIO34 |
| I²C | GPIO21 / GPIO22 |
| SHT3x | `0x44` |
| DS1307 | `0x68` |

Temperatur und Luftfeuchte des SHT3x werden einmal pro Minute erfasst und über
ein gleitendes Mittel aus fünf Messwerten geglättet. Die gemessene Temperatur
ist wegen der Wärme im Gehäuse typischerweise zu hoch; der Offset-Filter in
`packages/hardware.yaml` ist auf 0,0 vorbelegt und sollte einmal gegen ein
Referenzthermometer im Raum kalibriert werden, bevor die Werte für
Automationen genutzt werden.
Die Akkuanzeige wird aus der Zellspannung geschätzt. Wegen Bauteiltoleranzen und
der lastabhängigen LiPo-Spannung ist sie kein exakter Coulomb-Counter; die rohe
Batteriespannung bleibt zur späteren Kalibrierung ebenfalls sichtbar. Unter 20
Prozent ertönt einmal pro Minute ein kurzer Hinweis, solange kein Alarm aktiv ist.

Zur Reduzierung des Akkuverbrauchs läuft der ESP32 mit 160 MHz und dem hohen
WLAN-Sparmodus. Display und Alarmprüfung werden exakt einmal pro Minute aktualisiert;
Tastendrücke sowie Änderungen an Wecker, Schlafmodus, Alarmzustand oder manueller
Helligkeit lösen weiterhin sofortige Display-Updates aus. Die automatische
Helligkeitsmessung wird beim nächsten Minutenbild sichtbar. Deep Sleep und Auto
Light Sleep sind bewusst nicht aktiv, damit Uhr, Tasten, Home Assistant und
Webinterface durchgehend erreichbar bleiben.
