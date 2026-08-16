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
pdef_yss        % Primary deficit, share of quarterly steady-state GDP
T_yss       % Transfers, share of quarterly steady-state GDP
by_yss          % Government debt, share of annual steady-state GDP
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
gamma_y=0.125;   % quarterly response to minus the retail price markup, Gertler and Karadi (2011)
Piss=1;
gamma_d_T=0.01;
deltaH=0.025;
gamma=0.5;
markupss=1.18;
phi=1-0.08/4;   % obsolescence rate: 0.08/4
vartheta=1.35;
qss=0.2/4;
rho_A=0.79;
% AE-specific calibration            (definition                                    | EM value)
% production and growth
alphaG=0.054;                        % share of public capital in production         | EM: 0.10
g=1.0046515917901333;               % constant gross quarterly trend growth          | EM: 1.0125195680911334
% taxes and debt
taucss=0.15067283860879371;          % steady-state consumption tax rate             | EM: 0.11583054349525241
tauwss=0.30876981241278333;          % steady-state income tax rate                  | EM: 0.13957543978997473
byss=0.7875515483152252*4;           % steady-state debt to quarterly GDP (annual x4)| EM: 0.46444789855028866*4
% public spending shares of GDP
Igiy=0.025841914048759393;           % infrastructure investment                     | EM: 0.03224078049073542
Gcy=0.1766798699446066;              % public consumption                            | EM: 0.14683743823337528
Igey=0.012785760164632823;           % human-capital-related investment              | EM: 0.016831944761525493
Grdy=0.006;                         % R&D spending                                  | EM: 0.001
% human capital
mu=0.1;                          % elasticity of HC formation w.r.t. public HRC  | EM: 0.15
% R&D and technology adoption
eGRD_ss=0.399;                       % public R&D efficiency gap (e^GRD)              | EM: 0.2
alphaRD=0.09;                         % long-run R&D elasticity in tech creation      | EM: 0
alphaHA=0.1/(1-rho_A);                % long-run HC elasticity (keeps loading at 0.1) | EM: 0
varsigma=0.8;                       % adoption elasticity                           | EM: 0.1
% AE efficiency gaps (2023 medians; INF re-estimated 2026-06)
eGI_ss=0.359;
eGE_ss=0.306;
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
R/Rss = (R(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(mc/STEADY_STATE(mc))^gamma_y)^(1-rho_R)*exp(epsi_MP);
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
// Fiscal flows as a share of quarterly steady-state GDP (ydss)
pdef_yss  = (Gc+Igi+Ige+Grd+T-tauw*w*N-tauc*C)/ydss;  // primary deficit
T_yss = T/ydss;                                       // transfers
by_yss    = b/(4*ydss);                                // government debt relative to annual steady-state GDP
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
    0.00306
    0.00612
    0.00918
    0.01224
    0.0153
    0.01836
    0.02142
    0.02448
    0.02754
    0.0306
    0.03366
    0.03672
    0.03978
    0.04284
    0.0459
    0.04896
    0.05202
    0.05508
    0.05814
    0.0612
    0.06426
    0.06732
    0.07038
    0.07344
    0.0765
    0.07956
    0.08262
    0.08568
    0.08874
    0.0918
    0.09486
    0.09792
    0.10098
    0.10404
    0.1071
    0.11016
    0.11322
    0.11628
    0.11934
    0.1224
    0.12546
    0.12852
    0.13158
    0.13464
    0.1377
    0.14076
    0.14382
    0.14688
    0.14994
    0.153
    0.15606
    0.15912
    0.16218
    0.16524
    0.1683
    0.17136
    0.17442
    0.17748
    0.18054
    0.1836
    0.18666
    0.18972
    0.19278
    0.19584
    0.1989
    0.20196
    0.20502
    0.20808
    0.21114
    0.2142
    0.21726
    0.22032
    0.22338
    0.22644
    0.2295
    0.23256
    0.23562
    0.23868
    0.24174
    0.2448
    0.24786
    0.25092
    0.25398
    0.25704
    0.2601
    0.26316
    0.26622
    0.26928
    0.27234
    0.2754
    0.27846
    0.28152
    0.28458
    0.28764
    0.2907
    0.29376
    0.29682
    0.29988
    0.30294
    0.306
    0.306
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
