# TC001 sichern und flashen

## 1. Originalfirmware sichern

Vor dem ersten Flashen sollte der vollständige Flash gesichert werden. Die hier
getestete TC001-Revision besitzt 4 MB; die Größe vorab immer mit `flash-id`
prüfen.
Der TC001 enthält einen CH340-USB-Seriell-Wandler und kann direkt per USB-C
angeschlossen werden.

Seriellen Port finden:

```shell
ls /dev/cu.*
```

Flash-ID und Größe prüfen:

```shell
python3 -m esptool --port /dev/cu.usbserial-XXXX flash-id
```

Originalfirmware sichern:

```shell
python3 -m esptool --port /dev/cu.usbserial-XXXX read-flash 0x0 0x400000 ulanzi-backup-4m.bin
```

Bei einer störanfälligen seriellen Verbindung liest das mitgelieferte Skript
den Flash in einzeln wiederholbaren Teilstücken und prüft die Endgröße:

```shell
bash scripts/backup_tc001.sh /dev/cu.usbserial-XXXX backups/ulanzi-backup-4m.bin
```

Die Sicherungsdatei anschließend außerhalb dieses Projekts aufbewahren.

## 2. Zugangsdaten eintragen

`esphome/secrets.example.yaml` nach `esphome/secrets.yaml` kopieren und alle
Platzhalter ersetzen. Der API-Schlüssel lässt sich so erzeugen:

```shell
openssl rand -base64 32
```

## 3. Konfiguration prüfen und kompilieren

Jedes Gerät hat eine eigene Konfigurationsdatei; `wecker-1.yaml` steht hier
stellvertretend für `wecker-2.yaml`.

```shell
esphome config esphome/wecker-1.yaml
esphome compile esphome/wecker-1.yaml
```

## 4. Erstinstallation per USB

```shell
esphome run esphome/wecker-1.yaml --device /dev/cu.usbserial-XXXX
```

Spätere Aktualisierungen können über die ESPHome-Oberfläche oder OTA erfolgen.

## Sicherheit

- Vor dem Flashen das vollständige Backup verifizieren.
- Für den Dauerbetrieb ein zuverlässiges USB-Netzteil verwenden.
- Den Buzzer und die Helligkeit tagsüber testen, bevor der Wecker nachts aktiv ist.
- Die ersten Alarme zusätzlich mit einem unabhängigen Wecker absichern.
