function [ answers, concepts, validationAnswers, validationConcepts ] = ...
    getKddData()

    load('KDD.mat');
    
    numStudents = size(KDD_X, 1);
    numConcepts = length(unique(KDD_C)) - 1; % minus one needed b/c 0 is not a concept but it is counted

    validationRatio = .1;
    validationSize = round(numStudents * validationRatio);
    
    % Convert zeros to NaN in both matrices
    KDD_X(find(KDD_X == 0)) = NaN;
    KDD_C(find(KDD_C == 0)) = NaN;     
    
    KDD_X = KDD_X - 1;    
    
    validationIndices = randperm(numStudents, validationSize);

    validationAnswers = KDD_X(validationIndices,:);
    validationConcepts = KDD_C(validationIndices,:);

    nonValidationIndices = setdiff(1:numStudents, validationIndices);
    answers = KDD_X(nonValidationIndices, :);
    concepts = KDD_C(nonValidationIndices, :);

end

