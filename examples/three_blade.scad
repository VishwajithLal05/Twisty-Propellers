$fn=72;
use <../src/toroidal_propeller.scad>;

toroidal_propeller(
  blades=3, rotation="CW",
  hub_d=18, hub_height=7, hub_screw_d=6,
  blade_length=55, blade_offset=3,
  leading_blade_width=22, trailing_blade_width=22,
  leading_blade_xoffset=48, trailing_blade_xoffset=72,
  profiles=["4412","2412",["ellipse",0.45],"2412","0010"],
  profile_pcts=[0,30,50,80,100],
  chords=[9,5,3,4,6],
  chord_pivot_pcts=[50,50,50,50,50],
  attack_angles=[12,20,-90,-5,8],
  loft_profile_points=56,
  loft_steps_per_span=10
);
