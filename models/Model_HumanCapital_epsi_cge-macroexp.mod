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
rho_Cgrd
rho_ZZRD
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
muy=0.5;
alphaH=0.2;
rho_Cge=0.9;
%load param_need;  
alphaZZ1=0.2;
rhoeffge =0;
rhoeff =0;
rho_AAt=0.0;
alphaHA=0.05;
Cgrdy=0.006;
rho_Cgrd=0;
markupss=1.18;
phiob=1-0.08/4;   % obsolescence rate: 0.08/4
varthetaat=1.35;
gammaa=ZZss^((1-alppha)/(varthetaat-1))-1;
probadoptss=0.2/4;
rhoSADOPT=0.8;
alphaSRD=0.1;
rhoshockchit=1;
rho_ZZRD=0.79;
alphaRD=0.09*(1-rho_ZZRD);
model;
//********************************************************
// HOUSEHOLD DECISIONS - 10 equations
//********************************************************
// Steady state values
[name = 'omega']
omega = STEADY_STATE(omega);
[name = 'Cgss']
Cgss = Cgy * STEADY_STATE(yt);
[name = 'Igss']
Igss = Igy * STEADY_STATE(yt);
[name = 'Cgess']
Cgess = Cgey * STEADY_STATE(yt);
[name = 'Cgrdss']
Cgrdss = Cgrdy * STEADY_STATE(yt);
[name = 'Rss']
Rss = STEADY_STATE(R);
[name = 'ydss']
ydss = STEADY_STATE(yd);
[name = 'muyH']
muyH = STEADY_STATE(muyH);
[name = 'shockchitss']
shockchitss = STEADY_STATE(shockchit);  // Exogenous disturbance to the R&D Tech
[name = 'kappaprob']
kappaprob = STEADY_STATE(kappaprob);
// Marginal Utility
[name = 'C']
1/C = lambda * (1 + tauc);
// Euler equation 
[name = 'lambda']
lambda = betta * (lambda(+1) / ZZ(+1) * R / PI(+1));
// Labor decision
[name = 'Lab']
omega * (Lab + E)^phi = lambda * W_real * H(-1) * (1 - tauw);
// Law of motion of private capital
// Original: Kp = (1-delta)*Kp(-1)/ZZ + Ip;
Kp * ZZ = (1 - delta) * Kp(-1) + Ip;
// Return on investment - Choose private capital
[name = 'rk']
1 = betta * (lambda(+1) / lambda / ZZ(+1) * (1 - delta + rk(+1)));
// NEW PATH 
// Human capital of Household: H = (1-delta)*H(-1) + E^muy * (Kge/At)^alphaH
// Original: H = (1-deltaH)*H(-1) + muyH*E^muy*(Kge(-1)/ZZ)^alphaH; 
[name = 'H']
H = (1 - deltaH) * H(-1) + muyH * E^muy * (Kge(-1))^alphaH;
// Time for human capital build: E 
// Original: omega*(Lab+E)^phi = lambda_HC*muyH*muy*E^(muy-1)*(Kge(-1)/ZZ)^alphaH;
[name = 'E']
omega * (Lab + E)^phi = lambda_HC * muyH * muy * E^(muy-1) * (Kge(-1))^alphaH;
// Human capital value
[name = 'lambda_HC']
lambda_HC = betta * (lambda(+1) * (1 - tauw(+1)) * W_real(+1) * Lab(+1) + 
                     lambda_HC(+1) * (1 - deltaH));
// Effective labor
// Original: N + Ns = Lab * H(-1);
[name = 'N']
N = Lab * H(-1);
// Effective labor in the R&D
// Original: Ns = (1-AAt(-1)/ZZRD(-1))*SAt + SSt;
[name = 'Ns']
Ns = STEADY_STATE(Ns);
//********************************************************
// FIRMS DECISIONS - 17 equations
//********************************************************
// Firm's price setting
[name = 'g1']
g1 = lambda * mc * yd + betta * thetap * (PI^chi / PI(+1))^(-epsilon) * g1(+1);
[name = 'g2']
g2 = lambda * PIstar * yd + betta * thetap * (PI^chi / PI(+1))^(1-epsilon) * 
     PIstar / PIstar(+1) * g2(+1);
