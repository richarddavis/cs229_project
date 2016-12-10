function [ answers, concepts, validationAnswers, validationConcepts ] = getKddData( )
%getKddData return a set of student answers from the KDD Cup data
% This is fake code! Replace it with real KDD cup data
  numStudents = 1000;
  validationRatio = .1;
  validationSize = numStudents * validationRatio;
  numConcepts = 10;
  meanSeqLength = 20;
  
  %X and C are just random junk - make them actual IRT data!
  X = randi(2,numStudents,numConcepts*meanSeqLength) - 1;
  C = randi(numConcepts, numStudents, numConcepts*meanSeqLength);
  
  validationIndices = randperm(numStudents, validationSize);
  
  validationAnswers = X(validationIndices,:);
  validationConcepts = C(validationIndices,:);
  
  nonValidationIndices = setdiff(1:numStudents, validationIndices);
  answers = X(nonValidationIndices, :);
  concepts = C(nonValidationIndices, :);

end

