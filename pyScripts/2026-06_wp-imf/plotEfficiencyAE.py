"""Matched AE spending and AE/EMDE efficiency experiments by instrument."""

from plotEfficiencyIRF import plot_efficiency_comparison


INSTRUMENTS = [
    (
        "Infrastructure",
        "#1565C0",
        "Model_HumanCapital_exp_igi_perm025",
        "Model_HumanCapital_effgi_perm025",
        "EM_Model_HumanCapital_effgi_perm025",
    ),
    (
        "Human capital",
        "#6A1B9A",
        "Model_HumanCapital_exp_ige_perm025",
        "Model_HumanCapital_effge_perm025",
        "EM_Model_HumanCapital_effge_perm025",
    ),
    (
        "R&D",
        "#2E7D32",
        "Model_HumanCapital_exp_grd_perm025",
        "Model_HumanCapital_effgrd_perm025",
        None,
    ),
]


if __name__ == "__main__":
    plot_efficiency_comparison(INSTRUMENTS, "efficiencyAE_yd")
