% ANH NGUYEN (FAD FP)
% Standard macro-fiscal model:
% - Representative household
% - Public expenditure: public consumption, public investment
% - Public revenue: consumption tax, income tax, lump-sum transfer
% - Price stickiness
% - Public investment as in Drautzburg and Uhlig (2015)
var 
    C               % HH consumption
    lambda          % Marginal Utility
    R               % Interest rate on bond
    PI              % Gross inflation
    N               % Labor supply
    W_real          % Real wages
    Ip              % Private investment
    Kp              % Private capital
    rk              % Return on private investment
    g1              % Price setting 1
    g2              % Price setting 2
    mc              % Marginal cost
    PIstar          % Optimal gross inflation 
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
    shock_ZZ        % Shock to the ZZ process  
    Delta_G         % Expected loss 
    prob_def        % Probability of default
    omega           % Scaling
    Igss            % Steady state of investment
    Cgss            % Steady state of consumption
    Rss             % Steady state interest rate   
    ydss            % Steady state output
    Trans           % Transfer
    lnyd            % Log of Output
    pdef            % Primary Deficit 
    Ig_ys           % Public investment as percent of GDP
    by_ann          % Annualized debt-to-GDP 
    lnPI            % Log of price index
;
%-----------------------------
% Exogenous variables
%-----------------------------
varexo
    epsi_cg         % Shock to government consumption
    epsi_ig         % Shock to government investment  
    epsi_ZZ         % Shock to trend
    epsi_spread     % Shock to spread
    epsi_MP         % Monetary policy shocks
    epsi_tauc       % Consumption tax shock 
    epsi_tauw       % Income tax shock
;
%--------------------------
% Parameters
%--------------------------
parameters 
    betta           % Discount factor
    phi             % Frisch parameter
    chi             % Indexation
    delta           % Depreciation
    thetap          % Price rigidity
    epsilon         % Elasticity of substitution 
    alppha          % Capital share in production
    Bigtheta        % Fixed cost
    Bigtheta_y      % Fixed cost to GDP
    zeta            % Public capital share in production
    rho_R           % Policy rate persistence
    gamma_pi        % MP response to inflation
    gamma_y         % MP response to output gap
    Piss            % SS gross inflation
    rho_RG          % Bond rate persistence (average maturity = 1/(1−rho_RG))
    rho_tauc        % Persistence of consumption tax
    taucss          % SS consumption tax
    gamma_y_tauc    % Consumption tax response to output
    gamma_d_tauc    % Consumption tax response to debt
    rho_tauw        % Persistence of income tax
    tauwss          % SS income tax
    gamma_y_tauw    % Income tax response to output
    gamma_d_tauw    % Income tax response to debt
    byss            % SS debt-to-GDP
    rho_ZZ          % Growth shock persistence 
    ZZss            % SS growth
    eta1            % Default prob. parameter 1
    eta2            % Default prob. parameter 2 
    Deltacost       % Haircut (default cost)
    Igy             % Public investment/GDP
    Cgy             % Public consumption/GDP
    rho_Cg          % Public consumption persistence
    rho_Ig          % Public investment persistence  
    gamma_d_trans   % Transfers' response to debt
    rho_trans       % Transfer persistence
    eff             % Public investment efficiency
;
% Parameter values
betta = 0.9985;
phi = 1.2;
chi = 0.6;
delta = 0.025;
thetap = 0.8;
epsilon = 10;
alppha = 0.3;
Bigtheta = 0;
Bigtheta_y = 0;
zeta = 0.025;
rho_R = 0.75;
gamma_pi = 1.5;
gamma_y = 0.25;
Piss = 1;
rho_RG = 0;
rho_tauc = 0.9;
taucss = 0.19;
gamma_y_tauc = 0;
gamma_d_tauc = 0.01;
rho_tauw = 0.9;
tauwss = 0.25;
gamma_y_tauw = 0;
gamma_d_tauw = 0;
byss = 4;
rho_ZZ = 0.24;
ZZss = 1.004;
eta1 = -18.12;
eta2 = 3.12;
Deltacost = 0;
Igy = 0.04;
Cgy = 0.2;
rho_Cg = 0.95;
rho_Ig = 0.95;
gamma_d_trans = 0;
rho_trans = 0.9;
eff = 0.9;
model;
//********************************************************
// HOUSEHOLD DECISIONS
//********************************************************
omega = STEADY_STATE(omega);
Cgss = Cgy * STEADY_STATE(yt);
Igss = Igy * STEADY_STATE(yt);
Rss = STEADY_STATE(R);
ydss = STEADY_STATE(yd);
// Marginal utility
1/C = lambda * (1 + tauc);
// Euler equation 
lambda = betta * (lambda(+1)/ZZ(+1) * R / PI(+1));
// Labor supply
omega * N^phi = lambda * W_real * (1 - tauw);
// Private capital evolution
Kp = (1 - delta) * Kp(-1)/ZZ + Ip;
// Return on private capital
1 = betta * (lambda(+1)/lambda / ZZ(+1) * (1 - delta + rk(+1)));
//********************************************************
// FIRMS' DECISIONS
//********************************************************
g1 = lambda * mc * yd + betta * thetap * (PI^chi / PI(+1))^(-epsilon) * g1(+1);
g2 = lambda * PIstar * yd + betta * thetap * (PI^chi / PI(+1))^(1 - epsilon) * PIstar / PIstar(+1) * g2(+1);
epsilon * g1 = (epsilon - 1) * g2;
Kp(-1)/N = alppha / (1 - alppha) * W_real / rk * ZZ;
mc = (1 / (1 - alppha))^(1 - alppha) * (1 / alppha)^alppha *
     W_real^(1 - alppha) * rk^alppha /
     (Kg(-1) / (yt + Bigtheta) * 1 / ZZ)^(zeta / (1 - zeta));
