# Wyze Plug ESPHome Template

ESPHome package template for the Wyze smart plugs (ESP32-based, two relays
with HLW8012 power monitoring), plus a validation harness so template changes
can be checked before they reach a device.

## Template parameters

Set these as `substitutions:` in the device YAML that includes the template.
Values must be YAML booleans (`true` / `false`, unquoted) — the quoted
strings `"true"` / `"false"` are truthy and will not disable anything.

| Parameter         | Required | Default | Meaning                                                  |
| ----------------- | -------- | ------- | -------------------------------------------------------- |
| `device_name`     | Yes      | —       | Name of the device                                       |
| `relay_1_control` | No       | `true`  | Relay 1 controllable from Home Assistant                 |
| `relay_2_control` | No       | `true`  | Relay 2 controllable from Home Assistant                 |

With control off, the relay is forced on (`ALWAYS_ON`), hidden from Home
Assistant, and its button does nothing (the press routes to a no-op dummy
switch).

## Usage

Device YAML (lives in Home Assistant at `/config/esphome/`):

```yaml
packages:
  plug: !include wyze-plug-template.yaml

substitutions:
  device_name: plug-wyze-sidegarage-network
  relay_2_control: false  # single-relay plug
```

The ESPHome dashboard has no git integration, so after changing the template
here, copy `wyze-plug-template.yaml` into `/config/esphome/` on the Home
Assistant host and reinstall the affected devices from the dashboard.

Devices using this template:

- `plug-wyze-sidegarage-network` (single relay)
- `plug-wyze-sidegarage-desk` (two relays)
- `plug-wyze-furnace-downstairs` (two relays)

## Validation

`esphome config` resolves the template and its substitution expressions
without flashing anything. Two test devices in `tests/` cover the behavior:

- `test-a.yaml` — defaults: all relays controllable, both buttons active
- `test-b.yaml` — relay 1 control off: relay forced on and hidden, button 1
  a no-op

Run locally:

```sh
./validate.sh
```

This creates `.venv/`, installs ESPHome 2026.11.0, generates dummy
`tests/secrets.yaml` from the example if needed, and validates every
`tests/test-*.yaml`. The same check runs in CI on every push and pull
request (`.github/workflows/validate.yml`).

Keep the pinned ESPHome version roughly in step with the version bundled in
the Home Assistant ESPHome Device Builder add-on.
