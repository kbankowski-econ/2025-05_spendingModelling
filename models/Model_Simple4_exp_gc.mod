// Template for the simplified (step-by-step) model variants. Identical to
// modelTemplate.mod except it includes model_block_simple.modpart, whose
// productive channels are pinned to steady state by SIMPLIFY_LEVEL:
//   1 -> R&D / endogenous technology off
//   2 -> + human-capital channel off
//   3 -> + public-infrastructure channel off (standard NK with gov. consumption)
// The steady state, declarations and parameters are unchanged (channels are
// pinned, not deleted), so the shared steadystate/declare files are reused.
@#ifndef SIMPLIFY_LEVEL
@#define SIMPLIFY_LEVEL = 0
@#endif

@#include "declare_all.macro"

@#include "parameters_common.macro"

@#include paramFile

@#include effFile

% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alpha)/(varthetaat-1))-1;

model;

@#include "model_block_simple.modpart"

end;

steady;
check;

shocks;
@#include shockFile
end;

@#include "postSimul.mod"
