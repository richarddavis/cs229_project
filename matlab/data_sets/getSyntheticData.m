function [ answers, concepts, validationAnswers, validationConcepts ] = getSyntheticData( )
%getSyntheticData return a set of synthetic student answers
%   Generated according to the IRT model
  numStudents = 1000;
  validationSize = numStudents / 10;
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

