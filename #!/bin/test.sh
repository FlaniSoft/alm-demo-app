#!/bin/bash
echo "Starte automatisierte Qualitätsprüfung..."

# Prüfung 1: Existiert die index.html?
if [ ! -f "index.html" ]; then
  echo "FEHLER: index.html fehlt!"
  exit 1
fi

# Prüfung 2: Enthält die Seite den Pflicht-Titel?
if ! grep -q "FlaniSoft ALM Demo" index.html; then
  echo "FEHLER: Pflicht-Titel nicht gefunden!"
  exit 1
fi

echo "Alle Quality Gates erfolgreich bestanden!"
exit 0
