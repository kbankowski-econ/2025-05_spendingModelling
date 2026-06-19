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
Ige             % Public spending in public humand-related capital stock
E               % Time for schooling and taking care of health (building capital)
lambda_HC        % Lagrangian of the Human capital formation
Igess           % Steady state of public spending on Public human-capital related stock
Lab             % Labor supply 
muyH            % Adjuster so that E=0.1
ygrowth          % econonmic growth
effgegap        % Gap in public human-capital efficiency (e^GE)
effgap          % Gap in public infrastructure efficiency (e^GI)
AAt             % Aoption Tech Process
Cgrd            % R&D spending
Cgrdss          % R&D spending SS
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
Cgrd_ydss_ratio
ln_Cgrd
Cgrdeff
effcgrdgap      % Gap in public R&D efficiency (e^GRD)
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
epsi_ige        % Public HC spending shock
epsi_effge  
epsi_eff
epsi_cgrd       % Shock to R&D spending
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
effgap_ss       % SS gap in public infrastructure efficiency (e^GI)
deltaH          % Depreciation of Labor
muy             % Effectiveness of education investment.
alphaH          % Elasticity of Human Capital Formation w.r.t. Public Human-related Capital (HRC)
effgegap_ss     % SS gap in public human-capital efficiency (e^GE)
Igey            % Share of goevrnment expenditure to human capital
alphaZZ1        % Learning by doing off HHon ZZ
rho_Ige         % Persistence of human-related spending
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
rho_ZZRD
effcgrdgap_ss   % SS gap in public R&D efficiency (e^GRD)
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
rho_Cg=0.9;
rho_Ig=0.9;
gamma_d_trans=0.5;
rho_trans=0;
deltaH=0.025;
muy=0.5;
rho_Ige=0.9;
alphaZZ1=0.2;
rho_AAt=0.0;
markupss=1.18;
phiob=1-0.08/4;   % obsolescence rate: 0.08/4
varthetaat=1.35;
probadoptss=0.2/4;
rhoshockchit=1;
rho_ZZRD=0.79;
% AE-specific calibration            (definition                                    | EM value)
% production and growth
zeta=0.054;                          % share of public capital in production         | EM: 0.2
ZZss=1.004;                          % steady-state gross quarterly growth           | EM: 1.0075
% taxes and debt
taucss=0.18;                         % steady-state consumption tax rate             | EM: 0.15
tauwss=0.25;                         % steady-state income tax rate                  | EM: 0.10
byss=1*4;                            % steady-state debt to quarterly GDP (annual x4)| EM: 0.6*4
% public spending shares of GDP
Igy=0.03;                            % public investment                             | EM: 0.05
Cgy=0.18;                            % public consumption                            | EM: 0.14
Igey=0.0145;                         % human-capital-related spending                | EM: 0.02
Cgrdy=0.006;                         % R&D spending                                  | EM: 0.001
% human capital
alphaH=0.1;                          % elasticity of HC formation w.r.t. public HRC  | EM: 0.25
alphaHA=0.05;                        % feedback of human capital to TFP              | EM: 0
% R&D and technology adoption
effcgrdgap_ss=0.41;                  % public R&D efficiency gap (e^GRD)              | EM: 0.2
alphaRD=0.09*(1-rho_ZZRD);           % effect of R&D on TFP                          | EM: 0
alphaSRD=0.1;                        % R&D elasticity                                | EM: 0
rhoSADOPT=0.8;                       % adoption elasticity                           | EM: 0.1
% AE efficiency gaps (2023 medians; INF re-estimated 2026-06)
effgap_ss=0.359;
effgegap_ss=0.306;
% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alppha)/(varthetaat-1))-1;
model;
//********************************************************
// HOUSEHOLD DECISIONS
//********************************************************
// Marginal utility
1/C = lambda*(1+tauc);
// Euler equation
lambda = betta*(lambda(+1)/ZZ(+1)*R/PI(+1));
// Labor decision
omega*(Lab+E)^phi = lambda*W_real*H(-1)*(1-tauw);
// Law of motion of private capital
Kp*ZZ = (1-delta)*Kp(-1)+Ip;
// Return on private investment
1 = betta*(lambda(+1)/lambda/ZZ(+1)*(1-delta+rk(+1)));
// Human capital of the household
H = (1-deltaH)*H(-1)+muyH*E^muy*(Kge(-1))^(alphaH*(1+epsiallo_ige));
// Time devoted to building human capital (E)
omega*(Lab+E)^phi = lambda_HC*muyH*muy*E^(muy-1)*(Kge(-1))^(alphaH*(1+epsiallo_ige));
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
Kp(-1)/N = alppha/(1-alppha)*W_real/rk;
// Marginal cost
(1-alppha)*mc*yt/N = markupss*W_real;
// Law of motion of prices
1 = thetap*(PI(-1)^chi/PI)^(1-epsilon)+(1-thetap)*PIstar^(1-epsilon);
// Production
yt = AAt(-1)^(varthetaat-1)*(Kg(-1)^(zeta*(1+epsiallo_ig)))*(Kp(-1)^alppha)*(N^(1-alppha))-Bigtheta;
TFP = AAt(-1)^(varthetaat-1)*(Kg(-1)^(zeta*(1+epsiallo_ig)))*H(-1)^(1-alppha);
// Technology creation (R&D enters in efficiency-adjusted form via Cgrdeff)
ln(ZZRD/STEADY_STATE(ZZRD)) = rho_ZZRD*ln(ZZRD(-1)/STEADY_STATE(ZZRD))+alphaRD*ln(Cgrdeff(-1)/STEADY_STATE(Cgrdeff))+alphaSRD*ln(H(-1)/STEADY_STATE(H))+log(shockchit);
// Effective R&D = efficiency wedge times R&D spending
Cgrdeff = (1-effcgrdgap)*Cgrd;
// Value of an unadopted technology
JZt = -St+phiob*(SDF(+1)*AAt(-1)/AAt*1/(1+gammaa)*(probadopt*VA(+1)+(1-probadopt)*JZt(+1)));
// Probability of adoption
probadopt = (kappaprob+epsirhoadopt)*(St)^(rhoSADOPT);
// Adoption
(1+gammaa)*AAt = probadopt*phiob*(ZZRD(-1)-AAt(-1))+phiob*AAt(-1);
// Value of an adopted technology
VA = (markupss-1)/(markupss)*mc*yt + phiob*SDF(+1)*VA(+1)*AAt(-1)/AAt/(1+gammaa);
// FOC for adoption effort
rhoSADOPT*probadopt*phiob*SDF(+1)/(1+gammaa)*AAt(-1)/AAt*(VA(+1)-JZt(+1)) = St;
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
Kg*ZZ = (1-delta)*Kg(-1)+(1-effgap)*Ig;
// Government debt
Dt = (R(-1)/PI)*Dt(-1)/ZZ+Cg+Ig+Ige+Cgrd+Trans-tauw*W_real*N-tauc*C;
// Lump-sum transfers
Trans-STEADY_STATE(Trans) = rho_trans*(Trans(-1)-STEADY_STATE(Trans))+(1-rho_trans)*(-gamma_d_trans*(by(-1)-byss)*ydss);
// Debt to GDP
by = Dt/yt;
// Government spending instruments (subject to expenditure shocks)
Cg-Cgss = -(Ig-Igss+Ige-Igess+Cgrd-Cgrdss)+ydss*epsi_cg;   // consumption (residual, budget-neutral)
Ig = Igss+ydss*epsi_ig;                                     // infrastructure investment
Ige = Igess+ydss*epsi_ige;                                  // human-capital investment
Cgrd = Cgrdss+ydss*epsi_cgrd;                               // R&D spending
// Consumption tax rule
tauc-taucss = rho_tauc*(tauc(-1)-taucss)+(1-rho_tauc)*(gamma_d_tauc*(by(-1)-byss))+epsi_tauc;
// Income tax rule
tauw-tauwss = rho_tauw*(tauw(-1)-tauwss)+(1-rho_tauw)*(gamma_d_tauw*(by(-1)-byss))+epsi_tauw;
// Public human-capital stock
Kge*ZZ = (1-delta)*Kge(-1)+(1-effgegap)*Ige;
//********************************************************
// MARKET CLEARING
//********************************************************
// Aggregate demand
yd = C+Ip+Ig+Cg+Ige+Cgrd+SSt+(ZZRD(-1)/AAt(-1)-1)*St;
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
effgegap = effgegap_ss-epsi_effge;
// Gap in infrastructure spending efficiency (e^GI)
effgap = effgap_ss-epsi_eff;
// Gap in R&D spending efficiency (e^GRD)
effcgrdgap = effcgrdgap_ss-epsi_effcgrd;
//********************************************************
// VARIABLES OF INTEREST
//********************************************************
lnyd = log(yd)*100;
pdef = (Cg+Ig+Ige+Cgrd+Trans-tauw*W_real*N-tauc*C)/yt*100;
Ig_ys = Ig/ydss*100;
by_ann = by/4*100;
lnPI = log(PI)*100;
ln_Cgrd = log(Cgrd);
Cgrd_ydss_ratio = Cgrd/ydss;
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
Cgss        = Cgy*STEADY_STATE(yt);
Igss        = Igy*STEADY_STATE(yt);
Igess       = Igey*STEADY_STATE(yt);
Cgrdss      = Cgrdy*STEADY_STATE(yt);
end;
steady;
check;
shocks;
var epsi_cgrd;
periods 1:1000 ;
values
    0.01
