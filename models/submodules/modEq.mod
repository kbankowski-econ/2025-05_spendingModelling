% ANH NGUYEN (FAD FP)
% This model is a standard macro-fiscal model
% A representative HH 
% Public expenditure: public consumption, pubic investment
% Public revenue: consumption tax, income tax, lump-sum transfer
% Price stickiness
% Public investment is modelled as in Drautzburg and Uhlig (2015)


% June 23: 
% revise the debt equation: R(-1)/PI
% revise the gov expenditure equation in terms of GDP
% revsie the transfer adjustment equation

var 
C               % HH consumption
lambda          % Marginal Utility
R               % Interest rate on bond
PI              % Gross inflation
N               % (Effective) Labor supply
W_real          % Real wages
Ip              % Private investment
Kp              % Private capital
rk              % Return on private investment
g1              % Price setting 1
g2              % Price setting 2
mc              % Marginal cost
PIstar          % Optimnal gross inflation 
yt              % Production
Kg              % Public capital
Rmp             % Policy rate
Bt              % Debt level
by              % Debt/GDP
Ig              % Public investment
Cg              % Public consumption
tauc            % Consumption tax
tauw            % Income tax
yd              % Aggregate demand
vp              % Price dispersion
ZZ              % Gross growth rate
%shock_ZZ        % shock to the ZZ process  
Delta_G         % Expected loss 
prob_def        % probability of default
omega           % Scaling
Igss            % Steady state of Investment
Cgss            % Steady state of Consumption
Rss             % Steady state interest rate   
ydss            % Steady state output
Trans           % Transfer
lnyd            % Log of Output
pdef            % Primary Deficit 
Ig_ys           % Public Investment as percent of GDP
by_ann          % Debt to GDP 
lnPI            % Log of Prince index

H               % Human capital
Kge             % Public Human-related Capital Stock (HCS)
Cge             % Public spending in public humand-related capital stock
E               % Time for schooling and taking care of health (building capital)
lambda_HC        % Lagrangian of the Human capital formation
Cgess           % Steady state of public spending on Public human-capital related stock
Lab             % Labor supply 
muyH            % Adjuster so that E=0.1
ygrowth          % econonmic growth
effgeshock
effshock
AAt             % Aoption Tech Process
Cgrd            % R&D spending
Cgrdss          % R&D spending SS
shockchit       % R&D process productivity shock SS
SDF             % Stochastic discount factor
SAt             % Effective labor demand for tech adoption
VA              % Value of tech adoption
probadopt       % Probability of adoption
JZt             % Value of unadopted Intermediate
SSt             % Effective labor demand for R&D development
ZZRD            % R&D product
kappaprob       % Parameter in the probability for scaling
shockchitss     %% SS of shockchit 
Ns              % Labor in R&D
;

%-----------------------------
% Define exogenous variables
%-----------------------------
varexo
%epsi_cg         % Shock to government consumption
epsi_ig         % Shock to government investment  
epsi_ZZ         % Shock to trend
epsi_spread     % Shock to Spread
epsi_MP         % Monetary Policy Shocks
epsi_tauc       % Consumption income tax shock 
epsi_tauw       % Labor income tax shock
epsi_cge        % Public HC spending shock
epsi_effge  
epsi_eff
epsi_cgrd       % Shock to R&D spending
epsi_shockchit  % Shock to the R&D process 
;