[name = 'epsilon']
epsilon * g1 = (epsilon - 1) * g2;
// Optimal inputs
// Original: Kp(-1)/N = alppha/(1-alppha)*W_real/rk*ZZ;
Kp(-1) / N = alppha / (1 - alppha) * W_real / rk;
// Marginal cost
// Original: mc = (1/(1-alppha))^(1-alppha)*(1/alppha)^alppha*W_real^(1-alppha)*rk^alppha/(Kg(-1)/(yt+Bigtheta)*1/ZZ)^(zeta/(1-zeta))*1/AAt;
[name = 'mc']
(1 - alppha) * mc * yt / N = markupss * W_real;
// Law of motion prices
[name = 'PI']
1 = thetap * (PI(-1)^chi / PI)^(1-epsilon) + (1 - thetap) * PIstar^(1-epsilon);
// Production function
// Original versions (commented out):
// yt = 1/ZZ^(zeta+alppha-zeta*alppha)*(Kg(-1)^zeta)*(Kp(-1)^(alppha*(1-zeta)))*(N^((1-alppha)*(1-zeta))) - Bigtheta_y*STEADY_STATES(yt);
// yt = AAt*1/ZZ^(zeta+alppha-zeta*alppha)*(Kg(-1)^zeta)*(Kp(-1)^(alppha*(1-zeta)))*((N)^((1-alppha)*(1-zeta))) - Bigtheta;
[name = 'yt']
yt = AAt(-1)^(varthetaat-1) * (Kg(-1)^zeta) * (Kp(-1)^alppha) * (N^(1-alppha)) - Bigtheta;
// Total Factor Productivity
[name = 'TFP']
TFP = AAt(-1)^(varthetaat-1) * (Kg(-1)^zeta) * H(-1)^(1-alppha);
// Stationary tech process (commented out)
// log(AAt) = rho_AAt*log(AAt(-1)) + alphaHA*log(H(-1)/STEADY_STATE(H)) + alphaRD*log(Cgrd(-1)/Cgrdss);
//********************************************************
// R&D AND ADOPTION PROCESS
//********************************************************
/*
ORIGINAL R&D EQUATIONS (COMMENTED OUT):
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
// CURRENT R&D EQUATIONS:
// Ideas development (log-linear form)
// Original: (1+gammaa)*ZZRD=(shockchit)*ZZRD(-1)*SSt^alphaSRD+phiob*ZZRD(-1);
[name = 'ZZRD']
ln(ZZRD / STEADY_STATE(ZZRD)) = rho_ZZRD * ln(ZZRD(-1) / STEADY_STATE(ZZRD)) + 
                                alphaRD * ln(Cgrd(-1) / STEADY_STATE(Cgrd)) + 
                                alphaSRD * ln(H(-1) / STEADY_STATE(H)) + 
                                log(shockchit);
// Research labor (set to steady state)
SSt = STEADY_STATE(SSt);
// OLD equations for research labor (commented out):
// SDF(+1)*JZt(+1)*shockchit*ZZRD(-1)/AAt/(1+gammaa)*SSt^(alphaSRD-1)*Cgrd^alphaRD = 1;
// SDF(+1)*JZt(+1)*(shockchit)*ZZRD(-1)/AAt/(1+gammaa) = SSt^(1-alphaSRD);
// Value of technology frontier
[name = 'JZt']
JZt = -SAt + phiob * (SDF(+1) * AAt(-1) / AAt * 1/(1+gammaa) * 
      (probadopt * VA(+1) + (1 - probadopt) * JZt(+1)));
// Probability of Adoption
[name = 'probadopt']
probadopt = kappaprob * (SAt)^rhoSADOPT;
// Adoption dynamics
(1 + gammaa) * AAt = probadopt * phiob * (ZZRD(-1) - AAt(-1)) + phiob * AAt(-1);
// Value of Adoption
[name = 'VA']
VA = (markupss - 1) / markupss * mc * yt + 
     phiob * SDF(+1) * VA(+1) * AAt(-1) / AAt / (1 + gammaa);
// FOC for adoption
rhoSADOPT * probadopt * phiob * SDF(+1) / (1 + gammaa) * AAt(-1) / AAt * 
(VA(+1) - JZt(+1)) = SAt;
/*
ALTERNATIVE STEADY STATE SPECIFICATION (COMMENTED OUT):
ZZRD = STEADY_STATE(ZZRD);
SSt = STEADY_STATE(SSt);
JZt = STEADY_STATE(JZt);
probadopt = STEADY_STATE(probadopt);
(1+gammaa)*AAt = probadopt*phiob*(ZZRD(-1)-AAt(-1)) + phiob*AAt(-1);
VA = STEADY_STATE(VA);
SAt = STEADY_STATE(SAt);
*/
// Stochastic Discount Factor (after detrend)
[name = 'SDF']
SDF = betta * lambda * (1 + tauc) / (lambda(-1) * (1 + tauc(-1)));
// Shock to R&D
[name = 'shockchit']
log(shockchit) = (1 - rhoshockchit) * log(shockchitss) + 
                 rhoshockchit * log(shockchit(-1)) + epsi_shockchit;
