function [ answers, concepts, validationAnswers, validationConcepts ] = ...
  getSyntheticIrtData( )
%getSyntheticData return a set of synthetic student answers
%   Generated according to the IRT model


  function p = pRight(diff, skill)
    p = .25 + .75/(1.0 + exp(diff - skill));
  end

  numStudents = 500;
  validationRatio = .1;
  validationSize = numStudents * validationRatio;
  numConcepts = 10;
  meanQuestionsPerConcept = 20;
  numQuestions = meanQuestionsPerConcept * numConcepts;
  
  %set concept difficulties randomly (iid standard normal)
  conceptDiffs = normrnd(0,1,numConcepts,1);

  %which concept each question belongs to
  qConcepts = randi(numConcepts, numQuestions, 1);
  %make questions within a concept vary by difficulty a bit
  qDiffs = conceptDiffs(qConcepts) + normrnd(0,.5, numQuestions, 1);
  
  %Here, each student answers the same questions, so our concepts matrix is
  %just the same row of question concepts over and over, repeated as many
  %times as there are students
  C = repmat(qConcepts', numStudents, 1);
  
  X = zeros(numStudents, numQuestions);
  
  for i = 1:numStudents
    smartness = normrnd(0,1);
    %knowledge score per-concept, initialized iid standard normal for prior
    conceptKnow = normrnd(smartness - 4,1,numConcepts,1);
    %chance of learning a concept at each question of that concept
    pT = max(0.05, 0.1 + smartness/10); 
    
    for j = 1:numQuestions
      curConcept = C(j);
      knowledge = conceptKnow(curConcept);
      gotItRight = binornd(1, pRight(qDiffs(j), knowledge));
      X(i,j) = gotItRight;
      if binornd(1,pT)
        conceptKnow(curConcept) = knowledge + 2;
      end
    end
  end
  
  
  %split data into training and validation sets
  %according to the validationRatio
  validationIndices = randperm(numStudents, validationSize);
  validationAnswers = X(validationIndices,:);
  validationConcepts = C(validationIndices,:);
  nonValidationIndices = setdiff(1:numStudents, validationIndices);
  answers = X(nonValidationIndices, :);
  concepts = C(nonValidationIndices, :);

end