%--------------------------
% Define parameters
%--------------------------
parameters 
betta           % Discount value
phi             % Frisch parameter
chi             % indexation
delta           % depreciationf
thetap          % firsm cant change the price
epsilon         % elasticity of substitution 
alppha          % share of capital in intermediate firms production
Bigtheta        % Fixed cost
Bigtheta_y      % Fixed cost to GDP
zeta            % Share of public capital in teh production
rho_R           % Persistence of policy rate
gamma_pi        % Reponse of MP to inflation
gamma_y         % Reponse of MP to OG
Piss            % SS of gross inflation
rho_RG          % Persistence of goverment bond rate capturing the maturity (1/(1-rho_RG)) s the average maturity
rho_tauc        % AR(1) of consumption tax rate
taucss          % Consumption tax rate SS
gamma_y_tauc    % Response of consumption tax to OG
gamma_d_tauc    % Response of consumption tax to debt
rho_tauw        % AR(1) of income tax rate
tauwss          % Income tax rate SS
gamma_y_tauw    % Response of consumption tax to OG
gamma_d_tauw    % Response of consumption tax to debt
byss            % Steady state of debt
rho_ZZ          % AR(1) of growth shock 
ZZss            % SS of growth
eta1            % Prof default param 1
eta2            % Prof default param 2 
Deltacost       % Feed back of debt on rate
Igy             % Public investment/GDP
Cgy             % Public consumption/GDP
rho_Cg          % AR(1) process for public consumption
rho_Ig          % AR(1) process for public investment  
gamma_d_trans   % Response of lump sum transfer to debt
rho_trans
eff            % Efficiency of public investment
deltaH          % Depreciation of Labor
muy             % Effectiveness of education investment.
alphaH          % Elasticity of Human Capital Formation w.r.t. Public Human-related Capital (HRC)
effge           % Efficiency of public HRC 
Cgey            % Share of goevrnment expenditure to human capital
alphaZZ1        % Learning by doing off HHon ZZ
rho_Cge         % Persistence of human-related spending
rhoeffge
rhoeff
rho_AAt         % Persistence of staionary tech process
alphaHA         % feed back of Human cpital to TFP
alphaRD         % R&D on TFP
Cgrdy           % share of expenditure for R&D
markupss        % SS markup of Intermediate goods 
phiob           % obsolescence rate: 0.08/4
varthetaat      % Intermediate goods elasticity of substitution
gammaa         % Gorwth of tech
probadoptss    % Probability of adoption
rhoSADOPT      % Adoption elasticity
alphaSRD       % R&D elasticity
rhoshockchit    % AR (1) or shock to r&D 
;


@#include "AE_parameters.macro"

model;

//********************************************************
//HOUSEHOLD DECISIONS-10
//********************************************************
omega=STEADY_STATE(omega);
Cgss=Cgy*STEADY_STATE(yt);
Igss=Igy*STEADY_STATE(yt);
Cgess=Cgey*STEADY_STATE(yt);
Cgrdss=Cgrdy*STEADY_STATE(yt);
Rss=STEADY_STATE(R);
ydss=STEADY_STATE(yd);
muyH=STEADY_STATE(muyH);
% Exogenous disturbance to teh R&D Tech
shockchitss=STEADY_STATE(shockchit);
kappaprob=STEADY_STATE(kappaprob);

//Marginal Utility
1/C=lambda*(1+tauc);

// Euler equation 
lambda=betta*(lambda(+1)/ZZ(+1)*R/PI(+1));

// Labor decision
omega*(Lab+E)^phi=lambda*W_real*H(-1)*(1-tauw);

// Law of motion of private capital
%Kp=(1-delta)*Kp(-1)/ZZ+Ip;
Kp*ZZ=(1-delta)*Kp(-1)+Ip;

// Return on investment- Choose private 
1=betta*(lambda(+1)/lambda/ZZ(+1)*(1-delta+rk(+1)));

//NEW PATH 

//Human capital of Household:  H=(1-delta)*H(-1)+E^muy (Kge/At)^alphaH; 
%H=(1-deltaH)*H(-1)+muyH*E^muy*(Kge(-1)/ZZ)^alphaH; 
H=(1-deltaH)*H(-1)+muyH*E^muy*(Kge(-1))^alphaH; 

// Time for human capital build: E 
%omega*(Lab+E)^phi=lambda_HC*muyH*muy*E^(muy-1)* (Kge(-1)/ZZ)^alphaH;
omega*(Lab+E)^phi=lambda_HC*muyH*muy*E^(muy-1)* (Kge(-1))^alphaH;

// Human capital 
lambda_HC=betta*(lambda(+1)*(1-tauw(+1))*W_real(+1)*Lab(+1)+lambda_HC(+1)*(1-deltaH));

//Effective labor
N+Ns=Lab*H(-1);

// Effective labor in the R&D
Ns=(1-AAt(-1)/ZZRD(-1))*SAt+SSt;


