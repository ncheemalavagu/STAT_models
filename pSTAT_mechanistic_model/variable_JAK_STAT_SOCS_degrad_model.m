function [err, timepoints, species_out, observables_out ] = variable_JAK_STAT_SOCS_degrad_model( timepoints, species_init, parameters, suppress_plot )
%VARIABLE_JAK_STAT_SOCS_DEGRAD_MODEL Integrate reaction network and plot observables.
%   Integrates the reaction network corresponding to the BioNetGen model
%   'variable_JAK_STAT_SOCS_degrad_model' and then (optionally) plots the observable trajectories,
%   or species trajectories if no observables are defined. Trajectories are
%   generated using either default or user-defined parameters and initial
%   species values. Integration is performed by the CVode library interfaced
%   to MATLAB via the MEX interface. Before running this script, the model
%   source in file variable_JAK_STAT_SOCS_degrad_model_cvode.c must be compiled (see that file for details).
%   VARIABLE_JAK_STAT_SOCS_DEGRAD_MODEL returns an error value, a vector of timepoints,
%   species trajectories, and observable trajectories.
%   
%   [err, timepoints, species_out, observables_out]
%        = variable_JAK_STAT_SOCS_degrad_model( timepoints, species_init, parameters, suppress_plot )
%
%   INPUTS:
%   -------
%   timepoints      : column vector of time points returned by integrator.
%   species_init    : row vector of 53 initial species populations.
%   parameters      : row vector of 50 model parameters.
%   suppress_plot   : 0 if a plot is desired (default), 1 if plot is suppressed.
%
%   Note: to specify default value for an input argument, pass the empty array.
%
%   OUTPUTS:
%   --------
%   err             : 0 if the integrator exits without error, non-zero otherwise.
%   timepoints      : a row vector of timepoints returned by the integrator.
%   species_out     : array of species population trajectories
%                        (columns correspond to species, rows correspond to time).
%   observables_out : array of observable trajectories
%                        (columns correspond to observables, rows correspond to time).
%
%   QUESTIONS about the BNG Mfile generator?  Email justinshogg@gmail.com



%% Process input arguments

% define any missing arguments
if ( nargin < 1 )
    timepoints = [];
end

if ( nargin < 2 )
    species_init = [];
end

if ( nargin < 3 )
    parameters = [];
end

if ( nargin < 4 )
    suppress_plot = 0;
end


