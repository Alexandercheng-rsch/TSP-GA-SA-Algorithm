function [hyperparam, best_dist,best_std] = accelerated_local_search_sa(parameters,sa,file,acceleration,iteration)

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
  
    termination_flag = false;
    idx = 0;

    
    combination = table2array(combinations(table2array(parameters(:,1)),table2array(parameters(:,2)), ...
        table2array(parameters(:,3)),table2array(parameters(:,4))));
    [combination, ~, ~] = unique(combination,"rows","stable");
    stop = size(combination,1)
    all_dist = zeros(1, stop);
    all_std = zeros(1, stop);
    hyperparam = zeros(stop, width(parameters));
    while termination_flag==false
        idx = idx + 1
        show = true;
        storage = zeros(1, 10);
        for i = 1:10
            [~, best_distance] = sa(file,combination(idx,1),combination(idx,2),combination(idx,3),combination(idx,4),0,0);
            storage(i) = best_distance;
        end
        all_dist(idx) = mean(storage);
        hyperparam(idx,:) = combination(idx,:);
        all_std(idx,:) = std(storage);
        if idx==stop || idx==iteration
            termination_flag = true;
        end
    end
    [~,sorted_idx] = sort(store,"ascend");
    %output of the best performing hyperparameters and routes with distance
    hyperparam = combination(sorted_idx,:);
    best_dist = all_dist(sorted_idx);
    best_dist = best_dist';
    best_std = all_std(sorted_idx)'
end







if acceleration=="multi" && license('test', 'Distrib_Computing_Toolbox')%%transfer to workers
    fprintf("Using parallel computing")

    termination_flag = false;
    
    %%turning table into array
    combination = table2array(combinations(table2array(parameters(:,1)),table2array(parameters(:,2)),table2array(parameters(:,3)), ...
        table2array(parameters(:,4))));
  
    [combination, ~, ~] = unique(combination,"rows","stable");
  
    %%

    
    
    %Storing variables
    stop = size(combination,1)
    all_dist = zeros(1, stop);
    all_std = zeros(1, stop);
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
    show = false;

    parfor idx = 1:stop
        storage = zeros(1, 10);
        for i = 1:10
            [~, best_distance] = sa(file,combination(idx,1),combination(idx,2),combination(idx,3),combination(idx,4),10000,0)
            storage(i) = best_distance;
        end

        all_dist(idx) = mean(storage);
        hyperparam(idx,:) = combination(idx,:);
        all_std(idx,:) = std(storage);  
        disp(idx)
    end
    %
    [~,sorted_idx] = sort(all_dist,"ascend");
    %storing best results based on hyperparameters
    hyperparam = combination(sorted_idx,:);
    best_dist = all_dist(sorted_idx);
    best_dist = best_dist';
    best_std = all_std(sorted_idx)';
    %
    

end

%error code if Toolkit is unavailable
if acceleration=="multi" && ~license('test', 'Distrib_Computing_Toolbox')
    error('Distribution Computing Toolbox not available.')
end



  
end