;
var epsi_effcgrd;
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101:1000 ;
values
    0.0041
    0.0082
    0.0123
    0.0164
    0.0205
    0.0246
    0.0287
    0.0328
    0.0369
    0.041
    0.0451
    0.0492
    0.0533
    0.0574
    0.0615
    0.0656
    0.0697
    0.0738
    0.0779
    0.082
    0.0861
    0.0902
    0.0943
    0.0984
    0.1025
    0.1066
    0.1107
    0.1148
    0.1189
    0.123
    0.1271
    0.1312
    0.1353
    0.1394
    0.1435
    0.1476
    0.1517
    0.1558
    0.1599
    0.164
    0.1681
    0.1722
    0.1763
    0.1804
    0.1845
    0.1886
    0.1927
    0.1968
    0.2009
    0.205
    0.2091
    0.2132
    0.2173
    0.2214
    0.2255
    0.2296
    0.2337
    0.2378
    0.2419
    0.246
    0.2501
    0.2542
    0.2583
    0.2624
    0.2665
    0.2706
    0.2747
    0.2788
    0.2829
    0.287
    0.2911
    0.2952
    0.2993
    0.3034
    0.3075
    0.3116
    0.3157
    0.3198
    0.3239
    0.328
    0.3321
    0.3362
    0.3403
    0.3444
    0.3485
    0.3526
    0.3567
    0.3608
    0.3649
    0.369
    0.3731
    0.3772
    0.3813
    0.3854
    0.3895
    0.3936
    0.3977
    0.4018
    0.4059
    0.41
    0.41
;
end;
perfect_foresight_setup(periods=2000);
perfect_foresight_solver(maxit=20);
fiscalchange=Ig-Igss+Ige-Igess+Cgrd-Cgrdss;
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
