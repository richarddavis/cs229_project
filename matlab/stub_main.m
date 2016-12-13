addpath('./data_sets/');
addpath('./models');

data_set_names = {'KDD'};
data_set_fn = @getKddData;
num_data_sets = length(data_set_names);

%getXData() function returns [X,C,XV,CV] arrays of dimensions
%# students x max # of questions
%ONLY for training data!
%the validation sets XV and CV are a randomly selected ~10% from the 
%training data
%there should be separate getXTestData() functions for each data set,
%such that the training/test sets are always the same

[answers, concepts, answersValidation, conceptsValidation] = data_set_fn();
  
%Functions to train a model take training arrays of answers and concepts, 
%return a function that takes an answer array and concept array 
%such that the concept array is one longer than the answer array,
%and returns a predicted probability that the next answer is a 1
training_fns = {@logisticRegressionModel};
model_names = {'Logistic Regression'};
num_models = length(training_fns);

fn1 = training_fns{1};

fn2 = fn1(answers, concepts);

fn3 = @alwaysZeroModel;
fn4 = fn3(answers, concepts);

[mse, error_rate, X, Y, T, AUC] = testModel(fn2, answersValidation, conceptsValidation);
fprintf('Testing %s on %s\n', model_names{1}, data_set_names{1});
plot(X,Y);
fprintf('MSE is %f (sqrt %f), error rate %f , AUC %f\n\n', ...
  mse, sqrt(mse), error_rate, AUC);

[mse, error_rate, X, Y, T, AUC] = testModel(fn4, answersValidation, conceptsValidation);
fprintf('Testing alternate model on same data\n');
fprintf('MSE is %f (sqrt %f), error rate %f , AUC %f\n\n', ...
  mse, sqrt(mse), error_rate, AUC);