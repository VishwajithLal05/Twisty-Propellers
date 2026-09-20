// Vector and interpolation helpers for Toroidal Propeller Generator.
function vadd(a,b) = [a[0]+b[0],a[1]+b[1],a[2]+b[2]];
function vsub(a,b) = [a[0]-b[0],a[1]-b[1],a[2]-b[2]];
function vscale(a,s) = [a[0]*s,a[1]*s,a[2]*s];
function vdot(a,b) = a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
function vcross(a,b) = [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]];
function vnorm(a) = sqrt(vdot(a,a));
function vunit(a) = let(n=vnorm(a)) (n<1e-9 ? [1,0,0] : vscale(a,1/n));
function lerp(a,b,t) = a + (b-a)*t;
function clamp(x,a,b) = x<a?a:(x>b?b:x);
function clamp01(x) = clamp(x,0,1);
function slerp_scalar(a,b,t) = a + (b-a)*t;
