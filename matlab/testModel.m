function avg_error = testModel(f, a, c)
%TESTMODEL Given a model's predictor function and a validation set, find
%   the error rate
%   Takes predictor function for a model and validation sets of answers
%   and corresponding concepts; finds how often the model mispredicts the 
%   answer

  [S, M] = size(a);
  if ~isequal(size(a), size(c))
      error('Must provide concept labels array of same shape as answers array');
  end
  
  numPredictions = 0;
  totalSquaredError = 0.0;
  
  %TODO: fix this so it works with vector-wise predictor functions 
  
  for i = 1:S
    predictions = f(a(i, :), c(i, :));
    for j = 1:M
      if isnan(a(i,j)) || isnan(predictions(j))
        break;
      end
      prediction = predictions(j);
      if ~(prediction >= 0 && prediction <= 1)
        error('Prediction (chance of correct) must be between 0 and 1');
      end
      totalSquaredError = totalSquaredError + (a(i,j) - prediction)^2;
      numPredictions = numPredictions + 1;
    end
  end

  avg_error = totalSquaredError / numPredictions;
end