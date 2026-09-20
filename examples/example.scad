$fn=64;
use <../src/twisty_propeller.scad>;

toroidal_propeller(
  blades=2,
  rotation="CCW",
  hub_height=6,
  hub_d=16,
  hub_screw_d=5.5,
  hub_notch_height=0,
  hub_notch_d=0,
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
  path_portion=1.0,
  loft_profile_points=16,
  loft_steps_per_span=2
);
