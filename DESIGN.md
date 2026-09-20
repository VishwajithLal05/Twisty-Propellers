# Twisty Propellers — Design & Engineering Notes

## 1. Scope

Twisty Propellers is a parametric geometry generator for experimental toroidal propeller concepts.

The primary objective is reproducible geometry generation. Aerodynamic, structural, acoustic and dynamic validation are intentionally separated from the CAD generator.

## 2. Coordinate system

The generator treats the propeller hub as the reference coordinate system. The blade centreline is generated in Cartesian coordinates and repeated around the hub axis.

A local frame is constructed from the centreline tangent:

- `Z` = local tangent
- `X` = local transverse direction
- `Y` = local normal direction

Airfoil coordinates are transformed into this local frame before being placed on the toroidal path.

## 3. Centreline

The centreline is represented by five principal control locations:

```text
Hub entry → Leading region → Outer midpoint → Trailing region → Hub exit
```

A Catmull–Rom interpolation provides a smooth path through the control geometry.

The path is sampled continuously through the normalized parameter:

```text
0 ≤ t ≤ 1
```

## 4. Section interpolation

Airfoil, chord, pivot and attack-angle parameters are specified at keyframe percentages.

Between two keyframes, scalar parameters are linearly interpolated.

This provides a simple deterministic design language:

```text
keyframe → interpolate → keyframe
```

The approach can later be replaced by higher-order interpolation where useful.

## 5. Loft construction

The current implementation creates many short hull spans between consecutive section samples.

Advantages:

- simple OpenSCAD implementation
- robust conceptual workflow
- easy parameterisation

Trade-offs:

- high computational cost at high resolution
- hull-based surfaces are not equivalent to a true CAD B-spline loft
- aerodynamic surface smoothness depends on section density

## 6. Engineering validation

Generated geometry should be considered a hypothesis rather than a validated propeller.

A useful future workflow is:

```text
Parameter definition
        ↓
OpenSCAD geometry
        ↓
STL / mesh cleanup
        ↓
CFD / aerodynamic analysis
        ↓
FEA / structural analysis
        ↓
Balance + vibration analysis
        ↓
Manufacturing
        ↓
Static thrust test
        ↓
RPM / power / torque characterization
        ↓
Design iteration
```

## 7. Recommended experimental controls

For comparative propeller testing, hold as many variables constant as possible:

- motor
- ESC
- battery voltage
- propeller diameter
- RPM
- test stand
- ambient conditions
- measurement method

Then compare:

- static thrust
- torque
- electrical power
- thrust-to-power ratio
- acoustic measurements

## 8. Safety

Do not operate experimental propellers at high RPM without appropriate containment and engineering validation.

Printed parts can fail due to:

- layer adhesion
- defects
- imbalance
- fatigue
- centrifugal loading
- stress concentration
- resonance

The repository is intended for engineering research and prototyping, not as a guarantee of safe operation.
