var 
C               % HH consumption
lambda          % Marginal Utility
R               % Interest rate on bond
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
Rmp             % Policy rate
b              % Debt level
by              % Debt/GDP
Igi              % Public investment
Gc              % Public consumption
tauc            % Consumption tax
tauw            % Income tax
yd              % Aggregate demand
vp              % Price dispersion
g              % Gross growth rate
%shock_ZZ        % shock to the g process  
omega           % Scaling
Igiss            % Steady state of Investment
Gcss            % Steady state of Consumption
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
Igess           % Steady state of public spending on Public human-capital related stock
L             % Labor supply 
chiH            % Adjuster so that E=0.1
eGE             % Gap in public human-capital efficiency (e^GE)
eGI             % Gap in public infrastructure efficiency (e^GI)
A             % Aoption Tech Process
Grd            % R&D spending
Grdss          % R&D spending SS
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
epsi_g         % Shock to trend
epsi_spread     % Shock to Spread
epsi_MP         % Monetary Policy Shocks
epsi_tauc       % Consumption income tax shock 
epsi_tauw       % Labor income tax shock
epsi_ige        % Public HC spending shock
epsi_effge
epsi_effgi
epsi_grd       % Shock to R&D spending
epsi_q
epsi_effgrd
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
gamma_d_tauc    % Response of consumption tax to debt
rho_tauw        % AR(1) of income tax rate
tauwss          % Income tax rate SS
gamma_d_tauw    % Response of consumption tax to debt
byss            % Steady state of debt
rho_g          % AR(1) of growth shock 
gss            % SS of growth
Igiy             % Public investment/GDP
Gcy             % Public consumption/GDP
gamma_d_T   % Response of lump sum transfer to debt
rho_T
eGI_ss          % SS gap in public infrastructure efficiency (e^GI)
deltaH          % Depreciation of Labor
gamma             % Effectiveness of education investment.
mu          % Elasticity of Human Capital Formation w.r.t. Public Human-related Capital (HRC)
eGE_ss          % SS gap in public human-capital efficiency (e^GE)
Igey            % Share of goevrnment expenditure to human capital
alphaRD         % R&D on TFP
Grdy           % share of expenditure for R&D
markupss        % SS markup of Intermediate goods 
phi           % obsolescence rate: 0.08/4
vartheta      % Intermediate goods elasticity of substitution
gammaa         % Gorwth of tech
qss    % Probability of adoption
varsigma      % Adoption elasticity
alphaHA        % HC elasticity in tech creation (paper alpha_HA)
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
Bigtheta=0;
Bigtheta_y=0;
rho_R=0.7;
gamma_pi=1.5;
gamma_y=0.25;
Piss=1;
rho_RG=0;
rho_tauc=0.9;
gamma_d_tauc=0.0;
rho_tauw=0.9;
gamma_d_tauw=0;
rho_g= 0.24 ;
gamma_d_T=0.01;
rho_T=0;
deltaH=0.025;
gamma=0.5;
markupss=1.18;
phi=1-0.08/4;   % obsolescence rate: 0.08/4
vartheta=1.35;
qss=0.2/4;
rho_A=0.79;
% AE-specific calibration            (definition                                    | EM value)
% production and growth
alphaG=0.054;                        % share of public capital in production         | EM: 0.17
gss=1.004;                          % steady-state gross quarterly growth           | EM: 1.0075
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
alphaRD=0.09*(1-rho_A);           % effect of R&D on TFP                          | EM: 0
alphaHA=0.1;                         % HC elasticity in tech creation (paper a_HA)   | EM: 0
varsigma=0.8;                       % adoption elasticity                           | EM: 0.1
% AE efficiency gaps (2023 medians; INF re-estimated 2026-06)
eGI_ss=0.359;
eGE_ss=0.306;
% gammaa uses the set-specific gss, so it must come after it
gammaa=gss^((1-alpha)/(vartheta-1))-1;
model;
//********************************************************
// HOUSEHOLDS
//********************************************************
// Marginal utility
1/C = lambda*(1+tauc);
// Euler equation
lambda = betta*(lambda(+1)/g(+1)*R/PI(+1));
// Labor decision
omega*(L+E)^varphi = lambda*w*H(-1)*(1-tauw);
// Law of motion of private capital
Kp*g = (1-delta)*Kp(-1)+Ip;
// Return on private investment
1 = betta*(lambda(+1)/lambda/g(+1)*(1-delta+rk(+1)));
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
y = A(-1)^(vartheta-1)*(Kg(-1)^(alphaG))*(Kp(-1)^alpha)*(N^(1-alpha))-Bigtheta;
// Technology creation (R&D enters in efficiency-adjusted form)
ln(Z/STEADY_STATE(Z)) = rho_A*ln(Z(-1)/STEADY_STATE(Z))+alphaRD*ln((1-eGRD(-1))*Grd(-1)/((1-eGRD_ss)*STEADY_STATE(Grd)))+alphaHA*ln(H(-1)/STEADY_STATE(H));
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
// Taylor rule
Rmp/Rss = (Rmp(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/ydss)^gamma_y)^(1-rho_R)*exp(epsi_MP);
// Government borrowing rate (tracks the policy rate up to an exogenous shock)
log(R) = rho_RG*R(-1)+ (1-rho_RG)*log(Rmp) + epsi_spread;
// Public infrastructure capital
Kg*g = (1-delta)*Kg(-1)+(1-eGI)*Igi;
// Public human-capital stock
Kge*g = (1-delta)*Kge(-1)+(1-eGE)*Ige;
// Government debt
b = (R(-1)/PI)*b(-1)/g+Gc+Igi+Ige+Grd+T-tauw*w*N-tauc*C;
// Debt to GDP
by = b/y;
// Government spending instruments (subject to expenditure shocks)
Gc = Gcss+ydss*epsi_gc;                                     // consumption (explicit instrument; neutrality imposed via the offsetting epsi_gc shock)
Igi = Igiss+ydss*epsi_igi;                                     // infrastructure investment
Ige = Igess+ydss*epsi_ige;                                  // human-capital investment
Grd = Grdss+ydss*epsi_grd;                               // R&D spending
// Consumption tax rule
tauc-taucss = rho_tauc*(tauc(-1)-taucss)+(1-rho_tauc)*(gamma_d_tauc*(by(-1)-byss))+epsi_tauc;
// Income tax rule
tauw-tauwss = rho_tauw*(tauw(-1)-tauwss)+(1-rho_tauw)*(gamma_d_tauw*(by(-1)-byss))+epsi_tauw;
// Lump-sum transfers
T-STEADY_STATE(T) = rho_T*(T(-1)-STEADY_STATE(T))+(1-rho_T)*(-gamma_d_T*(by(-1)-byss)*ydss);
// Gap in infrastructure spending efficiency (e^GI)
eGI = eGI_ss-epsi_effgi;
// Gap in human-capital spending efficiency (e^GE; positive shock closes the gap)
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
// BALANCED GROWTH
//********************************************************
// Trend growth
log(g) = (1-rho_g)*log(g(-1))+rho_g*(log(gss))+epsi_g;
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
    0.01
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
