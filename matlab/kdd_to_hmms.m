% This file will learn one HMM per concept in the KDD data loaded in using
% the load_cleaned_data function.

% Load the cleaned data that we prepared in python
data = load('final_dict.mat');
cluster_data = load('clustered_dict.mat');

% Temp: Get random concept from the data
fields = fieldnames(data);
rand_concept = fields{randsample(numel(fields), 1)};

% Split the data in each concept into test and train sets. Return
% train and test data for each cluster.
[train, test] = get_concept_data(rand_concept, 0.2, data, cluster_data);

% Learn HMM on train data

% First guess at transition and emission probabilties
trans_ = [0.6,0.4; 
        0,1];
emis_ = [0.6, 0.4; 
        0.4, 0.6];

% Learn transition and emission probs
[estTR,estE] = hmmtrain(train,trans_,emis_);

% Compare guessed sequence to true sequence on the test data

% Use the trained HMM to guess the student's answers 
thresholds = [.1:.01:.99];
p = zeros(1,numel(thresholds));
r = zeros(1,numel(thresholds));
tp = zeros(1,numel(thresholds));
fp = zeros(1,numel(thresholds));

test_size = size(test, 2)
for i = 1:test_size
    test_row = test{1,i};
    p_states = hmmdecode(test_row, estTR, estE);
    % Compare the students actual answers to the HMM's guessed answers
    guessed_seq = zeros(1, size(p_states, 2));
    for j = 1:size(p_states, 2)
        guessed_seq(1,j) = binornd(1, p_states(2,j)) + 1;
    end
    
    for t = 1:numel(thresholds)
    
        guessed_seq = p_states(1,:) > thresholds(1,t);
        guessed_seq = guessed_seq + 1;

        [true_pos, true_neg, false_pos, false_neg] = compare_prediction(int16(test_row), int16(guessed_seq));

        precision = true_pos/(true_pos + false_pos);
        recall = true_pos/(true_pos + false_neg);
        p(1,t) = p(1,t) + precision;
        r(1,t) = r(1,t) + recall;
        tp(1,t) = tp(1,t) + true_pos;
        fp(1,t) = fp(1,t) + false_pos;
        
    end
    
    % How many errors?
    fprintf('The number of true positives is: %d.\n', true_pos)
    fprintf('The number of true negatives is: %d.\n', true_neg)
    fprintf('The number of false positives is: %d.\n', false_pos)
    fprintf('The number of false negatives is: %d.\n', false_neg)
    disp('--------')
    
    plot(tp, fp)
end