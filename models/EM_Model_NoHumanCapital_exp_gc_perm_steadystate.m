function [ys,params,check] = modelTemplateSimple_steadystate(ys,exo,M_,options_)
% Steady state for the progressive simplification ladder.

NumberOfParameters = M_.param_nbr;
for ii = 1:NumberOfParameters
    paramname = M_.param_names{ii};
    eval([paramname ' = M_.params(' int2str(ii) ');']);
end
check = 0;

% Levels 1--6 retain the full model's steady-state resource allocation. This
% isolates each structural channel rather than mixing its removal with changes
% in background spending shares.
Steady_states_solution;

if simplify_level >= 2 || contains(M_.fname, 'NoHumanCapital')
    % Human-capital choices are inactive. Recalibrate the labor-disutility scale
    % so that the common labor target remains a steady state of the reduced FOC.
    H = 1;
    E = 0;
    lambda_H = 0;
    N = L;
    omega = lambda*w*(1-tauw)/L^varphi;
end

if simplify_level >= 7
    % Canonical NK steady state. The terminal derived model uses the same
    % normalization and parameter values as modelTemplateNK.mod.
    PI = 1;
    PIstar = 1;
    vp = 1;
    mc = (epsilon-1)/epsilon;
    w = mc;
    R = 1/betta;
    Rss = R;
    rreal = R/PI;

    yd = 1;
    ydss = yd;
    y = yd;
    N = y;
    L = N;
    H = 1;
    E = 0;
    lambda_H = 0;

    Gc = Gcy*yd;
    G = Gc;
    C = yd-Gc;
    lambda = 1/C;
    omega = lambda*w/L^varphi;

    x2 = lambda*PIstar*yd/(1-betta*thetap);
    x1 = mc*x2;

    % Variables belonging to removed blocks are inert reporting placeholders.
    Ip = 0;
    Kp = 1;
    rk = 0;
    Kg = 1;
    Kge = 1;
    Igi = 0;
    Ige = 0;
    Grd = 0;
    tauc = 0;
    tauw = 0;
    b = 0;
    by = 0;
    T = 0;

    A = 1;
    Z = 1;
    SDF = betta;
    S = 0;
    V = 0;
    q = 0;
    J = 0;
    kappaprob = 0;
    chiH = 0;

    eGE = eGE_ss;
    eGI = eGI_ss;
    eGRD = eGRD_ss;

    pdef_yss = 0;
    T_yss = 0;
    by_yss = 0;
end

params = NaN(NumberOfParameters,1);
for iter = 1:length(M_.params)
    eval(['params(' num2str(iter) ') = ' M_.param_names{iter} ';']);
end

NumberOfEndogenousVariables = M_.orig_endo_nbr;
for ii = 1:NumberOfEndogenousVariables
    varname = M_.endo_names{ii};
    eval(['ys(' int2str(ii) ') = ' varname ';']);
end
