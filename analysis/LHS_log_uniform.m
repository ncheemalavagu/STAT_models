% min and max must be greater than 0 (because of log transformation)
function samples = LHS_log_uniform(n,min_ranges,max_ranges)
    % split cdf into intervals
    bounds = linspace(0,1,n+1);
    samples = zeros(n,length(min_ranges));
    
    % LHS 
    for i = 2:length(bounds)
        % sample in each interval
        a = bounds(i-1);
        b = bounds(i);
        r = a + (b-a).*rand(1,length(min_ranges));
        
        % find value corresponding to sampled CDF
        x = exp((r .* (log(max_ranges) - log(min_ranges))) + log(min_ranges));
        
        % save samples
        samples(i-1,:) = x; 
    end
    
    % randomly form parameter sets
    for i = 1:size(samples,2)
        samples(:,i) = samples(randperm(n),i);
    end
end
