var 
C               % HH consumption
lambda          % Marginal Utility
R               % Nominal policy and government financing rate
PI              % Gross inflation
N               % (Effective) Labor supply
w          % Real wages
Ip              % Private investment
Kp              % Private capital
rk              % Return on private investment
x1              % Price setting 1
x2              % Price setting 2
mc              % Marginal cost
PIstar          % Optimnal gross inflation 
y              % Production
Kg              % Public capital
b              % Debt level
by              % Debt/GDP
Igi              % Public investment
Gc              % Public consumption
tauc            % Consumption tax
tauw            % Income tax
yd              % Aggregate demand
vp              % Price dispersion
omega           % Scaling
Rss             % Steady state interest rate   
ydss            % Steady state output
T           % Transfer
G               % Total government spending (Gc+Igi+Ige+Grd)
rreal           % Ex-post real interest rate (R/PI)
pdef_yss        % Primary deficit, share of steady-state GDP
T_yss       % Transfers, share of steady-state GDP
by_yss          % Government debt, share of steady-state GDP
H               % Human capital
Kge             % Public Human-related Capital Stock (HCS)
Ige             % Public spending in public humand-related capital stock
E               % Time for schooling and taking care of health (building capital)
lambda_H        % Lagrangian of the Human capital formation
L             % Labor supply 
chiH            % Adjuster so that E=0.1
eGE             % Gap in public human-capital efficiency (e^GE)
eGI             % Gap in public infrastructure efficiency (e^GI)
A             % Aoption Tech Process
Grd            % R&D spending
SDF             % Stochastic discount factor
S             % Effective labor demand for tech adoption
V              % Value of tech adoption
q       % Probability of adoption
J             % Value of unadopted Intermediate
Z            % R&D product
kappaprob       % Parameter in the probability for scaling
eGRD            % Gap in public R&D efficiency (e^GRD)
;
%-----------------------------
% Define exogenous variables
%-----------------------------
varexo
epsi_gc         % Shock to government consumption
epsi_igi         % Shock to government investment  
epsi_MP         % Monetary Policy Shocks
epsi_tauc       % Consumption income tax shock 
epsi_tauw       % Labor income tax shock
epsi_ige        % Public HC spending shock
epsi_effge
epsi_effgi
epsi_grd       % Shock to R&D spending
epsi_q
epsi_effgrd
eTaux          % Auxiliary transfer-rule dummy: zero suspends debt feedback
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
alphaG          % Share of public capital in the production (paper alpha_G)
rho_R           % Persistence of policy rate
gamma_pi        % Reponse of MP to inflation
gamma_y         % Reponse of MP to OG
Piss            % SS of gross inflation
taucss          % Consumption tax rate SS
tauwss          % Income tax rate SS
byss            % Steady state of debt
g               % Constant gross trend growth rate
Igiy             % Public investment/GDP
Gcy             % Public consumption/GDP
gamma_d_T   % Response of lump sum transfer to debt
eGI_ss          % SS gap in public infrastructure efficiency (e^GI)
deltaH          % Depreciation of Labor
gamma             % Effectiveness of education investment.
mu          % Elasticity of Human Capital Formation w.r.t. Public Human-related Capital (HRC)
eGE_ss          % SS gap in public human-capital efficiency (e^GE)
Igey            % Share of goevrnment expenditure to human capital
alphaRD         % Long-run R&D elasticity in technology creation
Grdy           % share of expenditure for R&D
markupss        % SS markup of Intermediate goods 
phi           % obsolescence rate: 0.08/4
vartheta      % Intermediate goods elasticity of substitution
gammaa         % Gorwth of tech
qss    % Probability of adoption
varsigma      % Adoption elasticity
alphaHA        % Long-run HC elasticity in technology creation (paper alpha_HA)
rho_A
eGRD_ss         % SS gap in public R&D efficiency (e^GRD)
;
betta=0.9985;
varphi= 5 ;   % inverse Frisch elasticity (Frisch 0.2), as in Gali (2015, Ch. 3); was 1.2
chi =0.6;
delta =0.025;
thetap = 0.8;
epsilon =10;
alpha=0.3;
rho_R=0.7;
gamma_pi=1.5;
gamma_y=0;
Piss=1;
gamma_d_T=0.01;
deltaH=0.025;
gamma=0.5;
markupss=1.18;
phi=1-0.08/4;   % obsolescence rate: 0.08/4
vartheta=1.35;
qss=0.2/4;
rho_A=0.79;
% EM-specific calibration            (definition                                    | AE value)
% production and growth
alphaG=0.17;                         % share of public capital in production         | AE: 0.054
g=1.0075;                           % constant gross quarterly trend growth          | AE: 1.004
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
alphaRD=0;                           % long-run R&D elasticity in tech creation      | AE: 0.09
alphaHA=0;                           % long-run HC elasticity in tech creation       | AE: 0.1/(1-rho_A)
varsigma=0.1;                       % adoption elasticity                           | AE: 0.8
% EMDE efficiency gaps (2023; average of emerging-market and low-income medians; INF re-estimated 2026-06)
eGI_ss=0.406;
eGE_ss=0.329;
% gammaa uses the set-specific trend growth rate, so it must come after it
gammaa=g^((1-alpha)/(vartheta-1))-1;
model;
//********************************************************
// HOUSEHOLDS
//********************************************************
// Marginal utility
1/C = lambda*(1+tauc);
// Euler equation
lambda = betta*(lambda(+1)/g*R/PI(+1));
// Labor decision
omega*(L+E)^varphi = lambda*w*H(-1)*(1-tauw);
// Law of motion of private capital
Kp*g = (1-delta)*Kp(-1)+Ip;
// Return on private investment
1 = betta*(lambda(+1)/lambda/g*(1-delta+rk(+1)));
// Human capital of the household
H = (1-deltaH)*H(-1)+chiH*E^gamma*(Kge(-1))^(mu);
// Time devoted to building human capital (E)
omega*(L+E)^varphi = lambda_H*chiH*gamma*E^(gamma-1)*(Kge(-1))^(mu);
// Shadow value of human capital
lambda_H = betta*(lambda(+1)*(1-tauw(+1))*w(+1)*L(+1)+lambda_H(+1)*(1-deltaH));
// Stochastic discount factor (detrended)
SDF = betta*lambda*(1+tauc)/(lambda(-1)*(1+tauc(-1)));
// Effective labor
N = L*H(-1);
//********************************************************
// PRODUCTION AND TECHNOLOGY
//********************************************************
// Price setting
x1 = lambda*mc*yd+betta*thetap*(PI^chi/PI(+1))^(-epsilon)*x1(+1);
x2 = lambda*PIstar*yd+betta*thetap*(PI^chi/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*x2(+1);
epsilon*x1 = (epsilon-1)*x2;
// Optimal factor mix
Kp(-1)/N = alpha/(1-alpha)*w/rk;
// Marginal cost
(1-alpha)*mc*y/N = markupss*w;
// Law of motion of prices
1 = thetap*(PI(-1)^chi/PI)^(1-epsilon)+(1-thetap)*PIstar^(1-epsilon);
// Production
[name='y']
y = A(-1)^(vartheta-1)*(Kg(-1)^(alphaG))*(Kp(-1)^alpha)*(N^(1-alpha));
// Technology creation (R&D enters in efficiency-adjusted form)
ln(Z/STEADY_STATE(Z)) = rho_A*ln(Z(-1)/STEADY_STATE(Z))+(1-rho_A)*alphaRD*ln((1-eGRD(-1))*Grd(-1)/((1-eGRD_ss)*STEADY_STATE(Grd)))+(1-rho_A)*alphaHA*ln(H(-1)/STEADY_STATE(H));
// Value of an unadopted technology
J = -S+phi*(SDF(+1)*A(-1)/A*1/(1+gammaa)*(q*V(+1)+(1-q)*J(+1)));
// Probability of adoption
q = (kappaprob+epsi_q)*(S)^(varsigma);
// Adoption
(1+gammaa)*A = q*phi*(Z(-1)-A(-1))+phi*A(-1);
// Value of an adopted technology
V = (markupss-1)/(markupss)*mc*y + phi*SDF(+1)*V(+1)*A(-1)/A/(1+gammaa);
// FOC for adoption effort
varsigma*q*phi*SDF(+1)/(1+gammaa)*A(-1)/A*(V(+1)-J(+1)) = S;
//********************************************************
// GOVERNMENT: FISCAL AND MONETARY POLICY
//********************************************************
// Taylor rule for the nominal policy and government financing rate
R/Rss = (R(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/ydss)^gamma_y)^(1-rho_R)*exp(epsi_MP);
// Public infrastructure capital
Kg*g = (1-delta)*Kg(-1)+(1-eGI)*Igi;
// Public education and health capital
Kge*g = (1-delta)*Kge(-1)+(1-eGE)*Ige;
// Government debt
b = (R(-1)/PI)*b(-1)/g+Gc+Igi+Ige+Grd+T-tauw*w*N-tauc*C;
// Debt to GDP
by = b/y;
// Government spending instruments (subject to expenditure shocks)
Gc = Gcy*ydss+ydss*epsi_gc;                                     // consumption (explicit instrument; neutrality imposed via the offsetting epsi_gc shock)
Igi = Igiy*ydss+ydss*epsi_igi;                                     // infrastructure investment
Ige = Igey*ydss+ydss*epsi_ige;                                  // education and health investment
Grd = Grdy*ydss+ydss*epsi_grd;                               // R&D spending
// Consumption tax rate
tauc = taucss+epsi_tauc;
// Labor-income tax rate
tauw = tauwss+epsi_tauw;
// Lump-sum transfers
T-STEADY_STATE(T) = -gamma_d_T*eTaux*(by(-1)-byss)*ydss;
// Gap in infrastructure spending efficiency (e^GI)
eGI = eGI_ss-epsi_effgi;
// Gap in education and health spending efficiency (e^GE; positive shock closes the gap)
eGE = eGE_ss-epsi_effge;
// Gap in R&D spending efficiency (e^GRD)
eGRD = eGRD_ss-epsi_effgrd;
//********************************************************
// MARKET CLEARING AND EQUILIBRIUM
//********************************************************
// Aggregate demand
[name='yd']
yd = C+Ip+Gc+Igi+Ige+Grd+(Z(-1)/A(-1)-1)*S;
// Aggregate production
y = vp*yd;
// Price dispersion
vp = thetap*(PI(-1)^chi/PI)^(-epsilon)*vp(-1)+(1-thetap)*PIstar^(-epsilon);
//********************************************************
// AUXILIARY AND REPORTING
//********************************************************
G = Gc+Igi+Ige+Grd;                                        // total government spending (sum of the four instruments)
rreal = R/PI;                                              // ex-post real interest rate
// Fiscal aggregates as a share of steady-state GDP (ydss)
pdef_yss  = (Gc+Igi+Ige+Grd+T-tauw*w*N-tauc*C)/ydss;  // primary deficit
T_yss = T/ydss;                                       // transfers
by_yss    = b/ydss;                                          // government debt
//********************************************************
// STEADY-STATE VALUES CARRIED INTO THE MODEL BLOCK
//********************************************************
// Auxiliary variables pinned to their steady-state values; used as constants
// in the rules above. Collected here for clarity — in Dynare the order of
// equations within the model block does not affect the solution.
omega       = STEADY_STATE(omega);
Rss         = STEADY_STATE(R);
ydss        = STEADY_STATE(yd);
chiH        = STEADY_STATE(chiH);
kappaprob   = STEADY_STATE(kappaprob);
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
var epsi_gc;
periods 1:1000 ;
values
    -0.01
;
var eTaux;
periods 1:2000 ;
values
    1
;
end;
perfect_foresight_setup(periods=2000);
perfect_foresight_solver(maxit=20);
fiscalchange=(Igi-Igi(1))+(Ige-Ige(1))+(Grd-Grd(1));
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
