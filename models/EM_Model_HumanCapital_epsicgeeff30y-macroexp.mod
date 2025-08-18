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
TFP             % TFP
Cgrd_ydss_ratio
ln_Cgrd
Cgrdeff
effcgrdshock
;
%-----------------------------
% Define exogenous variables
%-----------------------------
varexo
epsi_cg         % Shock to government consumption
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
epsirhoadopt
epsi_effcgrd
epsiallo_ig        % shock to elasticity wrt public infrastructure capital
epsiallo_cge       % Shock to elasticity wrt public human capital 
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
rho_Cgrd
rho_ZZRD
eff_cgrd
;
% Include EM parameters
betta=0.9985;    
phi= 1.2 ;       
chi =0.6;        
delta =0.025;    
thetap = 0.8;    
epsilon =10;     
alppha=0.3;      
Bigtheta=0;      
Bigtheta_y=0;
zeta=0.2;      
rho_R=0.7;      
gamma_pi=1.5;    
gamma_y=0.25;    
Piss=1;          
rho_RG=0;        
rho_tauc=0.9;  
taucss=0.15;    
gamma_y_tauc=0; 
gamma_d_tauc=0.0; 
rho_tauw=0.9;  
tauwss=0.10 ;   
gamma_y_tauw=0;  
gamma_d_tauw=0; 
byss=0.6*4;         
rho_ZZ= 0.24 ;    
ZZss=1.0075;       
eta1=-18.12;      
eta2=3.12;
Deltacost=0;  % Shutting down the feedback of debt on rate
rho_Cg=0.9;
rho_Ig=0.9;
gamma_d_trans=0.5;
rho_trans=0;
eff=0.8;
effge=0.8;
eff_cgrd=0.8;
deltaH=0.025;   
muy=0.5;
rho_Cge=0.9;
%load param_need;  
alphaZZ1=0.2;
rhoeffge =0;
rhoeff =0;
rho_AAt=0.0;
%alphaHA=0.1;
alphaHA=0;
alphaRD=0.001;
Cgrdy=0.001;
Igy=0.05;
Cgy=0.14;
Cgey=0.02;
alphaH=0.25;
rho_Cgrd=0;
markupss=1.18;
phiob=1-0.08/4;   % obsolescence rate: 0.08/4
varthetaat=1.35;
gammaa=ZZss^((1-alppha)/(varthetaat-1))-1;
probadoptss=0.2/4;
rhoSADOPT=0.1;
alphaSRD=0;
rhoshockchit=1;
rho_ZZRD=0.79;
alphaRD=0;
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
H=(1-deltaH)*H(-1)+muyH*E^muy*(Kge(-1))^(alphaH*(1+epsiallo_cge)); 
// Time for human capital build: E 
%omega*(Lab+E)^phi=lambda_HC*muyH*muy*E^(muy-1)* (Kge(-1)/ZZ)^alphaH;
omega*(Lab+E)^phi=lambda_HC*muyH*muy*E^(muy-1)* (Kge(-1))^(alphaH*(1+epsiallo_cge));
// Human capital 
lambda_HC=betta*(lambda(+1)*(1-tauw(+1))*W_real(+1)*Lab(+1)+lambda_HC(+1)*(1-deltaH));
//Effective labor
%N+Ns=Lab*H(-1);
N=Lab*H(-1);
// Effective labor in the R&D
%Ns=(1-AAt(-1)/ZZRD(-1))*SAt+SSt;
Ns=STEADY_STATE(Ns);
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
yt=AAt(-1)^(varthetaat-1)*(Kg(-1)^(zeta*(1+epsiallo_ig)))*(Kp(-1)^alppha)*(N^(1-alppha))-Bigtheta;
TFP=AAt(-1)^(varthetaat-1)*(Kg(-1)^(zeta*(1+epsiallo_ig)))*H(-1)^(1-alppha);
//Stationary tech process
%log(AAt)=rho_AAt*log(AAt(-1))+alphaHA*log(H(-1)/STEADY_STATE(H))+alphaRD*log(Cgrd(-1)/Cgrdss);
/*
% Ideas development 
(1+gammaa)*ZZRD=(shockchit*Cgrd^alphaRD)*ZZRD(-1)*SSt^alphaSRD+phiob*ZZRD(-1); 
% How much labor to use in research
SDF(+1)*JZt(+1)*(ZZRD/AAt-phiob*ZZRD(-1)/AAt/(1+gammaa))=SSt ;
% How much labor to use in adoption
JZt=-SAt+phiob*(SDF(+1)*AAt(-1)/AAt*1/(1+gammaa)*(probadopt*VA(+1)+(1-probadopt)*JZt(+1)));
% Probability of Adoption
probadopt=kappaprob*(SAt)^rhoSADOPT;
% Adoption 
(1+gammaa)*AAt=probadopt*phiob*(ZZRD(-1)-AAt(-1))+phiob*AAt(-1);
% Value of Adoption
VA=(markupss-1)/(markupss)*mc*yt + phiob*SDF(+1)*VA(+1)*AAt(-1)/AAt/(1+gammaa);
%% FOC adoption
rhoSADOPT*probadopt*phiob*SDF(+1)/(1+gammaa)*AAt(-1)/AAt*(VA(+1)-JZt(+1))=SAt;
*/
%(1+gammaa)*ZZRD=(shockchit)*ZZRD(-1)*SSt^alphaSRD+phiob*ZZRD(-1);
ln(ZZRD/STEADY_STATE(ZZRD))=rho_ZZRD*ln(ZZRD(-1)/STEADY_STATE(ZZRD))+alphaRD*1/(1+0*(eff_cgrd-effcgrdshock))*ln(Cgrdeff(-1)/STEADY_STATE(Cgrdeff))+alphaSRD*ln(H(-1)/STEADY_STATE(H))+log(shockchit);
SSt=STEADY_STATE(SSt);
% ADDED JUly September
Cgrdeff=effcgrdshock*Cgrd;
% OLD; How much labor to use in research
%SDF(+1)*JZt(+1)*shockchit*ZZRD(-1)/AAt/(1+gammaa)*SSt^(alphaSRD-1)*Cgrd^alphaRD=1 ;
%SDF(+1)*JZt(+1)*(shockchit)*ZZRD(-1)/AAt/(1+gammaa)=SSt^(1-alphaSRD);
JZt=-SAt+phiob*(SDF(+1)*AAt(-1)/AAt*1/(1+gammaa)*(probadopt*VA(+1)+(1-probadopt)*JZt(+1)));
probadopt=(kappaprob+epsirhoadopt)*(SAt)^(rhoSADOPT);
(1+gammaa)*AAt=probadopt*phiob*(ZZRD(-1)-AAt(-1))+phiob*AAt(-1);
VA=(markupss-1)/(markupss)*mc*yt + phiob*SDF(+1)*VA(+1)*AAt(-1)/AAt/(1+gammaa);
rhoSADOPT*probadopt*phiob*SDF(+1)/(1+gammaa)*AAt(-1)/AAt*(VA(+1)-JZt(+1))=SAt;
/*
ZZRD=STEADY_STATE(ZZRD);
SSt=STEADY_STATE(SSt);
JZt=STEADY_STATE(JZt);
probadopt=STEADY_STATE(probadopt);
(1+gammaa)*AAt=probadopt*phiob*(ZZRD(-1)-AAt(-1))+phiob*AAt(-1);
VA=STEADY_STATE(VA);
SAt=STEADY_STATE(SAt);
*/
%  Stochastic Discount factor (After detrend)
SDF=betta*lambda*(1+tauc)/(lambda(-1)*(1+tauc(-1)));
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
Cg-Cgss=-(Ig-Igss+Cge-Cgess+Cgrd-Cgrdss)+ydss*epsi_cg;
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
%Kge=0*Kge(-1)+effgeshock*Cge;
// Gov Consumption dynamics
%log(Cge/Cgess)=rho_Cge*log(Cge(-1)/Cgess)+epsi_cge;
Cge=Cgess+ydss*epsi_cge;
// R&D Spending
Cgrd-Cgrdss=rho_Cgrd*(Cgrd(-1)-Cgrdss)+ydss*epsi_cgrd;
ln_Cgrd=log(Cgrd);
Cgrd_ydss_ratio=Cgrd/ydss;
//********************************************************
//MARKET CLEARING-3
//********************************************************
// Aggregate Demand
%yd=C+Ip+Ig+Cg+Cge+Cgrd;
yd=C+Ip+Ig+Cg+Cge+Cgrd+SSt+(ZZRD(-1)/AAt(-1)-1)*SAt;
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
effcgrdshock-eff_cgrd=0*(effcgrdshock(-1)-eff_cgrd)+epsi_effcgrd;
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
shocks;
var epsi_cge;
periods 1:1000  ;
values 
0.01;
var epsi_effge;
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121:1000 ;
values
    0.00266667
    0.00533333
    0.008
    0.0106667
    0.0133333
    0.016
    0.0186667
    0.0213333
    0.024
    0.0266667
    0.0293333
    0.032
    0.0346667
    0.0373333
    0.04
    0.0426667
    0.0453333
    0.048
    0.0506667
    0.0533333
    0.056
    0.0586667
    0.0613333
    0.064
    0.0666667
    0.0693333
    0.072
    0.0746667
    0.0773333
    0.08
    0.0826667
    0.0853333
    0.088
    0.0906667
    0.0933333
    0.096
    0.0986667
    0.101333
    0.104
    0.106667
    0.109333
    0.112
    0.114667
    0.117333
    0.12
    0.122667
    0.125333
    0.128
    0.130667
    0.133333
    0.136
    0.138667
    0.141333
    0.144
    0.146667
    0.149333
    0.152
    0.154667
    0.157333
    0.16
    0.162667
    0.165333
    0.168
    0.170667
    0.173333
    0.176
    0.178667
    0.181333
    0.184
    0.186667
    0.189333
    0.192
    0.194667
    0.197333
    0.2
    0.202667
    0.205333
    0.208
    0.210667
    0.213333
    0.216
    0.218667
    0.221333
    0.224
    0.226667
    0.229333
    0.232
    0.234667
    0.237333
    0.24
    0.242667
    0.245333
    0.248
    0.250667
    0.253333
    0.256
    0.258667
    0.261333
    0.264
    0.266667
    0.269333
    0.272
    0.274667
    0.277333
    0.28
    0.282667
    0.285333
    0.288
    0.290667
    0.293333
    0.296
    0.298667
    0.301333
    0.304
    0.306667
    0.309333
    0.312
    0.314667
    0.317333
    0.32
    0.32
;
end;
perfect_foresight_setup(periods=2000);%options_.debug
perfect_foresight_solver(maxit=20); %maxit=10 linear_approximation, endogenous_terminal_period
fiscalchange=Ig-Igss+Cge-Cgess+Cgrd-Cgrdss;
ped=1*4;
multiplier_1y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=5*4;
multiplier_5y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=10*4;
multiplier_10y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=20*4;
multiplier_20y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=25*4;
multiplier_25y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
/*
num=[1:20]
v1=[0:1/20:1]
v2=v1(2:end)'/100;
*/
