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

Kp_y=(1+Bigtheta_y)*alppha*mc/(markupss*rk);

yt_proxy=(kG_y^alphaG)*(Kp_y^alppha)*(N^(1-alppha));

yt=yt_proxy^(1/(1-alphaG-alppha));


W_real=(1-alppha)*mc*yt/N/markupss;


% Real wage
%W_real=(mc/((1/(1-alppha))^(1-alppha)*(1/alppha)^alppha*rk^alppha/(kG_y/(1+Bigtheta_y)*1/ZZ)^(alphaG/(1-alphaG))))^(1/(1-alppha));
%mc=(1/(1-alppha))^(1-alppha)*(1/alppha)^alppha*W_real^(1-alppha)*rk^alppha/(kG_y/(1+Bigtheta_y)*1/ZZ)^(alphaG/(1-alphaG));

%Kp=alppha/(1-alppha)*W_real/rk*ZZ*N;

% Private capital
Kp=alppha/(1-alppha)*W_real/rk*N;

% Private investment
Ip=Kp*(ZZ-(1-delta));

%Param_1=1/ZZ^(alphaG+alppha-alphaG*alppha)*(Kp^(alppha*(1-alphaG)))*(N^((1-alppha)*(1-alphaG)));
%yt=((Param_1*kG_y^alphaG)/(1+Bigtheta_y))^(1/(1-alphaG));

% Public capital
Kg=kG_y*yt;

% Fixed cost
Bigtheta=Bigtheta_y*yt;
%Bigtheta_test=1/ZZ^(alphaG+alppha-alphaG*alppha)*(Kg^alphaG)*(Kp^(alppha*(1-alphaG)))*(N^((1-alppha)*(1-alphaG)))-yt
%(Bigtheta_test-Bigtheta).^2

% NEW PATH
%kGe_y=effge*Igey/(1-(1-delta)/ZZ);
% Human capital
%kGe_y=effge*Igey/(ZZ-(1-delta));
kGe_y=(1-eGE_ss)*Igey/(ZZ-(1-delta));
Kge=kGe_y*yt;
Ige=Igey*yt;
Igess=Ige;
Grd=Grdy*yt;
Grdss=Grd;




% R&D path
%markupss=1.015;
AAt=1;
probadopt=probadoptss;
SDF=betta;
VA=(1+gammaa)/(1+gammaa-phiob*SDF)*(markupss-1)/(markupss/mc)*yt;
ZZRD=(1+gammaa-phiob)/(probadopt*phiob)+AAt;

JZt=(1-rhoSADOPT)*probadopt*phiob*SDF/(1+gammaa-(1-probadopt+rhoSADOPT*probadopt)*phiob*betta)*VA;

St=rhoSADOPT*probadopt*phiob*SDF/(1+gammaa)*(VA-JZt);

%SSt=SDF*JZt*(ZZRD/AAt-phiob*ZZRD/AAt*1/(1+gammaa));
SSt=0;
%shockchit=(1+gammaa-phiob)/(SSt^alphaHA*Grd^alphaRD);
%shockchit=(1+gammaa-phiob)/(SSt^alphaHA);
shockchit=1;



kappaprob=probadopt/((St)^rhoSADOPT);


Ns=(1-1/ZZRD)*St+SSt;

shockchitss=shockchit;

share_in_RD=(SSt+(ZZRD/AAt-1)*St)/yt;
(ZZRD/AAt-1)*St/yt
Ip_y=Ip/yt;
%Ip_y=(1-(1-delta)/ZZ)*Kp_y;
Ip_y=(ZZ-(1-delta))*Kp_y;

Rss=R;
ydss=yt;

yd=yt;
Igi=Igiy*yt;
Gc=Gcy*yt;

C=yd-(Ip+Igi+Gc+Ige+Grd+SSt+(ZZRD/AAt-1)*St);
lambda=1/C/(1+tauc);

Cy=1-Ip_y-Igiy-Gcy-Igey-Grdy-(SSt+(ZZRD/AAt-1)*St)/yd;
x2=1/(1+tauc)*1/Cy/(1-betta*thetap);  % x2=lambda*y/(1-betta*thetap)= 1/(1+tauc)*y/c/(1-betta*thetap)
x1=mc*x2;

Dt=yt*by;
Trans=Dt-((1-0*Delta_G)*(R/PI)*Dt/ZZ+Gc+Igi+Ige+Grd-tauw*W_real*N-tauc*C);
Gcss=Gcy*(yt);
Igiss=Igiy*(yt);

%Variables of interest
lnyd=log(yd)*100;
G=Gc+Igi+Ige+Grd;
pdef=(Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/yt*100;
rreal=R/PI;
pdef_yss=(Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/ydss;
Trans_yss=Trans/ydss;
dserv_yss=(R-1)*Dt/ydss;
by_yss=Dt/ydss;
Igi_ys=Igi/ydss*100;
by_ann=by/4*100;
lnPI=log(PI)*100;



Lab=N;

%{
Lss=0.3
Ess=0.05
muySS=(1/betta-1+deltaH)/(Lss/Ess)/deltaH
%}

Lab_E_ratio=(1/betta-1+deltaH)/(muy*deltaH);
E=Lab/Lab_E_ratio;
% Langangra of teh human capital equation
lambda_HC=lambda*W_real*(1-tauw)/(muy*1/E*deltaH);

% Lab 
%Lab=lambda_HC*(1/betta-1+deltaH)/(lambda*(1-tauw)*W_real);
%deltaH=0.016
%
% Human capital
%H=N/Lab;
H=(N+0*Ns)/Lab;

% Adjustment parameter for N 
omega=lambda*W_real*(1-tauw)*H/(Lab+E)^phi;

muyH=omega*(Lab+E)^phi/(lambda_HC*muy*E^(muy-1)* (Kge)^alphaH);


ygrowth=log(ZZ)*100;
eGE=eGE_ss;
eGI=eGI_ss;

TFP=AAt^(varthetaat-1)*(Kg^alphaG)*H^(1-alppha);
ln_Grd=log(Grd);
Grd_ydss_ratio=Grd/ydss;
Grdeff=(1-eGRD_ss)*Grd;

eGRD=eGRD_ss;
%AAt=1;