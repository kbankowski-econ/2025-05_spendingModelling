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
x1              % Price setting 1
x2              % Price setting 2
mc              % Marginal cost
PIstar          % Optimnal gross inflation 
y              % Production
Kg              % Public capital
Rmp             % Policy rate
D              % Debt level
by              % Debt/GDP
Igi              % Public investment
Gc              % Public consumption
tauc            % Consumption tax
tauw            % Income tax
yd              % Aggregate demand
vp              % Price dispersion
ZZ              % Gross growth rate
%shock_ZZ        % shock to the ZZ process  
Delta_G         % Expected loss 
prob_def        % probability of default
omega           % Scaling
Igiss            % Steady state of Investment
Gcss            % Steady state of Consumption
Rss             % Steady state interest rate   
ydss            % Steady state output
Trans           % Transfer
lnyd            % Log of Output
G               % Total government spending (Gc+Igi+Ige+Grd)
pdef            % Primary Deficit
rreal           % Ex-post real interest rate (R/PI)
pdef_yss        % Primary deficit, share of steady-state GDP
Trans_yss       % Transfers, share of steady-state GDP
dserv_yss       % Debt service (interest), share of steady-state GDP
by_yss          % Government debt, share of steady-state GDP
Igi_ys           % Public Investment as percent of GDP
by_ann          % Debt to GDP
lnPI            % Log of Prince index
H               % Human capital
Kge             % Public Human-related Capital Stock (HCS)
Ige             % Public spending in public humand-related capital stock
E               % Time for schooling and taking care of health (building capital)
lambda_HC        % Lagrangian of the Human capital formation
Igess           % Steady state of public spending on Public human-capital related stock
Lab             % Labor supply 
muyH            % Adjuster so that E=0.1
ygrowth          % econonmic growth
eGE             % Gap in public human-capital efficiency (e^GE)
eGI             % Gap in public infrastructure efficiency (e^GI)
A             % Aoption Tech Process
Grd            % R&D spending
Grdss          % R&D spending SS
shockchi       % R&D process productivity shock SS
SDF             % Stochastic discount factor
S             % Effective labor demand for tech adoption
VA              % Value of tech adoption
probadopt       % Probability of adoption
J             % Value of unadopted Intermediate
Srd             % Effective labor demand for R&D development
ZZRD            % R&D product
kappaprob       % Parameter in the probability for scaling
shockchiss     %% SS of shockchi 
Ns              % Labor in R&D
TFP             % TFP
Grd_ydss_ratio
ln_Grd
Grdeff
eGRD            % Gap in public R&D efficiency (e^GRD)
;
%-----------------------------
% Define exogenous variables
%-----------------------------
varexo
epsi_gc         % Shock to government consumption
epsi_igi         % Shock to government investment  
epsi_ZZ         % Shock to trend
epsi_spread     % Shock to Spread
epsi_MP         % Monetary Policy Shocks
epsi_tauc       % Consumption income tax shock 
epsi_tauw       % Labor income tax shock
epsi_ige        % Public HC spending shock
epsi_effge  
epsi_eff
epsi_grd       % Shock to R&D spending
epsi_shockchi  % Shock to the R&D process 
epsirhoadopt
epsi_effcgrd
epsiallo_ig        % shock to elasticity wrt public infrastructure capital
epsiallo_ige       % Shock to elasticity wrt public human capital 
;
%--------------------------
% Define parameters
%--------------------------
parameters 
betta           % Discount value
varphi             % Frisch parameter
chi             % indexation
delta           % depreciationf
thetap          % firsm cant change the price
epsilon         % elasticity of substitution 
alpha          % share of capital in intermediate firms production
Bigtheta        % Fixed cost
Bigtheta_y      % Fixed cost to GDP
alphaG          % Share of public capital in the production (paper alpha_G)
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
Igiy             % Public investment/GDP
Gcy             % Public consumption/GDP
rho_Gc          % AR(1) process for public consumption
rho_Igi          % AR(1) process for public investment  
gamma_d_trans   % Response of lump sum transfer to debt
rho_trans
eGI_ss          % SS gap in public infrastructure efficiency (e^GI)
deltaH          % Depreciation of Labor
gamma             % Effectiveness of education investment.
mu          % Elasticity of Human Capital Formation w.r.t. Public Human-related Capital (HRC)
eGE_ss          % SS gap in public human-capital efficiency (e^GE)
Igey            % Share of goevrnment expenditure to human capital
alphaZZ1        % Learning by doing off HHon ZZ
rho_Ige         % Persistence of human-related spending
alphaRD         % R&D on TFP
Grdy           % share of expenditure for R&D
markupss        % SS markup of Intermediate goods 
phi           % obsolescence rate: 0.08/4
vartheta      % Intermediate goods elasticity of substitution
gammaa         % Gorwth of tech
probadoptss    % Probability of adoption
varsigma      % Adoption elasticity
alphaHA        % HC elasticity in tech creation (paper alpha_HA)
rhoshockchi    % AR (1) or shock to r&D
rho_ZZRD
eGRD_ss         % SS gap in public R&D efficiency (e^GRD)
;
betta=0.9985;
varphi= 5 ;   % inverse Frisch elasticity (Frisch 0.2), as in Gali (2015, Ch. 3); was 1.2
chi =0.6;
delta =0.025;
thetap = 0.8;
epsilon =10;
alpha=0.3;
Bigtheta=0;
Bigtheta_y=0;
rho_R=0.7;
gamma_pi=1.5;
gamma_y=0.25;
Piss=1;
rho_RG=0;
rho_tauc=0.9;
gamma_y_tauc=0;
gamma_d_tauc=0.0;
rho_tauw=0.9;
gamma_y_tauw=0;
gamma_d_tauw=0;
rho_ZZ= 0.24 ;
eta1=-18.12;
eta2=3.12;
Deltacost=0;  % Shutting down the feedback of debt on rate
rho_Gc=0.9;
rho_Igi=0.9;
gamma_d_trans=0.01;
rho_trans=0;
deltaH=0.025;
gamma=0.5;
rho_Ige=0.9;
alphaZZ1=0.2;
markupss=1.18;
phi=1-0.08/4;   % obsolescence rate: 0.08/4
vartheta=1.35;
probadoptss=0.2/4;
rhoshockchi=1;
rho_ZZRD=0.79;
% AE-specific calibration            (definition                                    | EM value)
% production and growth
alphaG=0.054;                        % share of public capital in production         | EM: 0.17
ZZss=1.004;                          % steady-state gross quarterly growth           | EM: 1.0075
% taxes and debt
taucss=0.18;                         % steady-state consumption tax rate             | EM: 0.15
tauwss=0.25;                         % steady-state income tax rate                  | EM: 0.10
byss=1*4;                            % steady-state debt to quarterly GDP (annual x4)| EM: 0.6*4
% public spending shares of GDP
Igiy=0.03;                            % public investment                             | EM: 0.05
Gcy=0.18;                            % public consumption                            | EM: 0.14
Igey=0.0145;                         % human-capital-related spending                | EM: 0.02
Grdy=0.006;                         % R&D spending                                  | EM: 0.001
% human capital
mu=0.1;                          % elasticity of HC formation w.r.t. public HRC  | EM: 0.25
% R&D and technology adoption
eGRD_ss=0.399;                       % public R&D efficiency gap (e^GRD)              | EM: 0.2
alphaRD=0.09*(1-rho_ZZRD);           % effect of R&D on TFP                          | EM: 0
alphaHA=0.1;                         % HC elasticity in tech creation (paper a_HA)   | EM: 0
varsigma=0.8;                       % adoption elasticity                           | EM: 0.1
% AE efficiency gaps (2023 medians; INF re-estimated 2026-06)
eGI_ss=0.359;
eGE_ss=0.306;
% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alpha)/(vartheta-1))-1;
model;
//********************************************************
// HOUSEHOLD DECISIONS
//********************************************************
// Marginal utility
1/C = lambda*(1+tauc);
// Euler equation
lambda = betta*(lambda(+1)/ZZ(+1)*R/PI(+1));
// Labor decision
omega*(Lab+E)^varphi = lambda*W_real*H(-1)*(1-tauw);
// Law of motion of private capital
Kp*ZZ = (1-delta)*Kp(-1)+Ip;
// Return on private investment
1 = betta*(lambda(+1)/lambda/ZZ(+1)*(1-delta+rk(+1)));
// Human capital of the household
H = (1-deltaH)*H(-1)+muyH*E^gamma*(Kge(-1))^(mu*(1+epsiallo_ige));
// Time devoted to building human capital (E)
omega*(Lab+E)^varphi = lambda_HC*muyH*gamma*E^(gamma-1)*(Kge(-1))^(mu*(1+epsiallo_ige));
// Shadow value of human capital
lambda_HC = betta*(lambda(+1)*(1-tauw(+1))*W_real(+1)*Lab(+1)+lambda_HC(+1)*(1-deltaH));
// Effective labor
N = Lab*H(-1);
//********************************************************
// FIRMS DECISIONS
//********************************************************
// Price setting
x1 = lambda*mc*yd+betta*thetap*(PI^chi/PI(+1))^(-epsilon)*x1(+1);
x2 = lambda*PIstar*yd+betta*thetap*(PI^chi/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*x2(+1);
epsilon*x1 = (epsilon-1)*x2;
// Optimal factor mix
Kp(-1)/N = alpha/(1-alpha)*W_real/rk;
// Marginal cost
(1-alpha)*mc*y/N = markupss*W_real;
// Law of motion of prices
1 = thetap*(PI(-1)^chi/PI)^(1-epsilon)+(1-thetap)*PIstar^(1-epsilon);
// Production
[name='y']
y = A(-1)^(vartheta-1)*(Kg(-1)^(alphaG*(1+epsiallo_ig)))*(Kp(-1)^alpha)*(N^(1-alpha))-Bigtheta;
// Technology creation (R&D enters in efficiency-adjusted form via Grdeff)
ln(ZZRD/STEADY_STATE(ZZRD)) = rho_ZZRD*ln(ZZRD(-1)/STEADY_STATE(ZZRD))+alphaRD*ln(Grdeff(-1)/STEADY_STATE(Grdeff))+alphaHA*ln(H(-1)/STEADY_STATE(H))+log(shockchi);
// Effective R&D = efficiency wedge times R&D spending
Grdeff = (1-eGRD)*Grd;
// Value of an unadopted technology
J = -S+phi*(SDF(+1)*A(-1)/A*1/(1+gammaa)*(probadopt*VA(+1)+(1-probadopt)*J(+1)));
// Probability of adoption
probadopt = (kappaprob+epsirhoadopt)*(S)^(varsigma);
// Adoption
(1+gammaa)*A = probadopt*phi*(ZZRD(-1)-A(-1))+phi*A(-1);
// Value of an adopted technology
VA = (markupss-1)/(markupss)*mc*y + phi*SDF(+1)*VA(+1)*A(-1)/A/(1+gammaa);
// FOC for adoption effort
varsigma*probadopt*phi*SDF(+1)/(1+gammaa)*A(-1)/A*(VA(+1)-J(+1)) = S;
// Stochastic discount factor (detrended)
SDF = betta*lambda*(1+tauc)/(lambda(-1)*(1+tauc(-1)));
// Shock to the R&D technology
log(shockchi) = (1-rhoshockchi)*log(shockchiss)+rhoshockchi*log(shockchi(-1))+epsi_shockchi;
//********************************************************
// MONETARY AUTHORITY
//********************************************************
// Taylor rule
Rmp/Rss = (Rmp(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/ydss)^gamma_y)^(1-rho_R)*exp(epsi_MP);
// Government borrowing cost vs. policy rate (sovereign spread)
log(R) = rho_RG*R(-1)+ (1-rho_RG)*(log(Rmp) + Delta_G*(by(-1)-byss)) + epsi_spread;
Delta_G = prob_def*Deltacost;
prob_def = exp(eta1 + eta2*by(-1))/(1+exp(eta1 + eta2*by(-1)));
//********************************************************
// GOVERNMENT DECISIONS
//********************************************************
// Public infrastructure capital
Kg*ZZ = (1-delta)*Kg(-1)+(1-eGI)*Igi;
// Government debt
D = (R(-1)/PI)*D(-1)/ZZ+Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C;
// Lump-sum transfers
Trans-STEADY_STATE(Trans) = rho_trans*(Trans(-1)-STEADY_STATE(Trans))+(1-rho_trans)*(-gamma_d_trans*(by(-1)-byss)*ydss);
// Debt to GDP
by = D/y;
// Government spending instruments (subject to expenditure shocks)
Gc = Gcss+ydss*epsi_gc;                                     // consumption (explicit instrument; neutrality imposed via the offsetting epsi_gc shock)
Igi = Igiss+ydss*epsi_igi;                                     // infrastructure investment
Ige = Igess+ydss*epsi_ige;                                  // human-capital investment
Grd = Grdss+ydss*epsi_grd;                               // R&D spending
// Consumption tax rule
tauc-taucss = rho_tauc*(tauc(-1)-taucss)+(1-rho_tauc)*(gamma_d_tauc*(by(-1)-byss))+epsi_tauc;
// Income tax rule
tauw-tauwss = rho_tauw*(tauw(-1)-tauwss)+(1-rho_tauw)*(gamma_d_tauw*(by(-1)-byss))+epsi_tauw;
// Public human-capital stock
Kge*ZZ = (1-delta)*Kge(-1)+(1-eGE)*Ige;
//********************************************************
// MARKET CLEARING
//********************************************************
// Aggregate demand
[name='yd']
yd = C+Ip+Igi+Gc+Ige+Grd+Srd+(ZZRD(-1)/A(-1)-1)*S;
// Aggregate production
y = vp*yd;
// Price dispersion
vp = thetap*(PI(-1)^chi/PI)^(-epsilon)*vp(-1)+(1-thetap)*PIstar^(-epsilon);
//********************************************************
// SHOCK DYNAMICS
//********************************************************
// Trend growth
log(ZZ) = (1-rho_ZZ)*log(ZZ(-1))+rho_ZZ*(log(ZZss))+epsi_ZZ;
// Gap in human-capital spending efficiency (e^GE; positive shock closes the gap)
eGE = eGE_ss-epsi_effge;
// Gap in infrastructure spending efficiency (e^GI)
eGI = eGI_ss-epsi_eff;
// Gap in R&D spending efficiency (e^GRD)
eGRD = eGRD_ss-epsi_effcgrd;
//********************************************************
// VARIABLES OF INTEREST
//********************************************************
lnyd = log(yd)*100;
TFP = A(-1)^(vartheta-1)*(Kg(-1)^(alphaG*(1+epsiallo_ig)))*H(-1)^(1-alpha);
G = Gc+Igi+Ige+Grd;                                        // total government spending (sum of the four instruments)
pdef = (Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/y*100;
rreal = R/PI;                                              // ex-post real interest rate
// Fiscal aggregates as a share of steady-state GDP (ydss)
pdef_yss  = (Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/ydss;  // primary deficit
Trans_yss = Trans/ydss;                                       // transfers
dserv_yss = (R-1)*D/ydss;                                    // debt service (interest)
by_yss    = D/ydss;                                          // government debt
Igi_ys = Igi/ydss*100;
by_ann = by/4*100;
lnPI = log(PI)*100;
ln_Grd = log(Grd);
Grd_ydss_ratio = Grd/ydss;
// Output growth
ygrowth = log(yd/yd(-1))*100+log(ZZ)*100;
//********************************************************
// STEADY-STATE VALUES CARRIED INTO THE MODEL BLOCK
//********************************************************
// Auxiliary variables pinned to their steady-state values; used as constants
// in the rules above. Collected here for clarity — in Dynare the order of
// equations within the model block does not affect the solution.
omega       = STEADY_STATE(omega);
Rss         = STEADY_STATE(R);
ydss        = STEADY_STATE(yd);
muyH        = STEADY_STATE(muyH);
kappaprob   = STEADY_STATE(kappaprob);
shockchiss = STEADY_STATE(shockchi);   // exogenous disturbance to the R&D technology
Ns          = STEADY_STATE(Ns);
Srd         = STEADY_STATE(Srd);
Gcss        = Gcy*STEADY_STATE(y);
Igiss        = Igiy*STEADY_STATE(y);
Igess       = Igey*STEADY_STATE(y);
Grdss      = Grdy*STEADY_STATE(y);
end;
steady;
check;
shocks;
var epsi_grd;
periods 1:1000 ;
values
    0.005
;
var epsi_ige;
periods 1:1000 ;
values
    0.005
;
var epsirhoadopt;
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41:1000 ;
values
    -0.00075
    -0.0015
    -0.00225
    -0.003
    -0.00375
    -0.0045
    -0.00525
    -0.006
    -0.00675
    -0.0075
    -0.00825
    -0.009
    -0.00975
    -0.0105
    -0.01125
    -0.012
    -0.01275
    -0.0135
    -0.01425
    -0.015
    -0.01575
    -0.0165
    -0.01725
    -0.018
    -0.01875
    -0.0195
    -0.02025
    -0.021
    -0.02175
    -0.0225
    -0.02325
    -0.024
    -0.02475
    -0.0255
    -0.02625
    -0.027
    -0.02775
    -0.0285
    -0.02925
    -0.03
    -0.03
;
var epsi_gc;
periods 1:1000 ;
values
    -0.01
;
end;
perfect_foresight_setup(periods=2000);
perfect_foresight_solver(maxit=20);
fiscalchange=Igi-Igiss+Ige-Igess+Grd-Grdss;
% Period 1 is the pre-shock steady state (the baseline, subtracted as yd(1));
% the shock is active from period 2 on. An N-year horizon is the 4N quarters in
% indices 2:(N*4+1), so ped=N*4+1 (the slice 2:ped is inclusive of both ends).
ped=1*4+1;
multiplier_1y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=5*4+1;
multiplier_5y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=10*4+1;
multiplier_10y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=20*4+1;
multiplier_20y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=25*4+1;
multiplier_25y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
