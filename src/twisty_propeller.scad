// Toroidal Propeller Generator
// Parametric OpenSCAD model. All dimensions are millimetres.
include <math.scad>;
include <loft.scad>;

module propeller_hub(hub_d=16,hub_height=6,hub_screw_d=5.5,hub_notch_height=0,hub_notch_d=0){
  difference(){
    cylinder(d=hub_d,h=hub_height,$fn=max(64,$fn));
    translate([0,0,-0.02]) cylinder(d=hub_screw_d,h=hub_height+0.04,$fn=64);
    if(hub_notch_height>0 && hub_notch_d>0)
      translate([0,0,-0.02]) cylinder(d=hub_notch_d,h=hub_notch_height+0.02,$fn=64);
  }
}

module toroidal_propeller(
  blades=2, rotation="CCW",
  hub_height=6,hub_d=16,hub_screw_d=5.5,hub_notch_height=0,hub_notch_d=0,
  blade_length=40,blade_offset=2,leading_blade_width=25,trailing_blade_width=20,
  leading_blade_xoffset=50,trailing_blade_xoffset=80,
  profiles=["2412","2412",["ellipse",0.5],"2412","8412"],
  profile_pcts=[0,35,50,87,100],chords=[8,3,2.5,3,4],chord_pivot_pcts=[50,25,100,50,65],
  attack_angles=[15,40,-90,0,10],path_portion=1.0,
  loft_profile_points=80,loft_steps_per_span=12){

  assert(blades>=1,"blades must be >= 1");
  assert(len(profiles)==len(profile_pcts) && len(profiles)==len(chords) && len(profiles)==len(chord_pivot_pcts) && len(profiles)==len(attack_angles),"Profile arrays must have equal length");
  assert(path_portion>0 && path_portion<=1,"path_portion must be in (0,1]");
  assert(rotation=="CW" || rotation=="CCW","rotation must be CW or CCW");

  module blades_group(){
    for(b=[0:blades-1]) rotate([0,0,360*b/blades])
      toroidal_blade(profiles,profile_pcts,chords,chord_pivot_pcts,attack_angles,hub_d,hub_height,blade_length,blade_offset,leading_blade_width,trailing_blade_width,leading_blade_xoffset,trailing_blade_xoffset,path_portion,loft_profile_points,loft_steps_per_span);
  }

  if(rotation=="CW") mirror([1,0,0]) blades_group();
  else blades_group();
  propeller_hub(hub_d,hub_height,hub_screw_d,hub_notch_height,hub_notch_d);
}
