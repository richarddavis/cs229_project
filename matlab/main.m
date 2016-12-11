addpath('./data_sets/');
addpath('./models/');

data_set_names = {'syntheticIRT', 'kdd_cup', 'assistments'};
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
[kddAnswers, kddConcepts, kddAnswersValidation, ...
    kddConceptsValidation] = getKddData();
[assistmentsAnswers, assistmentsConcepts, assistmentsAnswersValidation, ...
    assistemntsConceptsValidation] = getAssistmentsData();

answer_sets = {syntheticAnswers, kddAnswers, assistmentsAnswers};
concept_sets = {syntheticConcepts, kddConcepts, assistmentsConcepts};

validation_answer_sets = {syntheticAnswersValidation, ...
  kddAnswersValidation, assistmentsAnswersValidation};
validation_concept_sets = {syntheticConceptsValidation, ...
  kddConceptsValidation, assistemntsConceptsValidation};

%Functions to train a model take training arrays of answers and concepts, 
%return a function that takes an answer array and concept array 
%such that the concept array is one longer than the answer array,
%and returns a predicted probability that the next answer is a 1
training_fns = {@naiveModel, @bktModel, @clusteredBktModel};
model_names = {'Naive', 'BKT', 'Clustered BKT'};
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
    fprintf('Error rate is %f\n\n', error_rate);
  end
end




