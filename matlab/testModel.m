function [mse, errorRate, X, Y, T, AUC] = testModel(f, a, c)
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
  
  %for MSE metric
  totalSquaredError = 0.0;
  
  %for "% misclassified metric"
  totalErrors = 0;
  
  fullPredictions = [];
  labels = [];
  
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
      
      if round(prediction) ~= a(i,j)
        totalErrors = totalErrors + 1;
      end
      
      totalSquaredError = totalSquaredError + (a(i,j) - prediction)^2;
      fullPredictions = [fullPredictions prediction];
      labels = [labels a(i,j)];
      
      numPredictions = numPredictions + 1;
    end
  end
  
  mse = totalSquaredError / numPredictions;
  errorRate = totalErrors / numPredictions;
  [X,Y,T,AUC] = perfcurve(labels,fullPredictions,1);
end