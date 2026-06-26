/*
 * Our canonical NK (models/modelTemplateNK.mod = Model_NK_exp_gc) with the
 * PAPER's own calibration (betta=0.9985, phi=1.2, epsilon=10, thetap=0.8,
 * gamma_pi=1.5, gamma_y=0.25, rho_R=0.7, Gcy=0.18) -- i.e. exactly the model
 * behind fig:persistenceGc. The government-consumption shock is an AR(1) process
 * (g_ar, rho_g, one-period eps_g), so a one-period eps_g=0.01 reproduces the
 * geometric 'ar1' path used in the paper pipeline. frisch_rho09.m overrides phi
 * (and rho_g) at run time to ask: does the deflation survive a Gali-like Frisch?
 */
var C N Lab lambda W_real mc PI PIstar x1 x2 vp yd yt Rmp R Gc rreal g_ar;
varexo eps_g;
parameters betta phi epsilon thetap gamma_pi gamma_y rho_R Gcy omega Rss PIss ydss Gcss rho_g;

betta    = 0.9985;
phi      = 1.2;
epsilon  = 10;
thetap   = 0.8;
gamma_pi = 1.5;
gamma_y  = 0.25;
rho_R    = 0.7;
Gcy      = 0.18;
PIss     = 1;
Rss      = 1/betta;
ydss     = 1;
Gcss     = Gcy*ydss;
omega    = ((epsilon-1)/epsilon)/(ydss-Gcss);
rho_g    = 0.9;

model;
    lambda = 1/C;
    lambda = betta*lambda(+1)*R/PI(+1);
    omega*N^phi = lambda*W_real;
    Lab = N;

    mc = W_real;
    yt = N;
    yt = vp*yd;
    x1 = lambda*mc*yd + betta*thetap*(1/PI(+1))^(-epsilon)*x1(+1);
    x2 = lambda*PIstar*yd + betta*thetap*(1/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*x2(+1);
    epsilon*x1 = (epsilon-1)*x2;
    1 = thetap*(1/PI)^(1-epsilon) + (1-thetap)*PIstar^(1-epsilon);
    vp = thetap*(1/PI)^(-epsilon)*vp(-1) + (1-thetap)*PIstar^(-epsilon);

    Rmp/Rss = (Rmp(-1)/Rss)^rho_R*((PI/PIss)^gamma_pi*(yd/ydss)^gamma_y)^(1-rho_R);
    R = Rmp;

    yd = C + Gc;
    Gc = Gcss + ydss*g_ar;
    g_ar = rho_g*g_ar(-1) + eps_g;
    rreal = R/PI;
end;

steady_state_model;
    PI     = PIss;
    PIstar = 1;
    vp     = 1;
    mc     = (epsilon-1)/epsilon;
    W_real = mc;
    R      = Rss;
    Rmp    = Rss;
    Gc     = Gcss;
    yd     = ydss;
    yt     = yd;
    N      = yt;
    Lab    = N;
    C      = yd - Gc;
    lambda = 1/C;
    g_ar   = 0;
    x2     = lambda*PIstar*yd/(1-betta*thetap);
    x1     = mc*x2;
    rreal  = R/PI;
end;

steady;
check;

shocks;
    var eps_g; periods 1; values 0.01;
end;

perfect_foresight_setup(periods=400);
perfect_foresight_solver;
