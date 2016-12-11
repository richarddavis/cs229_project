addpath('./data_sets/');
addpath('./models/');

%getXData() function returns [X,C,XV,CV] arrays of dimensions
%# students x max # of questions
%ONLY for training data!
%the validation sets XV and CV are a randomly selected ~10% from the 
%training data
%there should be separate getXTestData() functions for each data set,
%such that the training/test sets are always the same

data_set_names = {'Synthetic IRT', 'Random'};
data_set_fns = {@getSyntheticIrtData, @getRandomData};
num_data_sets = length(data_set_names);

answer_sets = {};
concept_sets = {};
validation_answer_sets = {};
validation_concept_sets = {};

for i = 1:num_data_sets
  data_fn = data_set_fns{i};
  [answers, concepts, validation_answers, validation_concepts] = data_fn();
  answer_sets{end + 1} = answers;
  concept_sets{end + 1} = concepts;
  validation_answer_sets{end + 1} = validation_answers;
  validation_concept_sets{end + 1} = validation_concepts;
end

%Functions to train a model take training arrays of answers and concepts, 
%return a function that takes an answer array and concept array 
%such that the concept array is one longer than the answer array,
%and returns a predicted probability that the next answer is a 1
training_fns = {@naiveBernoulliModel, @logisticRegressionModel, @bktModel, ...
  @alwaysOneModel, @alwaysHalfModel, @alwaysZeroModel};
model_names = {'Naive Bernoulli', 'Logistic Regression', 'BKT', ...
  'Always 1', 'Always 1/2', 'Always 0'};
num_models = length(training_fns);


for model_num = 1:num_models
  for data_set_num = 1:num_data_sets
    fprintf('Testing %s on %s\n', model_names{model_num}, data_set_names{data_set_num});
    fitting_fn = training_fns{model_num};
    answers = answer_sets{data_set_num};
    concepts = concept_sets{data_set_num};
    prediction_fn = fitting_fn(answers, concepts);
    validation_answers = validation_answer_sets{data_set_num};
    validation_concepts = validation_concept_sets{data_set_num};
    error_rate = testModel(prediction_fn, validation_answers, validation_concepts);
    fprintf('Error rate is %f (sqrt %f) \n\n', error_rate, sqrt(error_rate));
  end
end




