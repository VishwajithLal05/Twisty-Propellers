# Parameter Study

A useful next step is to treat Twisty Propellers as a design-space generator.

## Candidate variables

| Variable | Example range |
|---|---|
| Blade count | 2–4 |
| Blade length | 30–80 mm |
| Chord | 2–10 mm |
| Attack angle | -10° to 30° |
| Path width | 10–40% |
| Hub diameter | 12–25 mm |

These ranges are examples for computational exploration, not recommended operating limits.

## Study structure

A simple sweep could be:

```text
Design A
  blade_count = 2
  chord = 6 mm
  attack = 10°

Design B
  blade_count = 2
  chord = 7 mm
  attack = 10°

Design C
  blade_count = 2
  chord = 8 mm
  attack = 10°
```

The resulting geometries can then be evaluated using a separate aerodynamic workflow.

## Important principle

Do not compare geometries solely by visual appearance. Define the performance metric before running the sweep.
