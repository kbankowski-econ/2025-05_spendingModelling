// Template for the progressive model-simplification variants. Starting from
// the full model, SIMPLIFY_LEVEL removes one additional block at each step:
//   1 -> endogenous technology creation and adoption
//   2 -> + human-capital accumulation
//   3 -> + productive public infrastructure
//   4 -> + private capital; labor-only constant-returns production
//   5 -> + price indexation
//   6 -> + trend growth
//   7 -> + extended fiscal block; canonical lump-sum-financed G model
// NO_HUMAN_CAPITAL provides a separate, non-cumulative counterfactual that
// removes only human capital while retaining endogenous technology.
// Inactive variables remain declared and are pinned solely so every variant can
// use the common export pipeline. They do not enter the active equilibrium.
@#ifndef SIMPLIFY_LEVEL
@#define SIMPLIFY_LEVEL = 0
@#endif

@#ifndef NO_INDEXATION
@#define NO_INDEXATION = 0
@#endif

@#ifndef NO_HUMAN_CAPITAL
@#define NO_HUMAN_CAPITAL = 0
@#endif

@#include "declare_all.macro"

@#include "parameters_common.macro"

@#include paramFile

@#include effFile

// Expose the macro level to the external steady-state routine.
parameters simplify_level;
simplify_level = @{SIMPLIFY_LEVEL};

// Controlled price-setting counterfactual: retain the selected simplification
// level and remove only the indexation of non-reset prices.
@#if NO_INDEXATION
chi = 0;
@#endif

@#if SIMPLIFY_LEVEL >= 5
chi = 0;
@#endif

@#if SIMPLIFY_LEVEL >= 6
g = 1;
@#endif

% Technology growth balances the common trends in private and public capital.
gammaa=g^((1-alpha-alphaG)/(vartheta-1))-1;

model;

@#include "model_block_simple.modpart"

end;

steady;
check;

shocks;
@#include shockFile
end;

@#include "postSimul.mod"
