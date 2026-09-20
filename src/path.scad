// Parametric toroidal path. Clean-room implementation based on the documented
// geometry of toroidal blade paths.
include <math.scad>;

function catmull_rom(t,p0,p1,p2,p3) =
let(t2=t*t,t3=t2*t)
[
  0.5*(2*p1[0]+(-p0[0]+p2[0])*t+(2*p0[0]-5*p1[0]+4*p2[0]-p3[0])*t2+(-p0[0]+3*p1[0]-3*p2[0]+p3[0])*t3),
  0.5*(2*p1[1]+(-p0[1]+p2[1])*t+(2*p0[1]-5*p1[1]+4*p2[1]-p3[1])*t2+(-p0[1]+3*p1[1]-3*p2[1]+p3[1])*t3),
  0.5*(2*p1[2]+(-p0[2]+p2[2])*t+(2*p0[2]-5*p1[2]+4*p2[2])*t2+(-p0[2]+3*p1[2]-3*p2[2]+p3[2])*t3)
];

function toroidal_controls(hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x) =
let(
  r=hub_d*cos(30)/2,
  A=[r*cos(60),r*sin(60),hub_h/2+blade_offset/2],
  B=[blade_len*lead_x/100,blade_len*lead_w/100,hub_h/2],
  M=[blade_len,0,hub_h/2],
  C=[blade_len*trail_x/100,-blade_len*trail_w/100,hub_h/2],
  D=[r*cos(60),-r*sin(60),hub_h/2-blade_offset/2]
) [A,B,M,C,D];

function toroidal_path(t,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x) =
let(
  P=toroidal_controls(hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x),
  A=P[0],B=P[1],M=P[2],C=P[3],D=P[4],
  sA=vnorm(vsub(B,A)),sD=vnorm(vsub(D,C)),
  TA=[sA*cos(60),sA*sin(60),0], TD=[sD*cos(-240),sD*sin(-240),0],
  A0=vsub(B,vscale(TA,2)),D3=vadd(C,vscale(TD,2)),
  u=clamp01(t), q=u*4, seg=min(3,floor(q)), f=q-seg,
  p0=seg==0?A0:(seg==1?A:(seg==2?B:M)),
  p1=seg==0?A:(seg==1?B:(seg==2?M:C)),
  p2=seg==0?B:(seg==1?M:(seg==2?C:D)),
  p3=seg==0?M:(seg==1?C:(seg==2?D:D3))
) catmull_rom(f,p0,p1,p2,p3);

function path_tangent(t,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x) =
let(dt=0.0005,a=max(0,t-dt),b=min(1,t+dt))
vunit(vsub(toroidal_path(b,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x),toroidal_path(a,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x)));

function frame_from_tangent(T) =
let(Z=vunit(T),up=abs(Z[2])<0.9?[0,0,1]:[0,1,0],X=vunit(vcross(up,Z)),Y=vcross(Z,X)) [X,Y,Z];

function path_points(n,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x,t_end=1) =
[for(i=[0:n]) toroidal_path(t_end*i/n,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x)];
