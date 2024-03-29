

function [hyperparam, distances] = accelerated_local_search_ga(parameters,tsp,file,acceleration,iteration)

%%If it's empty, these are the default values
if nargin <5 || isempty(iteration)
    iteration = 0;
end
if nargin <3 || isempty(acceleration)
    acceleration = "cpu";
end
%

%%Listing all possible acceleration methods
types = ["cpu","multi"];
if ~any(acceleration==types)
    fprintf("Select an appropriate acceleration method.")
    return
end 
%%

%%CPU acceleration method
if acceleration=="cpu" %%transfer to cpu

    idx = 0; 
    termination_flag = false; 
    combination = table2array(combinations(table2array(parameters(:,1)),table2array(parameters(:,2)),table2array(parameters(:,3)), ...
        table2array(parameters(:,4)),table2array(parameters(:,5)),table2array(parameters(:,6)))); %turning table back into array
    [combination, ~, ~] = unique(combination,"rows","stable"); %Getting unique combinations
    stop = size(combination,1);
    all_dist = zeros(1, stop);
    all_std = zeros(1, stop);
    hyperparam = zeros(stop, width(parameters));
    

     %calculating amount of iterations
    while termination_flag==false
        idx = idx + 1;
        show = false;

        [~,best_distance] = tsp(file,combination(idx,1),combination(idx,2),combination(idx,3), ...
                combination(idx,4),combination(idx,5),combination(idx,6)); %loading into the algorithm

        all_dist(idx) = best_distance;
        hyperparam(idx,:) = combination(idx,:);
        %
        %storing best tours and distances
        store(end + 1) = best_distance(:,1);
        %

        if idx==stop || idx==iteration %%only stops when maximum iterations reached or stated iterations
            termination_flag = true;
        end
    end
    [~,sorted_idx] = sort(store,"ascend"); %% sorts best to worst

    %output of the best performing hyperparameters and routes with distance
    hyperparam = combination(sorted_idx,:);
    distances = all_dist(sorted_idx);
    %
end



if acceleration=="multi" && license('test', 'Distrib_Computing_Toolbox') %%using parallel computing
    fprintf("Using parallel computing")
    termination_flag = false;
    
    %%turning table into array
    combination = table2array(combinations(table2array(parameters(:,1)),table2array(parameters(:,2)),table2array(parameters(:,3)), ...
        table2array(parameters(:,4)),table2array(parameters(:,5)),table2array(parameters(:,6))));
    [combination, ~, ~] = unique(combination,"rows","stable");

    %%

    
    
    %Storing variables
    stop = size(combination,1)
    all_dist = zeros(1, stop);
    hyperparam = zeros(stop, width(parameters));
    %
    
    %if iteration is stated
    if iteration>0
        stop = iteration;
    end
    %

    %creating pool to utilise matlabs toolkit
    pool = gcp('nocreate'); % If no pool, do not create a new one.
    if isempty(pool)
        parpool; % Start a new pool if none exists
    end
    %
    
    %performing parfor loop
    parfor idx = 1:stop
        [~, best_distance] = tsp(file,combination(idx,1),combination(idx,2),combination(idx,3),combination(idx,4), ...
        combination(idx,5),combination(idx,6));
        all_dist(idx) = best_distance;
        hyperparam(idx,:) = combination(idx,:);
        disp(idx)        
    end
    %

    %storing best results based on hyperparameters
    [~,sorted_idx] = sort(all_dist,"ascend");
    %storing best results based on hyperparameters
    hyperparam = combination(sorted_idx,:);
    distances = all_dist(sorted_idx);
    %

end

%error code if Toolkit is unavailable
if acceleration=="cuda" && ~license('test', 'Distrib_Computing_Toolbox')
    error('Distribution Computing Toolbox not available.')
end
%

%

%closing the pool



  
end
