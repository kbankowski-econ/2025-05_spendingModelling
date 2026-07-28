"""Verify that the derived Simple7 endpoint reproduces canonical NK paths."""

from pathlib import Path

import numpy as np
from scipy.io import loadmat


PROJECT_ROOT = Path(__file__).resolve().parents[2]
MODELS_DIR = PROJECT_ROOT / "models"
TOLERANCE = 1e-12


def load_result(model_name):
    path = MODELS_DIR / model_name / "Output" / f"{model_name}_results.mat"
    result = loadmat(path, squeeze_me=True, struct_as_record=False)
    names = [str(name) for name in np.atleast_1d(result["M_"].endo_names)]
    paths = np.asarray(result["oo_"].endo_simul)
    return dict(zip(names, paths))


def compare(derived_name, control_name):
    derived = load_result(derived_name)
    control = load_result(control_name)
    shared = sorted(derived.keys() & control.keys())
    differences = {
        name: float(np.max(np.abs(derived[name] - control[name])))
        for name in shared
    }
    maximum_name = max(differences, key=differences.get)
    maximum = differences[maximum_name]
    print(
        f"{derived_name}: {len(shared)} shared paths; "
        f"max difference {maximum:.3e} ({maximum_name})"
    )
    if maximum > TOLERANCE:
        raise AssertionError(
            f"{derived_name} differs from {control_name} by {maximum:.3e}"
        )


if __name__ == "__main__":
    compare("Model_Simple7_exp_gc", "Model_NK_exp_gc")
    compare("Model_Simple7_exp_gc_perm", "Model_NK_exp_gc_perm")