//********************************************************
// FIRMS DECISIONS-17
//********************************************************
// firm's price setting
g1=lambda*mc*yd+betta*thetap*(PI^chi/PI(+1))^(-epsilon)*g1(+1);
g2=lambda*PIstar*yd+betta*thetap*(PI^chi/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*g2(+1);
epsilon*g1=(epsilon-1)*g2;

// optimal inputs
%Kp(-1)/N=alppha/(1-alppha)*W_real/rk*ZZ;
Kp(-1)/N=alppha/(1-alppha)*W_real/rk;


//Marginal cost
%mc=(1/(1-alppha))^(1-alppha)*(1/alppha)^alppha*W_real^(1-alppha)*rk^alppha/(Kg(-1)/(yt+Bigtheta)*1/ZZ)^(zeta/(1-zeta))*1/AAt;
(1-alppha)*mc*yt/N=markupss*W_real; 

// law of motion prices
1=thetap*(PI(-1)^chi/PI)^(1-epsilon)+(1-thetap)*PIstar^(1-epsilon);

// Production
%yt=1/ZZ^(zeta+alppha-zeta*alppha)*(Kg(-1)^zeta)*(Kp(-1)^(alppha*(1-zeta)))*(N^((1-alppha)*(1-zeta)))-Bigtheta_y*STEADY_STATES(yt);
%yt=AAt*1/ZZ^(zeta+alppha-zeta*alppha)*(Kg(-1)^zeta)*(Kp(-1)^(alppha*(1-zeta)))*((N)^((1-alppha)*(1-zeta)))-Bigtheta;

yt=AAt(-1)^(varthetaat-1)*(Kg(-1)^zeta)*(Kp(-1)^alppha)*(N^(1-alppha))-Bigtheta;

//Stationary tech process
%log(AAt)=rho_AAt*log(AAt(-1))+alphaHA*log(H(-1)/STEADY_STATE(H))+alphaRD*log(Cgrd(-1)/Cgrdss);


% Ideas development 
(1+gammaa)*ZZRD=shockchit*ZZRD(-1)*SSt^alphaSRD*Cgrd^alphaRD+phiob*ZZRD(-1); 

% How much labor to use in research
SDF(+1)*JZt(+1)*shockchit*ZZRD(-1)/ZZRD/(1+gammaa)*SSt^(alphaSRD-1)*Cgrd^alphaRD=W_real ;

% How much labor to use in adoption
JZt=-SAt*W_real+phiob*(SDF(+1)/(1+gammaa)*(probadopt*VA(+1)*ZZRD(-1)/AAt+(1-probadopt)*JZt(+1)*ZZRD(-1)/ZZRD));

% Probability of Adoption
probadopt=kappaprob*(SAt)^rhoSADOPT;

% Adoption 
(1+gammaa)*AAt=probadopt*phiob*(ZZRD(-1)-AAt(-1))+phiob*AAt(-1);

% Value of Adoption
VA=(markupss-1)/(markupss)*mc*yt + phiob*SDF(+1)*VA(+1)*AAt(-1)/AAt/(1+gammaa);

%% FOC adoption
rhoSADOPT*probadopt*phiob*SDF(+1)/(1+gammaa)*(VA(+1)*ZZRD(-1)/AAt-JZt(+1)*AAt/AAt(-1))=SAt*W_real;

%  Stochastic Discount factor (After detrend)
SDF=betta*lambda/(lambda(-1));


% Shock to the R&D
log(shockchit)=(1-rhoshockchit)*log(shockchitss)+rhoshockchit*log(shockchit(-1))+epsi_shockchit;




//********************************************************
//Monetary Authority-2
//********************************************************
// Taylor rule
%Rmp/Rss=(Rmp(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/yd(-1)*ZZ/ZZss)^gamma_y)^(1-rho_R)*exp(epsi_MP);
Rmp/Rss=(Rmp(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/ydss)^gamma_y)^(1-rho_R)*exp(epsi_MP);

// Link between borrowing cost of goverment and policy rate
log(R)=rho_RG*R(-1)+ (1-rho_RG)*(log(Rmp) + Delta_G*(by(-1)-byss)) + epsi_spread;

Delta_G=prob_def*Deltacost;
prob_def=exp(eta1 + eta2*by(-1))/(1+exp(eta1 + eta2*by(-1)));

//********************************************************
//GOVERNMENT DECISIONS-7
//********************************************************
// Public capital
%Kg=(1-delta)*Kg(-1)/ZZ+effshock*Ig;
Kg*ZZ=(1-delta)*Kg(-1)+effshock*Ig;

//Debt equation
%Bt=(R/PI(+1))*Bt(-1)/ZZ+Cg+Ig+Trans-tauw*W_real*N-tauc*C;
Bt=(R(-1)/PI)*Bt(-1)/ZZ+Cg+Ig+Cge+Cgrd+Trans-tauw*W_real*N-tauc*C;

//Lump-sum Transfer 
%Trans-STEADY_STATE(Trans)=rho_trans*(Trans(-1)-STEADY_STATE(Trans))+(1-rho_trans)*(gamma_d_trans*(by(-1)-byss)); 
Trans-STEADY_STATE(Trans)=rho_trans*(Trans(-1)-STEADY_STATE(Trans))+(1-rho_trans)*(-gamma_d_trans*(by(-1)-byss)*ydss); 

// Debt to GDP
by=Bt/yt;

// Gov Investment dynamics
%log(Ig/Igss)=rho_Ig*log(Ig(-1)/Igss)+epsi_ig;
Ig=Igss+ydss*epsi_ig;

// Gov Consumption dynamics
%log(Cg/Cgss)=rho_Cg*log(Cg(-1)/Cgss)+epsi_cg;
Cg-Cgss=-(Ig-Igss+Cge-Cgess+Cgrd-Cgrdss);


// Consumption tax
%tauc-taucss=rho_tauc*(tauc(-1)-taucss)+(1-rho_tauc)*(gamma_y_tauc*log(yd/ydss)+gamma_d_tauc*(by-byss));
tauc-taucss=rho_tauc*(tauc(-1)-taucss)+(1-rho_tauc)*(gamma_d_tauc*(by(-1)-byss))+epsi_tauc;

// Income tax 
%tauw-tauwss=rho_tauw*(tauw(-1)-tauwss)+(1-rho_tauw)*(gamma_y_tauw*log(yd/ydss)+gamma_d_tauw*(by(-1)-byss))+epsi_tauw;
%(tauw-tauwss)*W_real*N/yt=gamma_d_tauw*(by(-1)-byss)+epsi_tauw;
tauw-tauwss=rho_tauw*(tauw(-1)-tauwss)+(1-rho_tauw)*(gamma_d_tauw*(by(-1)-byss))+epsi_tauw;


//Public Human-related capital stock
%Kge=(1-delta)*Kge(-1)/ZZ+effgeshock*Cge;
Kge*ZZ=(1-delta)*Kge(-1)+effgeshock*Cge;

// Gov Consumption dynamics
%log(Cge/Cgess)=rho_Cge*log(Cge(-1)/Cgess)+epsi_cge;
Cge=Cgess+ydss*epsi_cge;

// R&D Spending
Cgrd=Cgrdss+ydss*epsi_cgrd;

//********************************************************
//MARKET CLEARING-3
//********************************************************
// Aggregate Demand
yd=C+Ip+Ig+Cg+Cge+Cgrd;

//Aggregate production
yt=vp*yd;

//Price dispersion
vp=thetap*(PI(-1)^chi/PI)^(-epsilon)*vp(-1)+(1-thetap)*PIstar^(-epsilon);

//********************************************************
//Shock dynamic-2
//********************************************************
log(ZZ)=(1-rho_ZZ)*log(ZZ(-1))+rho_ZZ*(log(ZZss))+epsi_ZZ;
%ZZ=ZZ(-1)^(1-rho_ZZ)* (ZZss H^alphaZZ)^rho_ZZ


%Efficiency of human-related spending
effgeshock-effge=rhoeffge*(effgeshock(-1)-effge)+epsi_effge;

%Efficiency of infrastructure spending
effshock-eff=rhoeff*(effshock(-1)-eff)+epsi_eff;

//********************************************************
//Variables of interest

//********************************************************
lnyd=log(yd)*100;
pdef=(Cg+Ig+Cge+Cgrd+Trans-tauw*W_real*N-tauc*C)/yt*100;
Ig_ys=Ig/ydss*100;
by_ann=by/4*100;
lnPI=log(PI)*100;

% Output growth
ygrowth=log(yd/yd(-1))*100+log(ZZ)*100; 

end;


steady;
check;