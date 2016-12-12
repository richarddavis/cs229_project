function [ answers, concepts, validationAnswers, validationConcepts ] = ...
    getKddData()

    load('KDD_sample.mat');
    
    numStudents = size(KDD_sample_X, 1);
    numConcepts = length(unique(KDD_sample_C)) - 1; % minus one needed b/c 0 is not a concept but it is counted

    validationRatio = .1;
    validationSize = round(numStudents * validationRatio);
    
    % Convert zeros to NaN in both matrices
    KDD_sample_X(find(KDD_sample_X == 0)) = NaN;
    KDD_sample_C(find(KDD_sample_C == 0)) = NaN;     
    
    KDD_sample_X = KDD_sample_X - 1;    
    
    validationIndices = randperm(numStudents, validationSize);

    validationAnswers = KDD_sample_X(validationIndices,:);
    validationConcepts = KDD_sample_C(validationIndices,:);

    nonValidationIndices = setdiff(1:numStudents, validationIndices);
    answers = KDD_sample_X(nonValidationIndices, :);
    concepts = KDD_sample_C(nonValidationIndices, :);

end

