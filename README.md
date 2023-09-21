# STAT_models

Rule-based mechanistic modeling, machine learning and analysis code used in the paper, "Predicting gene level sensitivity to JAK-STAT signaling perturbation using a mechanistic-to-machine learning framework."

## Dependencies

* BioNetGen https://bionetgen.org/
* CVODE installation required for rule-based model simulations
* Mex compilation of MATLAB model file is required
* Python
    * Numpy
    * Pandas
    * Matplotlib
    * Scikit-learn
    * Scipy
    * Seaborn
    * Hmmlearn 
    * Multiprocess

## pSTAT_mechanistic_model

This directory includes code and sample data to K-means cluster cytokine conditiions that induced similar pSTAT dynamics, simulate pSTAT trajectories with our rule-based model, conduct the parameter analysis of mechanistic model parameters, and simulate JAK2 inhibition (or other parameter reduction) in the mechanistic model.

### Files

* Data/BNGL_pSTAT_simulations
    * param_sets.csv:
        * subset of parameter ensembles corresponding to the pSTAT trajectory files in this directory generated after fitting the model with pTempEst https://github.com/RuleWorld/ptempest
    * pSTAT1_trajs.csv:
        * mechanistic model-simulated pSTAT1 trajectories corresponding to the provided parameter sets
    * pSTAT3_trajs.csv:
        * mechanistic model-simulated pSTAT3 trajectories corresponding to the provided parameter sets

* Data/pSTAT_experimental_data
    * pSTAT1_pooled_data.xlsx:
        * experimental cytokine-induced pSTAT1 data from IF imaging
    * pSTAT3_pooled_data.xlsx:
        * experimental cytokine-induced pSTAT3 data from IF imaging

* BioNetGen model files
    * variable_JAK_STAT_SOCS_degrad_model.bngl:
        * BioNetGen model file with reaction rules, etc.
    * variable_JAK_STAT_SOCS_degrad_model.m:
        * BioNetGen generated Matlab model file (needs Mex compilation to run)
    * variable_JAK_STAT_SOCS_degrad_model_cvode.c:
        * BioNetGen generated C model file (to evaluate ODEs in Matlab with CVODE)

* Other analysis code
    * kmeans_clustering_trajs.ipynb:
        * code to K-means cluster cytokine stimulation conditions that produce similar experimental trajectories (Fig. 1C)
    * plot_trajectories.ipynb:
        * code to plot mechanistic model-simulated pSTAT trajectories (Fig. 2B)
    * parameter_correlation_analysis.ipynb:
        * code to plot mechanistic model parameter distributions (Fig. S3A) and correlations (Fig. 4A)
    * perturb_trajs.m: 
        * code to simulate pSTAT response with a 3-fold reduction of model parameters (Fig. 5B)

## Early_vs_Late_predictions

This directory includes a subset of mechanistic model-simulated pSTAT3 trajectories used for the machine learning training and testing. It also includes cytokine-induced gene expression data to run the HMM timeframe identification and early/late gene prediction code. 

### Files

* Data/
    * cyt_expr:
        * contains the normalized gene expression values per gene flattened across the three time points (1, 2, 4H) for each cytokoine stimulation condition
    * subset_training_data_pSTAT3.csv:
        * subset of mechanistic-model simulated pSTAT3 trajectories for training
    * subset_training_label_pSTAT3.csv:
        * corresponding flattened gene expression values for training
    * subset_testing_data_pSTAT3.csv:
        * subset of mechanistic-model simulated pSTAT3 trajectories for testing
    * subset_testing_label_pSTAT3.csv:
        * corresponding flattened gene expression values for testing

* Other analysis code
    * HMM_timeframe_ID.ipynb: 
        * code to train HMM and identify boundaries for pSTAT3 timeframes
    * timeframe_predictions.ipynb:
        * code to make gene expression predictions with individual and early/late pSTAT3 timeframes (ones noted in the paper)
    * early_vs_late.ipynb:
        * code to compare early vs. late gene expression predictions (Fig. 3B) and cytokine-specificity (Fig. 3D-E)

## JAK2i_predictions

This directory includes subset of pSTAT1 trajectories with (training) and without (testing ) mechanistic model-simulated JAK2 perturbation and the predicted RMSEs for the IL-6 1 ng/ml predictions. The code is for the decision tree training and testing, as well as for the identification of genes considered JAK2 dependent and independent.

### Files

* Data/
    * cyt_expr:
        * contains the normalized gene expression values per gene flattened across the three time points (1, 2, 4H) for individual cytokine stimulations only (no combination dose)
    * subset_training_data_pSTAT1.csv:
        * subset of mechanistic-model simulated pSTAT1 trajectories for training
    * subset_training_label_pSTAT1.csv:
        * corresponding flattened gene expression values for training
    * subset_testing_data_pSTAT1.csv:
        * subset of mechanistic-model simulated pSTAT1 trajectories after 3-fold reduction of JAK2_0 (JAK2 concentration) and il6_jak2_med_STAT1_act (activation of STAT1 by IL-6-induced JAK2)
    * subset_testing_label_pSTAT1.csv:
        * corresponding flattened gene expression values for testing

* Other analysis code
    * jak2i_gene_predictions.ipynb: 
        * code to train Decision Tree model on the full, unpertubed pSTAT1 trajectories and make gene predictions with the model JAK2-inhibited pSTAT1 trajectories
    * jak2_independent_dependent_predictions.ipynb:
        * code to take RMSEs (IL-6 1 ng/ml predictions only) and identify JAK2 dependent and independent genes based on the gene prediction errors 