//********************************************************
// MONETARY AUTHORITY - 2 equations
//********************************************************
// Taylor rule
// Original: Rmp/Rss = (Rmp(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/yd(-1)*ZZ/ZZss)^gamma_y)^(1-rho_R)*exp(epsi_MP);
[name = 'Rmp']
Rmp / Rss = (Rmp(-1) / Rss)^rho_R * 
            ((PI / Piss)^gamma_pi * (yd / ydss)^gamma_y)^(1 - rho_R) * exp(epsi_MP);
// Link between borrowing cost of government and policy rate
[name = 'R']
log(R) = rho_RG * R(-1) + (1 - rho_RG) * (log(Rmp) + Delta_G * (by(-1) - byss)) + epsi_spread;
[name = 'Delta_G']
Delta_G = prob_def * Deltacost;
[name = 'prob_def']
prob_def = exp(eta1 + eta2 * by(-1)) / (1 + exp(eta1 + eta2 * by(-1)));
//********************************************************
// GOVERNMENT DECISIONS - 7 equations
//********************************************************
// Public capital
// Original: Kg = (1-delta)*Kg(-1)/ZZ + effshock*Ig;
Kg * ZZ = (1 - delta) * Kg(-1) + effshock * Ig;
// Debt equation
// Original: Bt = (R/PI(+1))*Bt(-1)/ZZ + Cg + Ig + Trans - tauw*W_real*N - tauc*C;
[name = 'Bt']
Bt = (R(-1) / PI) * Bt(-1) / ZZ + Cg + Ig + Cge + Cgrd + Trans - 
     tauw * W_real * N - tauc * C;
// Lump-sum Transfer 
// Original: Trans - STEADY_STATE(Trans) = rho_trans*(Trans(-1) - STEADY_STATE(Trans)) + (1-rho_trans)*(gamma_d_trans*(by(-1) - byss)); 
[name = 'Trans']
Trans - STEADY_STATE(Trans) = rho_trans * (Trans(-1) - STEADY_STATE(Trans)) + 
                              (1 - rho_trans) * (-gamma_d_trans * (by(-1) - byss) * ydss);
// Debt to GDP ratio
[name = 'by']
by = Bt / yt;
// Government Investment dynamics
// Original: log(Ig/Igss) = rho_Ig*log(Ig(-1)/Igss) + epsi_ig;
[name = 'Ig']
Ig = Igss + ydss * epsi_ig;
// Government Consumption dynamics
// Original: log(Cg/Cgss) = rho_Cg*log(Cg(-1)/Cgss) + epsi_cg;
[name = 'Cg']
Cg - Cgss = -(Ig - Igss + Cge - Cgess + Cgrd - Cgrdss);
// Consumption tax
// Original: tauc - taucss = rho_tauc*(tauc(-1) - taucss) + (1-rho_tauc)*(gamma_y_tauc*log(yd/ydss) + gamma_d_tauc*(by - byss));
[name = 'tauc']
tauc - taucss = rho_tauc * (tauc(-1) - taucss) + 
                (1 - rho_tauc) * (gamma_d_tauc * (by(-1) - byss)) + epsi_tauc;