1 = thetap * (PI(-1)^chi / PI)^(1 - epsilon) + (1 - thetap) * PIstar^(1 - epsilon);
yt = 1 / ZZ^(zeta + alppha - zeta * alppha) *
     (Kg(-1)^zeta) * (Kp(-1)^(alppha * (1 - zeta))) * 
     (N^((1 - alppha) * (1 - zeta))) - Bigtheta;
//********************************************************
// MONETARY AUTHORITY
//********************************************************
Rmp / Rss = (Rmp(-1) / Rss)^rho_R *
            ((PI / Piss)^gamma_pi * 
            (yd / yd(-1) * ZZ / ZZss)^gamma_y)^(1 - rho_R) * exp(epsi_MP);
log(R) = rho_RG * R(-1) + 
         (1 - rho_RG) * (log(Rmp) + Delta_G * (by(-1) - byss)) + 
         epsi_spread;
Delta_G = prob_def * Deltacost;
prob_def = exp(eta1 + eta2 * by(-1)) / (1 + exp(eta1 + eta2 * by(-1)));
//********************************************************
// GOVERNMENT DECISIONS
//********************************************************
Kg = (1 - delta) * Kg(-1) / ZZ + eff * Ig;
Bt = (R / PI(+1)) * Bt(-1) / ZZ + Cg + Ig + Trans - tauw * W_real * N - tauc * C;
Trans - STEADY_STATE(Trans) = rho_trans * (Trans(-1) - STEADY_STATE(Trans)) +
                              (1 - rho_trans) * gamma_d_trans * (by(-1) - byss);
by = Bt / yt;
log(Cg / Cgss) = rho_Cg * log(Cg(-1) / Cgss) + epsi_cg;
log(Ig / Igss) = rho_Ig * log(Ig(-1) / Igss) + epsi_ig;
tauc - taucss = rho_tauc * (tauc(-1) - taucss) +
                (1 - rho_tauc) * gamma_d_tauc * (by(-1) - byss) + 
                epsi_tauc;
tauw - tauwss = rho_tauw * (tauw(-1) - tauwss) +
                (1 - rho_tauw) * gamma_d_tauw * (by(-1) - byss) + 
                epsi_tauw;
//********************************************************
// MARKET CLEARING
//********************************************************
yd = C + Ip + Ig + Cg;
yt = vp * yd;
vp = thetap * (PI(-1)^chi / PI)^(-epsilon) * vp(-1) + 
     (1 - thetap) * PIstar^(-epsilon);
//********************************************************
// SHOCK DYNAMICS
//********************************************************
log(ZZ) = log(ZZss) + shock_ZZ;
shock_ZZ = rho_ZZ * shock_ZZ(-1) + epsi_ZZ;
//********************************************************
// VARIABLES OF INTEREST
//********************************************************
lnyd = log(yd) * 100;
pdef = (Cg + Ig + Trans - tauw * W_real * N - tauc * C) / yt * 100;
Ig_ys = Ig / ydss * 100;
by_ann = by / 4 * 100;
lnPI = log(PI) * 100;
end;
steady;
check;
shocks;
    var epsi_ig;
    stderr 0.25;
end;
stoch_simul(order=1, graph_format=none) R by_ann lnyd Ig_ys pdef;
