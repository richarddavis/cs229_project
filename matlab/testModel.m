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
  
  for i = 1:S
    for j = 1:M-1
      if isnan(a(i,j))
        break;
      end
      prediction = f(a(i, 1:j), c(i, 1:j+1));
      if ~(prediction >= 0 & prediction <= 1)
        error('Prediction (chance of correct) must be between 0 and 1');
      end
      totalSquaredError = totalSquaredError + (a(i,j+1) - prediction)^2;
      numPredictions = numPredictions + 1;
    end
  end

  avg_error = totalSquaredError / numPredictions;
end