// Income tax 
// Original versions (commented out):
// tauw - tauwss = rho_tauw*(tauw(-1) - tauwss) + (1-rho_tauw)*(gamma_y_tauw*log(yd/ydss) + gamma_d_tauw*(by(-1) - byss)) + epsi_tauw;
// (tauw - tauwss)*W_real*N/yt = gamma_d_tauw*(by(-1) - byss) + epsi_tauw;
[name = 'tauw']
tauw - tauwss = rho_tauw * (tauw(-1) - tauwss) + 
                (1 - rho_tauw) * (gamma_d_tauw * (by(-1) - byss)) + epsi_tauw;
// Public Human-related capital stock
// Original: Kge = (1-delta)*Kge(-1)/ZZ + effgeshock*Cge;
Kge * ZZ = (1 - delta) * Kge(-1) + effgeshock * Cge;
// Government Education/Human Capital Spending dynamics
// Original: log(Cge/Cgess) = rho_Cge*log(Cge(-1)/Cgess) + epsi_cge;
[name = 'Cge']
Cge = Cgess + ydss * epsi_cge;
// R&D Spending (with persistence)
[name = 'Cgrd']
Cgrd - Cgrdss = rho_Cgrd * (Cgrd(-1) - Cgrdss) + ydss * epsi_cgrd;
// Additional R&D variables
[name = 'ln_Cgrd']
ln_Cgrd = log(Cgrd);
[name = 'Cgrd_ydss_ratio']
Cgrd_ydss_ratio = Cgrd / ydss;
//********************************************************
// MARKET CLEARING - 3 equations
//********************************************************
// Aggregate Demand
// Original: yd = C + Ip + Ig + Cg + Cge + Cgrd;
[name = 'yd']
yd = C + Ip + Ig + Cg + Cge + Cgrd + SSt + (ZZRD(-1) / AAt(-1) - 1) * SAt;
// Aggregate production
[name = 'yt']
yt = vp * yd;
// Price dispersion
[name = 'vp']
vp = thetap * (PI(-1)^chi / PI)^(-epsilon) * vp(-1) + (1 - thetap) * PIstar^(-epsilon);
//********************************************************
// SHOCK DYNAMICS - 2 equations
//********************************************************
// Technology shock
[name = 'ZZ']
log(ZZ) = (1 - rho_ZZ) * log(ZZ(-1)) + rho_ZZ * (log(ZZss)) + epsi_ZZ;
// Alternative: ZZ = ZZ(-1)^(1-rho_ZZ) * (ZZss * H^alphaZZ)^rho_ZZ
// Efficiency of human-related spending
[name = 'effgeshock']
effgeshock - effge = rhoeffge * (effgeshock(-1) - effge) + epsi_effge;
// Efficiency of infrastructure spending
[name = 'effshock']
effshock - eff = rhoeff * (effshock(-1) - eff) + epsi_eff;
//********************************************************
// VARIABLES OF INTEREST
//********************************************************
// Log output (in percent)
[name = 'lnyd']
lnyd = log(yd) * 100;
// Primary deficit (as % of GDP)
[name = 'pdef']
pdef = (Cg + Ig + Cge + Cgrd + Trans - tauw * W_real * N - tauc * C) / yt * 100;
// Government investment (as % of steady state GDP)
[name = 'Ig_ys']
Ig_ys = Ig / ydss * 100;
// Debt-to-GDP ratio (annualized, in percent)
[name = 'by_ann']
by_ann = by / 4 * 100;
// Log inflation (in percent)
[name = 'lnPI']
lnPI = log(PI) * 100;
// Output growth rate
[name = 'ygrowth']
ygrowth = log(yd / yd(-1)) * 100 + log(ZZ) * 100;
end;
steady;
check;
shocks;
    var epsi_cge;
periods 1:1000  ;
values 
0.01;
end;
perfect_foresight_setup(periods=2000);%options_.debug
perfect_foresight_solver(maxit=20); %maxit=10 linear_approximation, endogenous_terminal_period
