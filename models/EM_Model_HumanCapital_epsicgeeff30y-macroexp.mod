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
yt              % Production
Kg              % Public capital
Rmp             % Policy rate
Dt              % Debt level
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
AAt             % Aoption Tech Process
Grd            % R&D spending
Grdss          % R&D spending SS
shockchit       % R&D process productivity shock SS
SDF             % Stochastic discount factor
St             % Effective labor demand for tech adoption
VA              % Value of tech adoption
probadopt       % Probability of adoption
JZt             % Value of unadopted Intermediate
SSt             % Effective labor demand for R&D development
ZZRD            % R&D product
kappaprob       % Parameter in the probability for scaling
shockchitss     %% SS of shockchit 
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
epsi_shockchit  % Shock to the R&D process 
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
rho_AAt         % Persistence of staionary tech process
alphaRD         % R&D on TFP
Grdy           % share of expenditure for R&D
markupss        % SS markup of Intermediate goods 
phi           % obsolescence rate: 0.08/4
varthetaat      % Intermediate goods elasticity of substitution
gammaa         % Gorwth of tech
probadoptss    % Probability of adoption
varsigma      % Adoption elasticity
alphaHA        % HC elasticity in tech creation (paper alpha_HA)
rhoshockchit    % AR (1) or shock to r&D
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
rho_AAt=0.0;
markupss=1.18;
phi=1-0.08/4;   % obsolescence rate: 0.08/4
varthetaat=1.35;
probadoptss=0.2/4;
rhoshockchit=1;
rho_ZZRD=0.79;
% EM-specific calibration            (definition                                    | AE value)
% production and growth
alphaG=0.17;                         % share of public capital in production         | AE: 0.054
ZZss=1.0075;                         % steady-state gross quarterly growth           | AE: 1.004
% taxes and debt
taucss=0.15;                         % steady-state consumption tax rate             | AE: 0.18
tauwss=0.10;                         % steady-state income tax rate                  | AE: 0.25
byss=0.6*4;                          % steady-state debt to quarterly GDP (annual x4)| AE: 1*4
% public spending shares of GDP
Igiy=0.05;                            % public investment                             | AE: 0.03
Gcy=0.14;                            % public consumption                            | AE: 0.18
Igey=0.02;                           % human-capital-related spending                | AE: 0.0145
Grdy=0.001;                         % R&D spending                                  | AE: 0.006
% human capital
mu=0.25;                         % elasticity of HC formation w.r.t. public HRC  | AE: 0.1
% R&D and technology adoption
eGRD_ss=0.2;                         % public R&D efficiency gap (e^GRD)              | AE: 0.41
alphaRD=0;                           % effect of R&D on TFP                          | AE: 0.09*(1-rho_ZZRD)
alphaHA=0;                           % HC elasticity in tech creation (paper a_HA)   | AE: 0.1
varsigma=0.1;                       % adoption elasticity                           | AE: 0.8
% EMDE efficiency gaps (2023; average of emerging-market and low-income medians; INF re-estimated 2026-06)
eGI_ss=0.406;
eGE_ss=0.329;
% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alpha)/(varthetaat-1))-1;
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
(1-alpha)*mc*yt/N = markupss*W_real;
// Law of motion of prices
1 = thetap*(PI(-1)^chi/PI)^(1-epsilon)+(1-thetap)*PIstar^(1-epsilon);
// Production
[name='yt']
yt = AAt(-1)^(varthetaat-1)*(Kg(-1)^(alphaG*(1+epsiallo_ig)))*(Kp(-1)^alpha)*(N^(1-alpha))-Bigtheta;
// Technology creation (R&D enters in efficiency-adjusted form via Grdeff)
ln(ZZRD/STEADY_STATE(ZZRD)) = rho_ZZRD*ln(ZZRD(-1)/STEADY_STATE(ZZRD))+alphaRD*ln(Grdeff(-1)/STEADY_STATE(Grdeff))+alphaHA*ln(H(-1)/STEADY_STATE(H))+log(shockchit);
// Effective R&D = efficiency wedge times R&D spending
Grdeff = (1-eGRD)*Grd;
// Value of an unadopted technology
JZt = -St+phi*(SDF(+1)*AAt(-1)/AAt*1/(1+gammaa)*(probadopt*VA(+1)+(1-probadopt)*JZt(+1)));
// Probability of adoption
probadopt = (kappaprob+epsirhoadopt)*(St)^(varsigma);
// Adoption
(1+gammaa)*AAt = probadopt*phi*(ZZRD(-1)-AAt(-1))+phi*AAt(-1);
// Value of an adopted technology
VA = (markupss-1)/(markupss)*mc*yt + phi*SDF(+1)*VA(+1)*AAt(-1)/AAt/(1+gammaa);
// FOC for adoption effort
varsigma*probadopt*phi*SDF(+1)/(1+gammaa)*AAt(-1)/AAt*(VA(+1)-JZt(+1)) = St;
// Stochastic discount factor (detrended)
SDF = betta*lambda*(1+tauc)/(lambda(-1)*(1+tauc(-1)));
// Shock to the R&D technology
log(shockchit) = (1-rhoshockchit)*log(shockchitss)+rhoshockchit*log(shockchit(-1))+epsi_shockchit;
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
Dt = (R(-1)/PI)*Dt(-1)/ZZ+Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C;
// Lump-sum transfers
Trans-STEADY_STATE(Trans) = rho_trans*(Trans(-1)-STEADY_STATE(Trans))+(1-rho_trans)*(-gamma_d_trans*(by(-1)-byss)*ydss);
// Debt to GDP
by = Dt/yt;
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
yd = C+Ip+Igi+Gc+Ige+Grd+SSt+(ZZRD(-1)/AAt(-1)-1)*St;
// Aggregate production
yt = vp*yd;
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
TFP = AAt(-1)^(varthetaat-1)*(Kg(-1)^(alphaG*(1+epsiallo_ig)))*H(-1)^(1-alpha);
G = Gc+Igi+Ige+Grd;                                        // total government spending (sum of the four instruments)
pdef = (Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/yt*100;
rreal = R/PI;                                              // ex-post real interest rate
// Fiscal aggregates as a share of steady-state GDP (ydss)
pdef_yss  = (Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/ydss;  // primary deficit
Trans_yss = Trans/ydss;                                       // transfers
dserv_yss = (R-1)*Dt/ydss;                                    // debt service (interest)
by_yss    = Dt/ydss;                                          // government debt
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
shockchitss = STEADY_STATE(shockchit);   // exogenous disturbance to the R&D technology
Ns          = STEADY_STATE(Ns);
SSt         = STEADY_STATE(SSt);
Gcss        = Gcy*STEADY_STATE(yt);
Igiss        = Igiy*STEADY_STATE(yt);
Igess       = Igey*STEADY_STATE(yt);
Grdss      = Grdy*STEADY_STATE(yt);
end;
steady;
check;
shocks;
var epsi_ige;
periods 1:1000 ;
values
    0.01
;
var epsi_effge;
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61:1000 ;
values
    0.00548333
    0.0109667
    0.01645
    0.0219333
    0.0274167
    0.0329
    0.0383833
    0.0438667
    0.04935
    0.0548333
    0.0603167
    0.0658
    0.0712833
    0.0767667
    0.08225
    0.0877333
    0.0932167
    0.0987
    0.104183
    0.109667
    0.11515
    0.120633
    0.126117
    0.1316
    0.137083
    0.142567
    0.14805
    0.153533
    0.159017
    0.1645
    0.169983
    0.175467
    0.18095
    0.186433
    0.191917
    0.1974
    0.202883
    0.208367
    0.21385
    0.219333
    0.224817
    0.2303
    0.235783
    0.241267
    0.24675
    0.252233
    0.257717
    0.2632
    0.268683
    0.274167
    0.27965
    0.285133
    0.290617
    0.2961
    0.301583
    0.307067
    0.31255
    0.318033
    0.323517
    0.329
    0.329
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
