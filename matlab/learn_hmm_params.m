% This file is for reference

% Read in synthetic data created in python
M = csvread('../data/matlab_synthetic.csv');
% First guess at transition and emission probabilties
trans_ = [0.6,0.4; 
        0,1];
emis_ = [0.6, 0.4; 
        0.4, 0.6];

% Learn transition and emission probs
[estTR,estE] = hmmtrain(M,trans_,emis_);

% Use the trained HMM to guess the student's answers 
test_row = M(3,:);
p_states = hmmdecode(test_row, estTR, estE);

% Compare the students actual answers to the HMM's guessed answers
guessed_seq = zeros(size(p_states, 2), 1);
for i = 1:size(p_states, 2)
    guessed_seq(i,1) = binornd(1, p_states(2,i)) + 1;
end

% How many errors? If 1, false positive. If -1, false negative.
guessed_seq - M(test_row)'