function f = logisticRegressionModel( answers, concepts )
%logisticRegressionModel Train a naive model with logistic regression
%Assume that for every concept, there is a separate model and that the
%only explanatory variable is the length of the sequence up to a point

  [numStudents, maxSeqLength] = size(answers);
  if ~isequal(size(answers), size(concepts));
      error('Must provide concept labels array of same shape as answers array');
  end
  
  %this structure assumes the concepts are sequential 1...numConcepts
  %this must change if that assumption isn't valid for non-synthetic data!
  numConcepts = length(unique(concepts));
  
  %array indexed by concept and how many questions of that concept seen
  %in the sequence before the response (the model assumes that the more
  %questions of a concept a student sees, the higher their chance of
  %getting the next one right)
  corrects = zeros(numConcepts, maxSeqLength);
  totals = zeros(numConcepts, maxSeqLength);
  numSeen = 0:maxSeqLength-1;
  
  for i = 1:numStudents
    %the number of questions of each concept this student has seen
    numSeenByConcept = zeros(numConcepts);
    for j = 1:maxSeqLength
      curConcept = concepts(i,j);
      
      totals(curConcept, numSeenByConcept(curConcept) + 1) = ...
        totals(curConcept, numSeenByConcept(curConcept) + 1) + 1;
      
      if answers(i,j)
        corrects(curConcept, numSeenByConcept(curConcept) + 1) = ...
          corrects(curConcept, numSeenByConcept(curConcept) + 1) + 1;
      end
      numSeenByConcept(curConcept) = numSeenByConcept(curConcept) + 1;
    end
  end

  coefficients = zeros(numConcepts, 2);
  
  for i = 1:numConcepts
    x = numSeen';
    y = corrects(i,:)';
    n = totals(i,:)';
    b = glmfit(x,[y n],'binomial');
    coefficients(i,:) = b;
  end
  
  %make the predictor function that takes a test/validation vector each
  %of answers and concepts, and returns a vector of the same length
  %of predicted response probabilities
  function predictions = predictor(p_answers, p_concepts)
    l = length(p_answers);
    if length(p_concepts) ~= l
      error('Answer and concept lengths must match');
    end
    
    predictions = zeros(1,l);
    
    numSeenByConcept = zeros(numConcepts);
    
    for i = 1:l
      if isnan(p_answers(i)) || isnan(p_concepts(i))
        predictions(i) = NaN;
      else
        curConcept = p_concepts(i);
        B = coefficients(curConcept,:)';
        x = numSeenByConcept(curConcept);
        predictions(i) = glmval(B,x,'logit');
        numSeenByConcept(curConcept) = numSeenByConcept(curConcept) + 1;
      end
    end
  end

  %return the predictor function
  f = @predictor;


end

