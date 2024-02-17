function [selectedIndividuals] = rank_selection(population,population_size,inputcities)

pop_dist = idx2dist(population,inputcities);
[~, idx] = sort(pop_dist,"ascend");

ranks = population_size:-1:1; %% invert so the best distance has highest probability





%calculating selection probabilities
sumRanks = sum(ranks); %sum of all possible ranks 
selectionProbabilities = zeros(1,population_size); %creating an empty array
%%filling up array of probabilities corrersponding to each rank
for i = 1:population_size
    rank = ranks(i);
    probability = rank/sumRanks;
    selectionProbabilities(i) = probability;
end
%%

%%Performing selection
selectedIndividuals = zeros(population_size, size(population, 2));
for j = 1:population_size
    selected = roulette(selectionProbabilities);
    selectedIndividuals(j,:) = population(idx(selected),:);
end
end

function [selectedIndex] = roulette(probabilities)
n = size(probabilities,2);
cumulativeProbs = zeros(1,n);
cumulativeSum = 0;



for i = 1:n
    cumulativeSum = cumulativeSum + probabilities(i);
    cumulativeProbs(i) = cumulativeSum;
end

spin = rand(1);

selectedIndex = 0; 

for j = 1:n
    if spin <= cumulativeProbs(j)
        selectedIndex = j;
        break
    end
end
end

function [dist] = idx2dist(index,inputcities)
dist = [];
for i = 1:size(index,1)
    dist(end + 1) = distance(inputcities(:,index(i,:)));
end
end


