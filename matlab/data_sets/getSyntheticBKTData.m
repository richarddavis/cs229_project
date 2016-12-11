function [ answers, concepts, validationAnswers, validationConcepts ] = ...
    getSyntheticBKTData()

    numStudents = 1000;
    validationRatio = .1;
    validationSize = numStudents * validationRatio;
    numConcepts = 10;
    numQuestions = 50;
    
    X = zeros(numStudents, numConcepts * numQuestions);
    C = zeros(numStudents, numConcepts * numQuestions);
    
    for c = 1:numConcepts
        
        pL0 = rand;
        pLearn = rand;
        pGuess = rand;
        pSlip = rand;

        trans = [1-pLearn,pLearn; 
                0,1];
        emis = [1-pGuess, pGuess; 
                pSlip, 1-pSlip];

        answers = zeros(numStudents, numQuestions);
        for i = 1:numStudents
            [seq,states] = hmmgenerate(numQuestions,trans,emis);
            si = c * numQuestions - (numQuestions - 1);
            ei = c * numQuestions;
            X(i, si:ei) = seq;
            C(i, si:ei) = c;
        end
    end
    
    X = X - 1;
    validationIndices = randperm(numStudents, validationSize);

    validationAnswers = X(validationIndices,:);
    validationConcepts = C(validationIndices,:);

    nonValidationIndices = setdiff(1:numStudents, validationIndices);
    answers = X(nonValidationIndices, :);
    concepts = C(nonValidationIndices, :);

end

