#!/bin/sh
# Validate the Wyze plug template with ESPHome's config checker.
# Creates .venv/ on first run and installs ESPHome into it.
set -e
cd "$(dirname "$0")"

VENV=.venv
ESPHOME_VERSION=2026.11.0

if [ ! -x "$VENV/bin/esphome" ]; then
  echo "Creating venv and installing esphome $ESPHOME_VERSION..."
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install --quiet "esphome==$ESPHOME_VERSION"
fi

if [ ! -f tests/secrets.yaml ]; then
  echo "Creating tests/secrets.yaml from example (dummy credentials)..."
  cp tests/secrets.yaml.example tests/secrets.yaml
fi

for f in tests/test-*.yaml; do
  echo "--- Validating $f"
  "$VENV/bin/esphome" config "$f" > /dev/null
done

echo "All configs valid."
