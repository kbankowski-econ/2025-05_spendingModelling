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
E=0.05;


%eff=effss;
%effge=effgess;
% Marginal cost 
mc=(epsilon-1)/epsilon;

kG_y=eff*Igy/(1-(1-delta)/ZZ);

% Real wage
W_real=(mc/((1/(1-alppha))^(1-alppha)*(1/alppha)^alppha*rk^alppha/(kG_y/(1+Bigtheta_y)*1/ZZ)^(zeta/(1-zeta))))^(1/(1-alppha));

mc=(1/(1-alppha))^(1-alppha)*(1/alppha)^alppha*W_real^(1-alppha)*rk^alppha/(kG_y/(1+Bigtheta_y)*1/ZZ)^(zeta/(1-zeta));

Kp=alppha/(1-alppha)*W_real/rk*ZZ*N;

Ip=Kp*(1-(1-delta)/ZZ);

Param_1=1/ZZ^(zeta+alppha-zeta*alppha)*(Kp^(alppha*(1-zeta)))*(N^((1-alppha)*(1-zeta)));

yt=((Param_1*kG_y^zeta)/(1+Bigtheta_y))^(1/(1-zeta));

Kg=kG_y*yt;

Bigtheta=Bigtheta_y*yt;
%Bigtheta_test=1/ZZ^(zeta+alppha-zeta*alppha)*(Kg^zeta)*(Kp^(alppha*(1-zeta)))*(N^((1-alppha)*(1-zeta)))-yt
%(Bigtheta_test-Bigtheta).^2

% NEW PATH
kGe_y=effge*Cgey/(1-(1-delta)/ZZ);
Kge=kGe_y*yt;
Cge=Cgey*yt;
Cgess=Cge;


Ip_y=Ip/yt;
Kp_y=(1+Bigtheta_y)*ZZ*alppha*mc/rk;
Ip_y=(1-(1-delta)/ZZ)*Kp_y;
Rss=R;
ydss=yt;

yd=yt;
Ig=Igy*yt;
Cg=Cgy*yt;
Cgrd=Cgrdy*yt;
Cgrdss=Cgrd;
C=yd-(Ip+Ig+Cg+Cge+Cgrd);
lambda=1/C/(1+tauc);

Cy=1-Ip_y-Igy-Cgy-Cgey-Cgrdy;
g2=1/(1+tauc)*1/Cy/(1-betta*thetap);  % g2=lambda*y/(1-betta*thetap)= 1/(1+tauc)*y/c/(1-betta*thetap)
g1=mc*g2;

Bt=yt*by;
Trans=Bt-((1-0*Delta_G)*(R/PI)*Bt/ZZ+Cg+Ig+Cge+Cgrd-tauw*W_real*N-tauc*C);
Cgss=Cgy*(yt);
Igss=Igy*(yt);

%Variables of interest
lnyd=log(yd)*100;
pdef=(Cg+Ig+Cge+Cgrd+Trans-tauw*W_real*N-tauc*C)/yt*100;
Ig_ys=Ig/ydss*100;
by_ann=by/4*100;
lnPI=log(PI)*100;



% Langangra of teh human capital equation
lambda_HC=lambda*W_real*(1-tauw)/(muy*1/E*deltaH);

% Lab 
Lab=lambda_HC*(1/betta-1+deltaH)/(lambda*(1-tauw)*W_real);

% Human capital
H=N/Lab;

% Adjustment parameter for N 
omega=lambda*W_real*(1-tauw)*H/(Lab+E)^phi;

muyH=omega*(Lab+E)^phi/(lambda_HC*muy*E^(muy-1)* (Kge/ZZ)^alphaH);


ygrowth=log(ZZ)*100;
effgeshock=effge;
effshock=eff;
AAt=1;