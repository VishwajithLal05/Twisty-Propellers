include <math.scad>;
include <path.scad>;
include <profiles.scad>;

function profile_section(t,profiles,profile_pcts,chords,pivots,angles,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x,N=80) =
let(
  x=t*100,i=find_span(x,profile_pcts),f=(x-profile_pcts[i])/(profile_pcts[i+1]-profile_pcts[i]),
  chord=lerp(chords[i],chords[i+1],f),pivot=lerp(pivots[i],pivots[i+1],f),ang=lerp(angles[i],angles[i+1],f),
  path=toroidal_path(t,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x),
  T=path_tangent(t,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x),
  F=frame_from_tangent(T),X=F[0],Y=F[1],Z=F[2],
  P=profile_points((f<0.5?profiles[i]:profiles[i+1]),N)
)
[for(q=P) let(cx=(q[0]-pivot/100)*chord,cy=q[1]*chord,c=cos(ang),s=sin(ang),xx=c*cx-s*cy,yy=s*cx+c*cy)
 vadd(path,vadd(vscale(X,xx),vscale(Y,yy)))];

module polygon_at(points){ polygon(points=[for(p=points)[p[0],p[1]]]); }

module loft_pair(a,b){
  // Hull between corresponding polygon sections. Each section is coplanar
  // perpendicular to the path tangent; hull produces a watertight span.
  hull(){
    for(p=a) translate(p) sphere(r=0.001,$fn=8);
    for(p=b) translate(p) sphere(r=0.001,$fn=8);
  }
}

module toroidal_blade(
 profiles=["2412","2412",["ellipse",0.5],"2412","8412"],
 profile_pcts=[0,35,50,87,100], chords=[8,3,2.5,3,4], pivots=[50,25,100,50,65], angles=[15,40,-90,0,10],
 hub_d=16,hub_h=6,blade_len=40,blade_offset=2,lead_w=25,trail_w=20,lead_x=50,trail_x=80,path_portion=1,
 N=80,steps_per_span=12){
  for(k=[0:len(profile_pcts)-2]){
    t0=path_portion*profile_pcts[k]/100;
    t1=path_portion*profile_pcts[k+1]/100;
    for(j=[0:steps_per_span-1]){
      ta=t0+(t1-t0)*j/steps_per_span;
      tb=t0+(t1-t0)*(j+1)/steps_per_span;
      loft_pair(
        profile_section(ta,profiles,profile_pcts,chords,pivots,angles,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x,N),
        profile_section(tb,profiles,profile_pcts,chords,pivots,angles,hub_d,hub_h,blade_len,blade_offset,lead_w,trail_w,lead_x,trail_x,N)
      );
    }
  }
}
