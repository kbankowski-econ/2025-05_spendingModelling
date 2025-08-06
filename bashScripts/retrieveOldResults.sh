commit=5c41bd207750adaf3165ee5c4fa1ed8381785e52

modelnames=(
Model_HumanCapital_epsi_ig
Model_HumanCapital_epsi_cge
Model_HumanCapital_epsi_cgrd
Model_HumanCapital_epsi_igCgrd
Model_HumanCapital_epsi_igCge
Model_HumanCapital_epsi_cgeCgrd
Model_HumanCapital_epsieff30y
Model_HumanCapital_epsieffcge30y
Model_HumanCapital_epsi_igeff30y
Model_HumanCapital_epsi_igeff25y
Model_HumanCapital_epsi_igeff10y
Model_HumanCapital_epsi_igeff5y
Model_HumanCapital_epsi_cgeeff30y
Model_HumanCapital_epsi_cgeeff25y
Model_HumanCapital_epsi_cgeeff10y
Model_HumanCapital_epsi_cgeeff5y
EM_Model_HumanCapital_epsiig
EM_Model_HumanCapital_epsicge
EM_Model_HumanCapital_epsiigCge
EM_Model_HumanCapital_epsiigCgeVarShare
EM_Model_HumanCapital_epsieff30y
EM_Model_HumanCapital_epsieffcge30y
EM_Model_HumanCapital_epsiigeff30y
EM_Model_HumanCapital_epsiigeff25y
EM_Model_HumanCapital_epsiigeff10y
EM_Model_HumanCapital_epsiigeff5y
EM_Model_HumanCapital_epsiigLAGeff10y
EM_Model_HumanCapital_epsicgeeff30y
EM_Model_HumanCapital_epsicgeeff25y
EM_Model_HumanCapital_epsicgeeff10y
EM_Model_HumanCapital_epsicgeeff5y
EM_Model_HumanCapital_epsicgeLAGeff10y
)

for model in "${modelnames[@]}"; do
    fullpath="models/${model}/Output/${model}_results.mat"
    if git ls-tree -r --name-only "$commit" | grep -qx "$fullpath"; then
        git checkout "$commit" -- "$fullpath"
        mv "$fullpath" "${fullpath%.mat}_old.mat"
        git restore "$fullpath"
        echo "Saved ${fullpath%.mat}_old.mat"
    else
        echo "File not found in commit: $fullpath"
    fi
done
