clear; close all; clc;

%% load parameter sets and setup 3 fold decrease simulations
param_sets = readtable('Data/BNGL_pSTAT_simulations/param_sets.csv');

% select one parameter set as the base case
min_param_set = table2array(param_sets(1,:));

% index of model parameter to change (currently JAK2_0)
param_ind = 42;

% ligand concentrations to test with (currently IL-6 10 ng/ml and IL-10 ng/ml cases only)
il6 = [10,0];
il10 = [0,10];

% other plotting features
stim_color = {[255/255,5/255,5/255],[5/255,134/255,255/255]};
legend_titles = {'IL-6 10 ng/ml','IL-10 10 ng/ml'};

%% plot pSTAT3 trajectories with 3-fold decrease
% loop through ligand concentrations
for ind = 1:length(il6)
    % simulate base trajectory, scale to IL-6 10 ng/ml, and plot
    p = min_param_set;
    p(35:36) = [il6(ind),il10(ind)];
    [err, timepoints, species_out, observables_out ] = variable_JAK_STAT_SOCS_degrad_model( (0:1:90)', [], p, 1);
    
    if il6(ind) == 10 & il10(ind) == 0
        scale = observables_out(21,:);
    end
    observables_out = observables_out ./ scale;
    
    plot(timepoints, observables_out(:,1), 'Color', stim_color{ind},'LineWidth',2)
    hold on;
    
    % simulate curves up to a 3-fold decrease for the parameter of interest
    % scale to IL-6 10 ng/ml and plot
    folds = linspace(1/3,1,10);
    count = 0;
    for i = 1:1:length(folds)
        p = min_param_set;
        p(35:36) = [il6(ind),il10(ind)];
        p(param_ind) = min_param_set(param_ind) * folds(i);
        [err, timepoints, species_out, observables_out ] = variable_JAK_STAT_SOCS_degrad_model( (0:1:90)', [], p, 1);
        
        observables_out = observables_out ./ scale;
        
        t = count * 15;
        plot(timepoints, observables_out(:,1), 'Color', [(240-t)/255,(240-t)/255,(240-t)/255],'LineWidth',2)
        count = count + 1;
    end
    
    p = min_param_set;
    p(35:36) = [il6(ind),il10(ind)];
    [err, timepoints, species_out, observables_out ] = variable_JAK_STAT_SOCS_degrad_model( (0:1:90)', [], p, 1);
    
    % save scaling factor if IL-6 10ng
    if il6(ind) == 10 & il10(ind) == 0
        scale = observables_out(21,:);
    end
    observables_out = observables_out ./ scale;
    
    plot(timepoints, observables_out(:,1), 'Color', stim_color{ind},'LineWidth',2)
    
    ylabel('pSTAT3')
    xlabel('Time (mins)')
    ylim([0,1.1])
    legend(legend_titles{ind})
    title(param_sets.Properties.VariableNames(param_ind))
    close all;
end

%% plot pSTAT1 trajectories with 3-fold decrease
% loop through ligand concentrations
for ind = 1:length(il6)
    % simulate base trajectory, scale to IL-6 10 ng/ml, and plot
    p = min_param_set;
    p(35:36) = [il6(ind),il10(ind)];
    [err, timepoints, species_out, observables_out ] = variable_JAK_STAT_SOCS_degrad_model( (0:1:90)', [], p, 1);
    
    if il6(ind) == 10 & il10(ind) == 0
        scale = observables_out(21,:);
    end
    observables_out = observables_out ./ scale;
    
    plot(timepoints, observables_out(:,2), 'Color', stim_color{ind},'LineWidth',2)
    hold on;

    % simulate curves up to a 3-fold decrease for the parameter of interest
    % scale to IL-6 10 ng/ml and plot
    folds = linspace(1/3,1,10); %0.5:0.1:2;
    count = 0;
    for i = 1:1:length(folds)
        p = min_param_set;
        p(35:36) = [il6(ind),il10(ind)];
        p(param_ind) = min_param_set(param_ind) * folds(i);
        [err, timepoints, species_out, observables_out ] = variable_JAK_STAT_SOCS_degrad_model( (0:1:90)', [], p, 1);
        
        observables_out = observables_out ./ scale;
        
        t = count * 15;
        plot(timepoints, observables_out(:,2), 'Color', [(240-t)/255,(240-t)/255,(240-t)/255],'LineWidth',2)
        count = count + 1;
    end
    
    p = min_param_set;
    p(35:36) = [il6(ind),il10(ind)];
    [err, timepoints, species_out, observables_out ] = variable_JAK_STAT_SOCS_degrad_model( (0:1:90)', [], p, 1);
    
    if il6(ind) == 10 & il10(ind) == 0
        scale = observables_out(21,:);
    end
    observables_out = observables_out ./ scale;

    plot(timepoints, observables_out(:,2), 'Color', stim_color{ind},'LineWidth',2)
    
    ylabel('pSTAT1')
    xlabel('Time (mins)')
    ylim([0,1.1])
    legend(legend_titles{ind})
    title(param_sets.Properties.VariableNames(param_ind))
    close all;
end