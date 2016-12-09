% This file is for reference

% Read in synthetic data created in python
Train = csvread('../data/matlab_synthetic_train.csv');
Test = csvread('../data/matlab_synthetic_test.csv');
% First guess at transition and emission probabilties
trans_ = [0.6,0.4; 
        0,1];
emis_ = [0.6, 0.4; 
        0.4, 0.6];

% Learn transition and emission probs
[estTR,estE] = hmmtrain(Train,trans_,emis_);

thresholds = [.01:.01:.99];
p = zeros(1,numel(thresholds));
r = zeros(1,numel(thresholds));
tp = zeros(1,numel(thresholds));
fp = zeros(1,numel(thresholds));

for row = 1:size(Test,1)
    % Use the trained HMM to guess the student's answers 
    test_row = Test(row,:);   
        
    p_states = hmmdecode(test_row, estTR, estE);
    

    % Compare the students actual answers to the HMM's guessed answers
    guessed_seq = zeros(size(p_states, 2), 1);
    for i = 1:size(p_states, 2)
        guessed_seq(i,1) = binornd(1, p_states(2,i)) + 1;
    end

    % Another way of generating guessing that will allow us to use AUC
    %thresholds = [.1:.01:.99];
    %p = zeros(1,numel(thresholds));
    %r = zeros(1,numel(thresholds));
    %tp = zeros(1,numel(thresholds));
    %fp = zeros(1,numel(thresholds));
    for t = 1:numel(thresholds)
        guessed_seq = p_states(1,:) > thresholds(1,t);
        guessed_seq = guessed_seq + 1;

        [true_pos, true_neg, false_pos, false_neg] = compare_prediction(test_row, guessed_seq);

        precision = true_pos/(true_pos + false_pos);
        recall = true_pos/(true_pos + false_neg);
        p(1,t) = p(1,t) + precision;
        r(1,t) = r(1,t) + recall;
        tp(1,t) = tp(1,t) + true_pos;
        fp(1,t) = fp(1,t) + false_pos;
    end
end
%plot(r, p)
plot(tp, fp)