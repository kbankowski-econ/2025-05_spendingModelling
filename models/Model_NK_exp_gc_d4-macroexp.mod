// =====================================================================
// Canonical New Keynesian model with WASTEFUL government consumption.
// Written from scratch (NOT derived from the main model_block) as a textbook
// benchmark. Deliberately strips the non-standard features of the main model:
//   - stationary: no trend growth (no ZZ);
//   - no price indexation (chi = 0, purely forward-looking Calvo);
//   - constant returns Y = N (no capital), single markup -- mc = real wage;
//   - lump-sum-financed wasteful G (enters only the resource constraint);
//   - standard Taylor rule.
// Structural parameters match the main model where they are standard, so any
// difference in the Gc response isolates the non-standard ingredients.
// Reuses only the shock file (epsi_gc) and the perfect-foresight solver.
// =====================================================================
var C N Lab lambda W_real mc PI PIstar x1 x2 vp yd yt Rmp R Gc rreal;
varexo epsi_gc;
parameters betta phi epsilon thetap gamma_pi gamma_y rho_R Gcy omega Rss PIss ydss Gcss;
betta    = 0.9985;
phi      = 5;     // inverse Frisch elasticity (Frisch 0.2), as in Gali (2015, Ch. 3); was 1.2
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
omega    = ((epsilon-1)/epsilon)/(ydss-Gcss);   // labor-supply FOC at N = yd = 1
model;
// --- Households (log consumption, separable labor) ---
lambda = 1/C;
lambda = betta*lambda(+1)*R/PI(+1);
omega*N^phi = lambda*W_real;
Lab = N;                                          // labor supply = effective labor (H = 1)
// --- Firms: constant returns Y = N (so mc = real wage), Calvo, no indexation ---
mc = W_real;
yt = N;
yt = vp*yd;
x1 = lambda*mc*yd + betta*thetap*(1/PI(+1))^(-epsilon)*x1(+1);
x2 = lambda*PIstar*yd + betta*thetap*(1/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*x2(+1);
epsilon*x1 = (epsilon-1)*x2;
1 = thetap*(1/PI)^(1-epsilon) + (1-thetap)*PIstar^(1-epsilon);
vp = thetap*(1/PI)^(-epsilon)*vp(-1) + (1-thetap)*PIstar^(-epsilon);
// --- Monetary policy ---
Rmp/Rss = (Rmp(-1)/Rss)^rho_R*((PI/PIss)^gamma_pi*(yd/ydss)^gamma_y)^(1-rho_R);
R = Rmp;
// --- Government (wasteful consumption, lump-sum financed) and market clearing ---
yd = C + Gc;
Gc = Gcss + ydss*epsi_gc;
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
x2     = lambda*PIstar*yd/(1-betta*thetap);
x1     = mc*x2;
rreal  = R/PI;
end;
steady;
check;
shocks;
var epsi_gc;
periods 1:4 ;
values
    0.01
;
end;
perfect_foresight_setup(periods=2000);
perfect_foresight_solver(maxit=20);