% initialize outputs (to avoid error msgs if script terminates early
err = 0;
species_out     = [];
observables_out = [];


% setup default parameters, if necessary
if ( isempty(parameters) )
   parameters = [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1 ];
end
% check that parameters has proper dimensions
if (  size(parameters,1) ~= 1  ||  size(parameters,2) ~= 50  )
    fprintf( 1, 'Error: size of parameter argument is invalid! Correct size = [1 50].\n' );
    err = 1;
    return;
end

% setup default initial values, if necessary
if ( isempty(species_init) )
   species_init = initialize_species( parameters );
end
% check that species_init has proper dimensions
if (  size(species_init,1) ~= 1  ||  size(species_init,2) ~= 53  )
    fprintf( 1, 'Error: size of species_init argument is invalid! Correct size = [1 53].\n' );
    err = 1;
    return;
end

% setup default timepoints, if necessary
if ( isempty(timepoints) )
   timepoints = linspace(0,90,91+1)';
end
% check that timepoints has proper dimensions
if (  size(timepoints,1) < 2  ||  size(timepoints,2) ~= 1  )
    fprintf( 1, 'Error: size of timepoints argument is invalid! Correct size = [t 1], t>1.\n' );
    err = 1;
    return;
end

% setup default suppress_plot, if necessary
if ( isempty(suppress_plot) )
   suppress_plot = 0;
end
% check that suppress_plot has proper dimensions
if ( size(suppress_plot,1) ~= 1  ||  size(suppress_plot,2) ~= 1 )
    fprintf( 1, 'Error: suppress_plots argument should be a scalar!\n' );
    err = 1;
    return;
end

% define parameter labels (this is for the user's reference!)
param_labels = { 'il6_il6r_binding', 'il6_il6r_unbinding', 'il6r_gp130_binding', 'il6r_gp130_unbinding', 'il6_complex_jak1_binding', 'il6_complex_jak1_unbinding', 'il6_complex_jak2_binding', 'il6_complex_jak2_unbinding', 'SOCS3_il6r_binding', 'SOCS3_il6r_unbinding', 'SOCS3_gp130_binding', 'SOCS3_gp130_unbinding', 'il6_jak1_med_STAT3_act', 'il6_jak1_med_STAT1_act', 'il6_jak2_med_STAT3_act', 'il6_jak2_med_STAT1_act', 'il10_il10r1_binding', 'il10_il10r1_unbinding', 'il10r1_il10r2_binding', 'il10r1_il10r2_unbinding', 'il10_complex_jak1_binding', 'il10_complex_jak1_unbinding', 'il10_jak1_med_STAT3_act', 'il10_jak1_med_STAT1_act', 'SOCS1_jak1_binding', 'SOCS1_jak1_unbinding', 'pSTAT3_rec_dissoc', 'pSTAT1_rec_dissoc', 'PTP_med_STAT3_deact', 'PTP_med_STAT1_deact', 'STAT3_SOCS3_ind', 'STAT3_SOCS1_ind', 'STAT1_SOCS3_ind', 'STAT1_SOCS1_ind', 'L1_0', 'L2_0', 'IL6R_0', 'GP130_0', 'IL10R1_0', 'IL10R2_0', 'JAK1_0', 'JAK2_0', 'SOCS3_0', 'SOCS1_0', 'PTP3_0', 'PTP1_0', 'SOCS3_degrad', 'SOCS1_degrad', 'S3_0', 'S1_0' };



%% Integrate Network Model
try 
    % run simulation
    [err, species_out, observables_out] = variable_JAK_STAT_SOCS_degrad_model_cvode( timepoints, species_init, parameters );
catch
    fprintf( 1, 'Error: some problem integrating ODE network! (CVODE exitflag %d)\n', err );
    err = 1;
    return;
end



%% Plot Output, if desired

if ( ~suppress_plot )
    
    % define plot labels
    observable_labels = { 'total_pS3', 'total_pS1' };

    % construct figure
    plot(timepoints,observables_out);
    title('variable_JAK_STAT_SOCS_degrad_model observables','fontSize',14,'Interpreter','none');
    axis([0 timepoints(end) 0 inf]);
    legend(observable_labels,'fontSize',10,'Interpreter','none');
    xlabel('time','fontSize',12,'Interpreter','none');
    ylabel('number or concentration','fontSize',12,'Interpreter','none');

end



%~~~~~~~~~~~~~~~~~~~~~%
% END of main script! %
%~~~~~~~~~~~~~~~~~~~~~%



% initialize species function
function [species_init] = initialize_species( params )

    species_init = zeros(1,53);
    species_init(1) = params(35);
    species_init(2) = params(37);
    species_init(3) = params(38);
    species_init(4) = params(36);
    species_init(5) = params(39);
    species_init(6) = params(40);
    species_init(7) = params(41);
    species_init(8) = params(42);
    species_init(9) = params(43);
    species_init(10) = params(44);
    species_init(11) = params(45);
    species_init(12) = params(46);
    species_init(13) = params(49);
    species_init(14) = params(50);
    species_init(15) = 0;
    species_init(16) = 0;
    species_init(17) = 0;
    species_init(18) = 0;
    species_init(19) = 0;
    species_init(20) = 0;
    species_init(21) = 0;
    species_init(22) = 0;
    species_init(23) = 0;
    species_init(24) = 0;
    species_init(25) = 0;
    species_init(26) = 0;
    species_init(27) = 0;
    species_init(28) = 0;
    species_init(29) = 0;
    species_init(30) = 0;
    species_init(31) = 0;
    species_init(32) = 0;
    species_init(33) = 0;
    species_init(34) = 0;
    species_init(35) = 0;
    species_init(36) = 0;
    species_init(37) = 0;
    species_init(38) = 0;
    species_init(39) = 0;
    species_init(40) = 0;
    species_init(41) = 0;
    species_init(42) = 0;
    species_init(43) = 0;
    species_init(44) = 0;
    species_init(45) = 0;
    species_init(46) = 0;
    species_init(47) = 0;
    species_init(48) = 0;
    species_init(49) = 0;
    species_init(50) = 0;
    species_init(51) = 0;
    species_init(52) = 0;
    species_init(53) = 0;

end


end
