There are three main parts to the risk model here. The portion displayed in this folder is the final part where all inputs are applied over the study area. The remaining two folder include data prepartion (in matlab script) and the model training (in rJAGS).

In this folder we see several csv files which are inputs to the spatial model. These include, BA_HT which is the relationship between basal area and height, BETA which includes all trained model parameters for tree fall, BETA_TEST which includes the error values for the previous file, HT_CLASS which includes the height classes for the trees, SZ_CLASS which includes the size classes of the trees involved, TR_MATRIX which is the raw transition matrix from observed data, and Z_FACTOR which includes normalization factors for TPH and DBH values in the data.

The only input not included here is the results from the EAB spread model which is also a required input for this model.

TreeFallProbabilityCost_Zfactor is the primary file here and computes the rate of tree fall and costs across the study area using all the inputs involved.

HeightSensitivity computes two additonal cost estimates based on the upper and lower bounds of tree height.

CostBenefit_Treatment uses the outputs of the previous two to create figures and calculate useful outputs for evaluation.
