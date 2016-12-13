addpath('./data_sets/');
addpath('./models/');

%getXData() function returns [X,C,XV,CV] arrays of dimensions
%# students x max # of questions
%ONLY for training data!
%the validation sets XV and CV are a randomly selected ~10% from the 
%training data
%there should be separate getXTestData() functions for each data set,
%such that the training/test sets are always the same

data_set_names = {'Synthetic BKT', 'Synthetic IRT', 'KDD Sample Data', 'Assistments Data'};
data_set_fns = {@getSyntheticBKTData, @getSyntheticIrtData, @getKddSampleData, @getAssistmentsData};
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
training_fns = {@alwaysOneModel, @avgResponseModel, @naiveBernoulliModel, ...
  @logisticRegressionModel, @bktModel, ...
  @clusteredBktModel};
model_names = {'Always 1', 'Average Response', 'Naive Bernoulli', ...
  'Logistic Regression', 'BKT', ...
  'Clustered BKT'};
num_models = length(training_fns);

mses = zeros(num_models, num_data_sets);
error_rates = zeros(num_models, num_data_sets);
ROC_Xs = {};
ROC_Ys = {};
ROC_Ts = {};
ROC_AUCs = zeros(num_models, num_data_sets);

for model_num = 1:num_models
  for data_set_num = 1:num_data_sets
    fprintf('Testing %s on %s\n', model_names{model_num}, data_set_names{data_set_num});
    fitting_fn = training_fns{model_num};
    answers = answer_sets{data_set_num};
    concepts = concept_sets{data_set_num};
    prediction_fn = fitting_fn(answers, concepts);
    validation_answers = validation_answer_sets{data_set_num};
    validation_concepts = validation_concept_sets{data_set_num};
    [mse, error_rate, X, Y, T, AUC] = testModel(prediction_fn, ...
      validation_answers, validation_concepts);
    fprintf('MSE is %f (sqrt %f), error rate %f \n\n', ...
      mse, sqrt(mse), error_rate);
    
    mses(model_num, data_set_num) = mse;
    error_rates(model_num, data_set_num) = error_rate;
    ROC_Xs{model_num, data_set_num} = X;
    ROC_Ys{model_num, data_set_num} = Y;
    ROC_Ts{model_num, data_set_num} = T;
    ROC_AUCs(model_num, data_set_num) = AUC;
  end
end


%H=bar3(mses);
%hx=get(H(1),'parent'); % all bars have the same axes parent.
%Hty=get(hx,'yticklabel');
%set(Hty,'string',data_set_names);

