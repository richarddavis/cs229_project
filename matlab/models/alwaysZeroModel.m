function f = alwaysZeroModel( answers, concepts )
%alwaysZeroModel Always guess p(correct) = 0

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
        predictions(i) = 0;
      end
    end
  end

  %return the predictor function
  f = @predictor;


end