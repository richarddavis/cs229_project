function f = naiveModel( answers, concepts )
%NAIVE Train a naive model on training sets of answers and concepts
%   Assume every concept just has a constant p(correct) - that
%   every answer is Bernoulli(pConcept)
%   returns a function that takes a trajectory of answers and a trajectory
%   of concepts (both 1 dimensional, concepts 1 longer than answers)
%   and predicts the next answer, which will correspond to the last concept
%   in the list of concepts


%return a function that always returns 1 - make this real!
f = @(a, c) 1;




end

