function [ answers, concepts, validationAnswers, validationConcepts ] = ...
    getAssistmentsData()

    load('Assistments.mat');
    
    %truncate the matrices so they don't take forever to run stuff on
    Assistments_X = Assistments_X(1:500,1:200);
    Assistments_C = Assistments_C(1:500,1:200);
    
    numStudents = size(Assistments_X, 1);
    numConcepts = length(unique(Assistments_C)) - 1; % minus one needed b/c 0 is not a concept but it is counted

    validationRatio = .1;
    validationSize = round(numStudents * validationRatio);
    
    % Convert zeros to NaN in both matrices
    Assistments_X(find(Assistments_X == 0)) = NaN;
    Assistments_C(find(Assistments_C == 0)) = NaN;     
    
    Assistments_X = Assistments_X - 1;    
    
    validationIndices = randperm(numStudents, validationSize);

    validationAnswers = Assistments_X(validationIndices,:);
    validationConcepts = Assistments_C(validationIndices,:);

    nonValidationIndices = setdiff(1:numStudents, validationIndices);
    answers = Assistments_X(nonValidationIndices, :);
    concepts = Assistments_C(nonValidationIndices, :);

end

