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
rho_Cge=0.9;
alphaZZ1=0.2;
rhoeffge =0;
rhoeff =0;
rho_AAt=0.0;
rho_Cgrd=0;
markupss=1.18;
phiob=1-0.08/4;   % obsolescence rate: 0.08/4
varthetaat=1.35;
probadoptss=0.2/4;
rhoshockchit=1;
rho_ZZRD=0.79;
% EM-specific calibration            (definition                                    | AE value)
% production and growth
zeta=0.2;                            % share of public capital in production         | AE: 0.054
ZZss=1.0075;                         % steady-state gross quarterly growth           | AE: 1.004
% taxes and debt
taucss=0.15;                         % steady-state consumption tax rate             | AE: 0.18
tauwss=0.10;                         % steady-state income tax rate                  | AE: 0.25
byss=0.6*4;                          % steady-state debt to quarterly GDP (annual x4)| AE: 1*4
% public spending shares of GDP
Igy=0.05;                            % public investment                             | AE: 0.03
Cgy=0.14;                            % public consumption                            | AE: 0.18
Cgey=0.02;                           % human-capital-related spending                | AE: 0.0145
Cgrdy=0.001;                         % R&D spending                                  | AE: 0.006
% human capital
alphaH=0.25;                         % elasticity of HC formation w.r.t. public HRC  | AE: 0.1
alphaHA=0;                           % feedback of human capital to TFP              | AE: 0.05
% R&D and technology adoption
eff_cgrd=0.8;                        % efficiency of public R&D spending             | AE: 1-0.41
alphaRD=0;                           % effect of R&D on TFP                          | AE: 0.09*(1-rho_ZZRD)
alphaSRD=0;                          % R&D elasticity                                | AE: 0.1
rhoSADOPT=0.1;                       % adoption elasticity                           | AE: 0.8
% EM efficiency gaps lowered by 0.1
eff=1-0.415-0.1;
effge=1-0.320-0.1;
% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alppha)/(varthetaat-1))-1;
model;
//********************************************************
// HOUSEHOLD DECISIONS
//********************************************************
// Steady-state values carried into the model block.
omega = STEADY_STATE(omega);
Cgss = Cgy*STEADY_STATE(yt);
Igss = Igy*STEADY_STATE(yt);
Cgess = Cgey*STEADY_STATE(yt);
Cgrdss = Cgrdy*STEADY_STATE(yt);
Rss = STEADY_STATE(R);
ydss = STEADY_STATE(yd);
muyH = STEADY_STATE(muyH);
shockchitss = STEADY_STATE(shockchit);   // exogenous disturbance to the R&D technology
kappaprob = STEADY_STATE(kappaprob);
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
H = (1-deltaH)*H(-1)+muyH*E^muy*(Kge(-1))^(alphaH*(1+epsiallo_cge));
// Time devoted to building human capital (E)
omega*(Lab+E)^phi = lambda_HC*muyH*muy*E^(muy-1)*(Kge(-1))^(alphaH*(1+epsiallo_cge));
// Shadow value of human capital
lambda_HC = betta*(lambda(+1)*(1-tauw(+1))*W_real(+1)*Lab(+1)+lambda_HC(+1)*(1-deltaH));
// Effective labor
N = Lab*H(-1);
// Effective labor in R&D
Ns = STEADY_STATE(Ns);
//********************************************************
// FIRMS DECISIONS
//********************************************************
// Price setting
g1 = lambda*mc*yd+betta*thetap*(PI^chi/PI(+1))^(-epsilon)*g1(+1);
g2 = lambda*PIstar*yd+betta*thetap*(PI^chi/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*g2(+1);
epsilon*g1 = (epsilon-1)*g2;
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
ln(ZZRD/STEADY_STATE(ZZRD)) = rho_ZZRD*ln(ZZRD(-1)/STEADY_STATE(ZZRD))+alphaRD*1/(1+0*(eff_cgrd-effcgrdshock))*ln(Cgrdeff(-1)/STEADY_STATE(Cgrdeff))+alphaSRD*ln(H(-1)/STEADY_STATE(H))+log(shockchit);
SSt = STEADY_STATE(SSt);
// Effective R&D = efficiency wedge times R&D spending
Cgrdeff = effcgrdshock*Cgrd;
// Value of an unadopted technology
JZt = -SAt+phiob*(SDF(+1)*AAt(-1)/AAt*1/(1+gammaa)*(probadopt*VA(+1)+(1-probadopt)*JZt(+1)));
// Probability of adoption
probadopt = (kappaprob+epsirhoadopt)*(SAt)^(rhoSADOPT);
// Adoption
(1+gammaa)*AAt = probadopt*phiob*(ZZRD(-1)-AAt(-1))+phiob*AAt(-1);
// Value of an adopted technology
VA = (markupss-1)/(markupss)*mc*yt + phiob*SDF(+1)*VA(+1)*AAt(-1)/AAt/(1+gammaa);
// FOC for adoption effort
rhoSADOPT*probadopt*phiob*SDF(+1)/(1+gammaa)*AAt(-1)/AAt*(VA(+1)-JZt(+1)) = SAt;
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
Kg*ZZ = (1-delta)*Kg(-1)+effshock*Ig;
// Government debt
Bt = (R(-1)/PI)*Bt(-1)/ZZ+Cg+Ig+Cge+Cgrd+Trans-tauw*W_real*N-tauc*C;
// Lump-sum transfers
Trans-STEADY_STATE(Trans) = rho_trans*(Trans(-1)-STEADY_STATE(Trans))+(1-rho_trans)*(-gamma_d_trans*(by(-1)-byss)*ydss);
// Debt to GDP
by = Bt/yt;
// Government investment dynamics
Ig = Igss+ydss*epsi_ig;
// Government consumption dynamics
Cg-Cgss = -(Ig-Igss+Cge-Cgess+Cgrd-Cgrdss)+ydss*epsi_cg;
// Consumption tax rule
tauc-taucss = rho_tauc*(tauc(-1)-taucss)+(1-rho_tauc)*(gamma_d_tauc*(by(-1)-byss))+epsi_tauc;
// Income tax rule
tauw-tauwss = rho_tauw*(tauw(-1)-tauwss)+(1-rho_tauw)*(gamma_d_tauw*(by(-1)-byss))+epsi_tauw;
// Public human-capital stock
Kge*ZZ = (1-delta)*Kge(-1)+effgeshock*Cge;
// Human-capital spending dynamics
Cge = Cgess+ydss*epsi_cge;
// R&D spending dynamics
Cgrd-Cgrdss = rho_Cgrd*(Cgrd(-1)-Cgrdss)+ydss*epsi_cgrd;
ln_Cgrd = log(Cgrd);
Cgrd_ydss_ratio = Cgrd/ydss;
//********************************************************
// MARKET CLEARING
//********************************************************
// Aggregate demand
yd = C+Ip+Ig+Cg+Cge+Cgrd+SSt+(ZZRD(-1)/AAt(-1)-1)*SAt;
// Aggregate production
yt = vp*yd;
// Price dispersion
vp = thetap*(PI(-1)^chi/PI)^(-epsilon)*vp(-1)+(1-thetap)*PIstar^(-epsilon);
//********************************************************
// SHOCK DYNAMICS
//********************************************************
// Trend growth
log(ZZ) = (1-rho_ZZ)*log(ZZ(-1))+rho_ZZ*(log(ZZss))+epsi_ZZ;
// Efficiency of human-capital spending
effgeshock-effge = rhoeffge*(effgeshock(-1)-effge)+epsi_effge;
// Efficiency of infrastructure spending
effshock-eff = rhoeff*(effshock(-1)-eff)+epsi_eff;
// Efficiency of R&D spending
effcgrdshock-eff_cgrd = 0*(effcgrdshock(-1)-eff_cgrd)+epsi_effcgrd;
//********************************************************
// VARIABLES OF INTEREST
//********************************************************
lnyd = log(yd)*100;
pdef = (Cg+Ig+Cge+Cgrd+Trans-tauw*W_real*N-tauc*C)/yt*100;
Ig_ys = Ig/ydss*100;
by_ann = by/4*100;
lnPI = log(PI)*100;
// Output growth
ygrowth = log(yd/yd(-1))*100+log(ZZ)*100;
end;
steady;
check;
shocks;
var epsi_cge;
periods 1:1000 ;
values
    0.01
;
var epsi_effge;
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101:1000 ;
values
    0.00329
    0.00658
    0.00987
    0.01316
    0.01645
    0.01974
    0.02303
    0.02632
    0.02961
    0.0329
    0.03619
    0.03948
    0.04277
    0.04606
    0.04935
    0.05264
    0.05593
    0.05922
    0.06251
    0.0658
    0.06909
    0.07238
    0.07567
    0.07896
    0.08225
    0.08554
    0.08883
    0.09212
    0.09541
    0.0987
    0.10199
    0.10528
    0.10857
    0.11186
    0.11515
    0.11844
    0.12173
    0.12502
    0.12831
    0.1316
    0.13489
    0.13818
    0.14147
    0.14476
    0.14805
    0.15134
    0.15463
    0.15792
    0.16121
    0.1645
    0.16779
    0.17108
    0.17437
    0.17766
    0.18095
    0.18424
    0.18753
    0.19082
    0.19411
    0.1974
    0.20069
    0.20398
    0.20727
    0.21056
    0.21385
    0.21714
    0.22043
    0.22372
    0.22701
    0.2303
    0.23359
    0.23688
    0.24017
    0.24346
    0.24675
    0.25004
    0.25333
    0.25662
    0.25991
    0.2632
    0.26649
    0.26978
    0.27307
    0.27636
    0.27965
    0.28294
    0.28623
    0.28952
    0.29281
    0.2961
    0.29939
    0.30268
    0.30597
    0.30926
    0.31255
    0.31584
    0.31913
    0.32242
    0.32571
    0.329
    0.329
;
end;
perfect_foresight_setup(periods=2000);
perfect_foresight_solver(maxit=20);
fiscalchange=Ig-Igss+Cge-Cgess+Cgrd-Cgrdss;
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
