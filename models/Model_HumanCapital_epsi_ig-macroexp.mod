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
AAt             % staionary Tech Process
Cgrd            % R&D spending
Cgrdss          % R&D spending SS
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
epsi_cgrd       % Shock to R&D
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
;
betta=0.9985;    
phi= 1.2 ;       
chi =0.6;        
delta =0.025;    
thetap = 0.8;    
epsilon =10;     
alppha=0.3;      
Bigtheta=0;      
Bigtheta_y=0;
zeta=0.05;      
rho_R=0.7;      
gamma_pi=1.5;    
gamma_y=0.25;    
Piss=1;          
rho_RG=0;        
rho_tauc=0.9;  
taucss=0.20;    
gamma_y_tauc=0; 
gamma_d_tauc=0.0; 
rho_tauw=0.9;  
tauwss=0.25 ;   
gamma_y_tauw=0;  
gamma_d_tauw=0; 
byss=1*4;         
rho_ZZ= 0.24 ;    
ZZss=1.004;       
eta1=-18.12;      
eta2=3.12;
Deltacost=0;  % Shutting down the feedback of debt on rate
Igy=0.02;
Cgy=0.2;
rho_Cg=0.9;
rho_Ig=0.9;
gamma_d_trans=0.5;
rho_trans=0;
eff=0.8;
effge=0.8;
Cgey=0.03;
deltaH=0.025;   
muy=0.2;
alphaH=0.2;
rho_Cge=0.9;
%load param_need;  
alphaZZ1=0.2;
rhoeffge =0;
rhoeff =0;
rho_AAt=0.0;
alphaHA=0.05;
alphaRD=0.02;
Cgrdy=0.006;
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
//Marginal Utility
1/C=lambda*(1+tauc);
// Euler equation 
lambda=betta*(lambda(+1)/ZZ(+1)*R/PI(+1));
// Labor decision
omega*(Lab+E)^phi=lambda*W_real*H(-1)*(1-tauw);
// Law of motion of private capital
Kp=(1-delta)*Kp(-1)/ZZ+Ip;
// Return on investment- Choose private 
1=betta*(lambda(+1)/lambda/ZZ(+1)*(1-delta+rk(+1)));
//NEW PATH 
//Human capital of Household:  H=(1-delta)*H(-1)+E^muy (Kge/At)^alphaH; 
H=(1-deltaH)*H(-1)+muyH*E^muy*(Kge(-1)/ZZ)^alphaH; 
// Time for human capital build: E 
omega*(Lab+E)^phi=lambda_HC*muyH*muy*E^(muy-1)* (Kge(-1)/ZZ)^alphaH;
// Human capital 
lambda_HC=betta*(lambda(+1)*(1-tauw(+1))*W_real(+1)*Lab(+1)+lambda_HC(+1)*(1-deltaH));
//Effective labor
N=Lab*H(-1);
//********************************************************
// FIRMS DECISIONS-17
//********************************************************
// firm's price setting
g1=lambda*mc*yd+betta*thetap*(PI^chi/PI(+1))^(-epsilon)*g1(+1);
g2=lambda*PIstar*yd+betta*thetap*(PI^chi/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*g2(+1);
epsilon*g1=(epsilon-1)*g2;
// optimal inputs
Kp(-1)/N=alppha/(1-alppha)*W_real/rk*ZZ;
mc=(1/(1-alppha))^(1-alppha)*(1/alppha)^alppha*W_real^(1-alppha)*rk^alppha/(Kg(-1)/(yt+Bigtheta)*1/ZZ)^(zeta/(1-zeta))*1/AAt;
// law of motion prices
1=thetap*(PI(-1)^chi/PI)^(1-epsilon)+(1-thetap)*PIstar^(1-epsilon);
// Production
%yt=1/ZZ^(zeta+alppha-zeta*alppha)*(Kg(-1)^zeta)*(Kp(-1)^(alppha*(1-zeta)))*(N^((1-alppha)*(1-zeta)))-Bigtheta_y*STEADY_STATES(yt);
yt=AAt*1/ZZ^(zeta+alppha-zeta*alppha)*(Kg(-1)^zeta)*(Kp(-1)^(alppha*(1-zeta)))*((N)^((1-alppha)*(1-zeta)))-Bigtheta;
//Stationary tech process
log(AAt)=rho_AAt*log(AAt(-1))+alphaHA*log(H(-1)/STEADY_STATE(H))+alphaRD*log(Cgrd(-1)/Cgrdss);
//********************************************************
//Monetary Authority-2
//********************************************************
// Taylor rule
Rmp/Rss=(Rmp(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/yd(-1)*ZZ/ZZss)^gamma_y)^(1-rho_R)*exp(epsi_MP);
// Link between borrowing cost of goverment and policy rate
log(R)=rho_RG*R(-1)+ (1-rho_RG)*(log(Rmp) + Delta_G*(by(-1)-byss)) + epsi_spread;
Delta_G=prob_def*Deltacost;
prob_def=exp(eta1 + eta2*by(-1))/(1+exp(eta1 + eta2*by(-1)));
//********************************************************
//GOVERNMENT DECISIONS-7
//********************************************************
// Public capital
Kg=(1-delta)*Kg(-1)/ZZ+effshock*Ig;
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
Kge=(1-delta)*Kge(-1)/ZZ+effgeshock*Cge;
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
shocks;
    var epsi_ig;
periods 1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20 21:2000  ;
values 0.000500000000000000
0.00100000000000000
0.00150000000000000
0.00200000000000000
0.00250000000000000
0.00300000000000000
0.00350000000000000
0.00400000000000000
0.00450000000000000
0.00500000000000000
0.00550000000000000
0.00600000000000000
0.00650000000000000
0.00700000000000000
0.00750000000000000
0.00800000000000000
0.00850000000000000
0.00900000000000000
0.00950000000000000
0.0100000000000000
0.01;
end;
perfect_foresight_setup(periods=2000);%options_.debug
perfect_foresight_solver(maxit=20); %maxit=10 linear_approximation, endogenous_terminal_period
