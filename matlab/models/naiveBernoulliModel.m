function f = naiveBernoulliModel( answers, concepts )
%NAIVE Train a naive model on training sets of answers and concepts
%   Assume every concept just has a constant p(correct) - that
%   every answer is Bernoulli(pConcept)
%   returns a function that takes a trajectory of answers and a trajectory
%   of concepts (both 1 dimensional, same length)
%   and returns a list of the same length, which is the predicted
%   probabilities of a correct response at every position, given the 
%   previous responses up to that position

  %this structure assumes the concepts are sequential 1...numConcepts
  %this must change if that assumption isn't valid for non-synthetic data!
  numConcepts = length(unique(concepts(~isnan(concepts))));
  Ps = zeros(numConcepts, 1);

  for i = 1:numConcepts
    Ps(i) = mean(answers(concepts == i));
  end
  
  %make the predictor function that takes a test/validation vector each
  %of answers and concepts, and returns a vector of the same length
  %of predicted response probabilities
  function predictions = predictor(answers, concepts)
    l = length(answers);
    if length(concepts) ~= l
      error('Answer and concept lengths must match');
    end
    
    predictions = zeros(1,l);
    for i = 1:l
      if isnan(answers(i)) || isnan(concepts(i))
        predictions(i) = NaN;
      else
        predictions(i) = Ps(concepts(i));
      end
    end
  end

  %return the predictor function
  f = @predictor;


end

