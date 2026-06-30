by=byss;
prob_def=exp(eta1 + eta2*by)/(1+exp(eta1 + eta2*by)); % probability of default
Delta_G=prob_def*Deltacost;   % Expected loss
ZZ=ZZss;             % Gross growth
shock_ZZ=0 ;         % shock to the ZZ process  
vp=1;                % Price dispersion
tauc=taucss;           % Consumption tax- https://www.oecd.org/en/publications/consumption-tax-trends-2024_dcd4dd36-en.html#:~:text=Standard%20VAT%20rates%20across%20OECD,to%208.1%25%20in%202024).
tauw =tauwss;          % Income tax: https://www.oecd.org/content/dam/oecd/en/topics/policy-issues/tax-policy/taxing-wages-united-states.pdf
PIstar=1;            % Optimnal gross inflation 
PI=1;                % Gross inflation
R=ZZ/betta/(1-0*Delta_G);  % interest rate
rk=ZZ/betta-(1-delta);   % return on private investment
Rmp=R;                   % Monetary policy rate
%(R/ZZ-1)*400 
N=1/3;                    % Effective Labor supply
%H=1;
%L=0.2;
%E=0.1;


%eff=effss;
%effge=effgess;
% Marginal cost 
mc=(epsilon-1)/epsilon;

%kG_y=eff*Igiy/(1-(1-delta)/ZZ);
kG_y=(1-eGI_ss)*Igiy/(ZZ-(1-delta));

Kp_y=(1+Bigtheta_y)*alpha*mc/(markupss*rk);

yt_proxy=(kG_y^alphaG)*(Kp_y^alpha)*(N^(1-alpha));

y=yt_proxy^(1/(1-alphaG-alpha));


W_real=(1-alpha)*mc*y/N/markupss;


% Real wage
%W_real=(mc/((1/(1-alpha))^(1-alpha)*(1/alpha)^alpha*rk^alpha/(kG_y/(1+Bigtheta_y)*1/ZZ)^(alphaG/(1-alphaG))))^(1/(1-alpha));
%mc=(1/(1-alpha))^(1-alpha)*(1/alpha)^alpha*W_real^(1-alpha)*rk^alpha/(kG_y/(1+Bigtheta_y)*1/ZZ)^(alphaG/(1-alphaG));

%Kp=alpha/(1-alpha)*W_real/rk*ZZ*N;

% Private capital
Kp=alpha/(1-alpha)*W_real/rk*N;

% Private investment
Ip=Kp*(ZZ-(1-delta));

%Param_1=1/ZZ^(alphaG+alpha-alphaG*alpha)*(Kp^(alpha*(1-alphaG)))*(N^((1-alpha)*(1-alphaG)));
%y=((Param_1*kG_y^alphaG)/(1+Bigtheta_y))^(1/(1-alphaG));

% Public capital
Kg=kG_y*y;

% Fixed cost
Bigtheta=Bigtheta_y*y;
%Bigtheta_test=1/ZZ^(alphaG+alpha-alphaG*alpha)*(Kg^alphaG)*(Kp^(alpha*(1-alphaG)))*(N^((1-alpha)*(1-alphaG)))-y
%(Bigtheta_test-Bigtheta).^2

% NEW PATH
%kGe_y=effge*Igey/(1-(1-delta)/ZZ);
% Human capital
%kGe_y=effge*Igey/(ZZ-(1-delta));
kGe_y=(1-eGE_ss)*Igey/(ZZ-(1-delta));
Kge=kGe_y*y;
Ige=Igey*y;
Igess=Ige;
Grd=Grdy*y;
Grdss=Grd;




% R&D path
%markupss=1.015;
A=1;
probadopt=probadoptss;
SDF=betta;
VA=(1+gammaa)/(1+gammaa-phi*SDF)*(markupss-1)/(markupss/mc)*y;
ZZRD=(1+gammaa-phi)/(probadopt*phi)+A;

J=(1-varsigma)*probadopt*phi*SDF/(1+gammaa-(1-probadopt+varsigma*probadopt)*phi*betta)*VA;

S=varsigma*probadopt*phi*SDF/(1+gammaa)*(VA-J);

%Srd=SDF*J*(ZZRD/A-phi*ZZRD/A*1/(1+gammaa));
Srd=0;
%shockchi=(1+gammaa-phi)/(Srd^alphaHA*Grd^alphaRD);
%shockchi=(1+gammaa-phi)/(Srd^alphaHA);
shockchi=1;



kappaprob=probadopt/((S)^varsigma);


Ns=(1-1/ZZRD)*S+Srd;

shockchiss=shockchi;

share_in_RD=(Srd+(ZZRD/A-1)*S)/y;
(ZZRD/A-1)*S/y
Ip_y=Ip/y;
%Ip_y=(1-(1-delta)/ZZ)*Kp_y;
Ip_y=(ZZ-(1-delta))*Kp_y;

Rss=R;
ydss=y;

yd=y;
Igi=Igiy*y;
Gc=Gcy*y;

C=yd-(Ip+Igi+Gc+Ige+Grd+Srd+(ZZRD/A-1)*S);
lambda=1/C/(1+tauc);

Cy=1-Ip_y-Igiy-Gcy-Igey-Grdy-(Srd+(ZZRD/A-1)*S)/yd;
x2=1/(1+tauc)*1/Cy/(1-betta*thetap);  % x2=lambda*y/(1-betta*thetap)= 1/(1+tauc)*y/c/(1-betta*thetap)
x1=mc*x2;

D=y*by;
Trans=D-((1-0*Delta_G)*(R/PI)*D/ZZ+Gc+Igi+Ige+Grd-tauw*W_real*N-tauc*C);
Gcss=Gcy*(y);
Igiss=Igiy*(y);

%Variables of interest
lnyd=log(yd)*100;
G=Gc+Igi+Ige+Grd;
pdef=(Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/y*100;
rreal=R/PI;
pdef_yss=(Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/ydss;
Trans_yss=Trans/ydss;
dserv_yss=(R-1)*D/ydss;
by_yss=D/ydss;
Igi_ys=Igi/ydss*100;
by_ann=by/4*100;
lnPI=log(PI)*100;



Lab=N;

%{
Lss=0.3
Ess=0.05
muySS=(1/betta-1+deltaH)/(Lss/Ess)/deltaH
%}

Lab_E_ratio=(1/betta-1+deltaH)/(gamma*deltaH);
E=Lab/Lab_E_ratio;
% Langangra of teh human capital equation
lambda_HC=lambda*W_real*(1-tauw)/(gamma*1/E*deltaH);

% Lab 
%Lab=lambda_HC*(1/betta-1+deltaH)/(lambda*(1-tauw)*W_real);
%deltaH=0.016
%
% Human capital
%H=N/Lab;
H=(N+0*Ns)/Lab;

% Adjustment parameter for N 
omega=lambda*W_real*(1-tauw)*H/(Lab+E)^varphi;

muyH=omega*(Lab+E)^varphi/(lambda_HC*gamma*E^(gamma-1)* (Kge)^mu);


ygrowth=log(ZZ)*100;
eGE=eGE_ss;
eGI=eGI_ss;

TFP=A^(vartheta-1)*(Kg^alphaG)*H^(1-alpha);
ln_Grd=log(Grd);
Grd_ydss_ratio=Grd/ydss;
Grdeff=(1-eGRD_ss)*Grd;

eGRD=eGRD_ss;
%A=1;