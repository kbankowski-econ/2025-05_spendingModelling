/*
 * Our canonical NK (models/modelTemplateNK.mod, i.e. Model_NK_exp_gc) with
 * GALI's calibration substituted in (betta=0.99, varphi=5, theta=0.75,
 * epsilon=9, phi_pi=1.5, phi_y=0.125, NO interest smoothing rho_R=0). The
 * government-consumption shock is driven by the SAME AR(1) process as gali_g.mod
 * (g_ar, rho_g=0.9, one-period eps_g=0.01). Constant returns (Y=N), so this is
 * the alppha=0 case and should match gali_g.mod -DALPHA=0 to numerical precision.
 */
var C N Lab lambda W_real mc PI PIstar x1 x2 vp yd yt Rmp R Gc rreal g_ar;
varexo eps_g;
parameters betta phi epsilon thetap gamma_pi gamma_y rho_R Gcy omega Rss PIss ydss Gcss rho_g;

betta    = 0.99;
phi      = 5;
epsilon  = 9;
thetap   = 0.75;
gamma_pi = 1.5;
gamma_y  = 0.125;
rho_R    = 0;
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

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
