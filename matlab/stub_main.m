addpath('./data_sets/');
addpath('./models');

data_set_names = {'KDD'};
data_set_fn = @getAssistmentsData;
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
training_fns = {@avgResponseModel};
model_names = {'Average Response'};
num_models = length(training_fns);

fn1 = training_fns{1};

fn2 = fn1(answers, concepts);

error_rate = testModel(fn2, answersValidation, conceptsValidation);
fprintf('Testing %s on %s\n', model_names{1}, data_set_names{1});
fprintf('Error rate is %f (sqrt %f) \n\n', error_rate, sqrt(error_rate));