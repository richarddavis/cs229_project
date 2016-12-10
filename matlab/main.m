data_set_names = ['synthetic', 'kdd_cup', 'assistments'];
num_data_sets = length(data_set_names);

%getXData() function returns [X,C,XV,CV] arrays of dimensions
%# students x max # of questions
%ONLY for training data!
%the validation sets XV and CV are a randomly selected ~10% from the 
%training data
%there should be separate getXTestData() functions for each data set,
%such that the training/test sets are always the same

[syntheticAnswers, syntheticConcepts, syntheticAnswersValidation, 
    syntheticConceptsValidation] = getSyntheticData();
[kddAnswers, kddConcepts, kddAnswersValidation, 
    kddConceptsValidation] = getKddData();
[assistmentsAnswers, assistmentsConcepts, assistmentsAnswersValidation, 
    assistemntsConceptsValidation] = getAssistmentsData();

answer_sets = {syntheticAnswers, kddAnswers, assistmentsAnswers};
concept_sets = {syntheticConcepts, kddConcepts, assistmentsConcepts};

validation_answer_sets = {syntheticAnswersValidation, kddAnswersValidation,
  assistmentsAnswersValidation};
validation_concept_sets = {syntheticConceptsValidation, kddConceptsValidation,
  assistemntsConceptsValidation};

%Functions to train a model take training arrays of answers and concepts, 
%return a function that takes an answer array and concept array 
%such that the concept array is one longer than the answer array,
%and returns a predicted probability that the next answer is a 1
training_fns = {@train_naive, @train_bkt, @train_kalman};
model_names = ['Naive', 'BKT', 'Kalman'];
num_models = length(training_fns);

function avg_error = testModel(f, a, c)
  S, M = size(a);
  if ~isequal(size(a), size(c))
      error('Must provide concept labels array of same shape as answers array');
  end
  
  numPredictions = 0;
  totalSquaredError = 0.0;
  
  for i = 1:S
    for j = 1:M-1
      if a(i,j) == NaN
        break;
      end
      prediction = f(a(i, 1:j), c(i, 1:j+1));
      totalSquaredError = totalSquaredError + (a(i,j+1) - prediction)**2;
      numPredictions = numPredictions + 1;
    end
  end

  avg_error = totalSquaredError / numPredictions;
end

for model_num = 1:num_models
  for data_set_num = 1:num_data_sets
    fprintf('Testing %s on %s', model_names(model_num), data_set_names(data_set_num));
    fitting_fn = training_fns(model_num);
    answers = answer_sets(data_set_num);
    concepts = concept_sets(data_set_num);
    prediction_fn = fitting_fn(answers, concepts);
    error_rate = testModel(prediction_fn, validationAnswers, validationConcepts);
    fprintf('Error rate is %f', error_rate);
  end
end




