// NACA 4-digit and ellipse profile generation.
function digit(s,i)=ord(s[i])-ord("0");
function naca_params(code)=let(m=digit(code,0)/100,p=digit(code,1)/10,t=(digit(code,2)*10+digit(code,3))/100)[m,p,t];
function cosspace(i,n)=0.5*(1-cos(180*i/n));
function naca_yt(x,t)=5*t*(0.2969*sqrt(max(x,0))-0.1260*x-0.3516*x*x+0.2843*x*x*x-0.1015*x*x*x*x);
function naca_yc(x,m,p)=(m==0||p==0)?0:(x<p?(m/(p*p))*(2*p*x-x*x):(m/((1-p)*(1-p)))*((1-2*p)+2*p*x-x*x));
function naca_dyc(x,m,p)=(m==0||p==0)?0:(x<p?(2*m/(p*p))*(p-x):(2*m/((1-p)*(1-p)))*(p-x));
function naca4_points(code,n=80)=
let(mp=naca_params(code),m=mp[0],p=mp[1],t=mp[2])
concat(
  [for(i=[0:n]) let(x=cosspace(i,n),yc=naca_yc(x,m,p),th=atan(naca_dyc(x,m,p)),yt=naca_yt(x,t)) [x-yt*sin(th),yc+yt*cos(th)]],
  [for(ii=[0:n]) let(i=n-ii,x=cosspace(i,n),yc=naca_yc(x,m,p),th=atan(naca_dyc(x,m,p)),yt=naca_yt(x,t)) [x+yt*sin(th),yc-yt*cos(th)]]
);
function ellipse_points(scale=0.5,n=80)=[for(i=[0:n-1]) let(a=360*i/n)[(cos(a)+1)/2,sin(a)*scale/2]];
function profile_points(profile,n=80)=is_string(profile)?naca4_points(profile,n):(is_list(profile)&&profile[0]=="ellipse"?ellipse_points(profile[1],n):naca4_points("0012",n));

function find_span(t,pcts,i=0)=i>=len(pcts)-1?len(pcts)-2:(t<=pcts[i+1]?i:find_span(t,pcts,i+1));
function pct_to_t(t,pcts)=t*100;
function interp_at(t,pcts,vals)=
let(x=pct_to_t(t,pcts),i=find_span(x,pcts),f=(x-pcts[i])/(pcts[i+1]-pcts[i]))
lerp(vals[i],vals[i+1],f);
