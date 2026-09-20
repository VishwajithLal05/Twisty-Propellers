# Twisty-Propellers

An OpenSCAD-based parametric generator for toroidal propellers. The project is designed as an independent implementation with a familiar parameter-driven workflow: choose blade count, handedness, hub geometry, toroidal path geometry, airfoil keyframes, chord lengths, pivot locations and local attack angles, then render/export the result as STL.

## Features

- **Multi-blade propellers** — 1, 2, 3, 4+ blades.
- **CW / CCW handedness** — mirror the complete blade set for opposite rotation.
- **Parametric hub** — outer diameter, height, shaft hole and optional underside notch.
- **Toroidal blade path** — five-point Catmull–Rom path with adjustable leading/trailing geometry.
- **NACA 4-digit profiles** — e.g. `0012`, `2412`, `4412`, `8412`.
- **Ellipse sections** — useful for root/tip transition or experimental geometry.
- **Keyframed loft** — vary profile, chord, chord pivot and attack angle along the path.
- **Partial-path rendering** — useful for debugging or studying one section of the toroid.
- **Adjustable tessellation** — separate profile resolution and loft resolution.
- **Pure OpenSCAD** — no external Python/CAD dependency is required.

## Quick start

1. Install [OpenSCAD](https://openscad.org/).
2. Open `examples/example.scad`.
3. Change the parameters passed to `twisty_propeller()`.
4. Press **F6** to render.
5. Export using **File → Export → Export as STL**.

The main public module is:

```scad
toroidal_propeller(
    blades=2,
    rotation="CCW",
    hub_height=6,
    hub_d=16,
    hub_screw_d=5.5,
    blade_length=40,
    blade_offset=2,
    leading_blade_width=25,
    trailing_blade_width=20,
    leading_blade_xoffset=50,
    trailing_blade_xoffset=80,
    profiles=["2412","2412",["ellipse",0.5],"2412","8412"],
    profile_pcts=[0,35,50,87,100],
    chords=[8,3,2.5,3,4],
    chord_pivot_pcts=[50,25,100,50,65],
    attack_angles=[15,40,-90,0,10],
    path_portion=1.0
);
```

## Parameter guide

### Blade count and rotation

| Parameter | Meaning |
|---|---|
| `blades` | Number of identical blades around the hub. |
| `rotation` | `"CCW"` or `"CW"`. |

### Hub

| Parameter | Meaning |
|---|---|
| `hub_height` | Hub thickness in mm. |
| `hub_d` | Hub outside diameter in mm. |
| `hub_screw_d` | Centre shaft/hole diameter in mm. |
| `hub_notch_height` | Optional lower notch depth; `0` disables it. |
| `hub_notch_d` | Optional notch diameter; `0` disables it. |

### Toroidal path

| Parameter | Meaning |
|---|---|
| `blade_length` | Distance from hub region to the outer midpoint. |
| `blade_offset` | Vertical separation between the two hub-side ends. |
| `leading_blade_width` | Leading control-point width as % of blade length. |
| `trailing_blade_width` | Trailing control-point width as % of blade length. |
| `leading_blade_xoffset` | Leading control-point X position as % of blade length. |
| `trailing_blade_xoffset` | Trailing control-point X position as % of blade length. |
| `path_portion` | Portion of the path to generate, from 0 to 1. |

The path is generated from five control locations: hub entry → leading control → outer midpoint → trailing control → hub exit. A Catmull–Rom interpolation provides a smooth centreline.

### Airfoil keyframes

All five arrays below must have the same length:

- `profiles`
- `profile_pcts`
- `chords`
- `chord_pivot_pcts`
- `attack_angles`

`profile_pcts` specifies where a section occurs along the path, from 0–100%.

Example:

```scad
profiles=["4412","2412",["ellipse",0.5],"2412","0010"];
profile_pcts=[0,25,50,75,100];
chords=[8,5,3,4,6];
chord_pivot_pcts=[50,50,50,50,50];
attack_angles=[12,18,-90,-4,8];
```

### Profile formats

NACA 4-digit:

```scad
"2412"
```

Ellipse:

```scad
["ellipse",0.5]
```

The ellipse scale controls its thickness relative to its chord.

## Resolution

Two controls affect geometry quality:

- `$fn` controls general OpenSCAD tessellation.
- `loft_profile_points` controls points around each airfoil.
- `loft_steps_per_span` controls how many loft slices are generated between adjacent keyframes.

For fast development, try:

```scad
$fn=32;
loft_profile_points=32;
loft_steps_per_span=5;
```

For final export, increase them progressively. Very high values can make OpenSCAD rendering expensive because the blade is constructed from many hull operations.

## Repository layout

```text
Twisty-Propeller/
├── README.md
├── LICENSE
├── .gitignore
├── examples/
│   ├── example.scad
│   └── three_blade.scad
└── src/
    ├── math.scad
    ├── path.scad
    ├── profiles.scad
    ├── loft.scad
    └── twisty_propeller.scad
```

## Design notes

This implementation separates the generator into four layers:

1. **Vector mathematics** — reusable 3D vector operations.
2. **Path generation** — toroidal centreline and local tangent/frame.
3. **Profile generation** — NACA and ellipse sections.
4. **Loft assembly** — keyframe interpolation and watertight blade construction.

That separation is intentional: it makes the project easier to extend with additional airfoil families, custom splines, blade twist laws, hub geometries, and analysis exports later.

## Engineering caution

This is a geometry generator, not an aerodynamic validation tool. A visually clean toroidal propeller is not automatically efficient, balanced, structurally safe, or suitable for high-RPM operation. Validate mass properties, static balance, structural stresses, vibration, motor loading and aerodynamic performance before operating a printed or manufactured propeller.

## Attribution / inspiration

The parameterized toroidal-propeller workflow was inspired by publicly documented OpenSCAD projects such as Raul Bejarano's **Ultimate Toroidal Propeller Generator**. This repository is an independent implementation rather than a fork or a copy of that project's source files. See the original project for comparison and additional ideas.

## Roadmap

- [ ] More NACA families / 5-digit NACA support
- [ ] User-defined arbitrary airfoil coordinate arrays
- [ ] Blade twist presets
- [ ] Thickness scaling independent of chord
- [ ] Root fillet controls
- [ ] Hub mounting patterns
- [ ] Automatic STL batch generation
- [ ] OpenSCAD customizer-friendly parameter layout
- [ ] Geometry diagnostics and self-intersection checks
- [ ] Optional aerodynamic analysis workflow

## License

MIT. See `LICENSE`.
