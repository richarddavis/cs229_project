function f = naiveModel( answers, concepts )
%NAIVE Train a naive model on training sets of answers and concepts
%   Assume every concept just has a constant p(correct) - that
%   every answer is Bernoulli(pConcept)
%   returns a function that takes a trajectory of answers and a trajectory
%   of concepts (both 1 dimensional, same length)
%   and returns a list of the same length, which is the predicted
%   probabilities of a correct response at every position, given the 
%   previous responses up to that position


  x = 3;
  
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
      if isnan(answers(i)) | isnan(concepts(i))
        predictions(i) = NaN;
      else
        predictions(i) = 1.0 / x;
      end
    end
  end

  %return a function that always returns 1 - make this real!
  %f = @(a, c) 1;
  
  %return the predictor function
  f = @predictor;


end

