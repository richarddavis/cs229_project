addpath('./data_sets/');
data_set_names = ['syntheticIRT'];
num_data_sets = length(data_set_names);

%getXData() function returns [X,C,XV,CV] arrays of dimensions
%# students x max # of questions
%ONLY for training data!
%the validation sets XV and CV are a randomly selected ~10% from the 
%training data
%there should be separate getXTestData() functions for each data set,
%such that the training/test sets are always the same

[syntheticAnswers, syntheticConcepts, syntheticAnswersValidation, ...
    syntheticConceptsValidation] = getSyntheticIrtData();
  
%Functions to train a model take training arrays of answers and concepts, 
%return a function that takes an answer array and concept array 
%such that the concept array is one longer than the answer array,
%and returns a predicted probability that the next answer is a 1
training_fns = {@naiveBernoulliModel};
model_names = ['NaiveBernoulli'];
num_models = length(training_fns);

fn1 = training_fns{1};

fn2 = fn1(syntheticAnswers, syntheticConcepts);
testModel(fn2, syntheticAnswersValidation, syntheticConceptsValidation)