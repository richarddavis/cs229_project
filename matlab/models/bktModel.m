function f = bktModel( answers, concepts )
%BKTMODEL Train a BKT model on training sets of answers and concepts
%   This is fake - replace with real code!
%   returns a function that takes a trajectory of answers and a trajectory
%   of concepts (both 1 dimensional, same length)
%   and returns a list of the same length, which is the predicted
%   probabilities of a correct response at every position, given the 
%   previous responses up to that position
    
  if ~isequal(size(answers), size(concepts))
      error('Must provide concept labels array of same shape as answers array');
  end
  
  numStudents = size(answers, 1);
  
  %this structure assumes the concepts are sequential 1...numConcepts
  %this must change if that assumption isn't valid for non-synthetic data!
  numConcepts = length(unique(concepts(~isnan(concepts))));
  
  % First guess at transition and emission probabilties
  trans_guess = [0.8,0.2; 
          0,1];
  emit_guess = [0.6, 0.4; 
          0.4, 0.6];
  
  trans_probs = {};
  emit_probs = {};
  prior_probs = {};
  for c = 1:numConcepts
    
    % This is broken
    % Find prior probability of output at first index
    % firstAnswers = answers(:,1);
    % mean(firstAnswers(concepts(:,1) == c))
    
    % This is an uglier, slow fix but it works. Try to speed this up.
    initial_answers = 0;
    initial_answer_count = 0;
    for row = 1:size(concepts, 1)
        crow = concepts(row,:);
        arow = answers(row,:);
        first_ind = find(crow==c,1);
        if isempty(first_ind)
            continue
        end
        initial_answers = initial_answers + arow(:,find(crow==c,1));
        initial_answer_count = initial_answer_count + 1;
    end    

    prior_probs{end + 1} = initial_answers/initial_answer_count;
    
    curOutputs = {};
    for s = 1:numStudents
      fullRow = answers(s,:);
      curSeq = fullRow(concepts(s,:) == c) + 1;
      if length(curSeq > 0)
        curOutputs{end + 1} = curSeq;
      end
    end
    
    % Learn transition and emission probs per concept
    [est_trans,est_emit] = hmmtrain(curOutputs,trans_guess,emit_guess,'Tolerance',1e-4);
    trans_probs{end + 1} = est_trans;
    emit_probs{end + 1} = est_emit;
  end
  
  %make the predictor function that takes a test/validation vector each
  %of answers and concepts, and returns a vector of the same length
  %of predicted response probabilities
  function predictions = predictor(answers, concepts)
    l = size(answers,1);
    if size(concepts,1) ~= l
      error('Answer and concept lengths must match');
    end
    
    predictions = zeros(1,l);
    
    for i = 1:numConcepts
      conceptIndices = find(concepts == i);
      %if no answers of concept i in this sequence, skip to i+1
      if isempty(conceptIndices)
        continue
      end
      firstIndex = conceptIndices(1);
      predictions(firstIndex) = prior_probs{i};
      conceptSequence = answers(conceptIndices);
      %HMM state posterior probabilities by-index
      %Hard coded to assume 2 states, 2 possible emissions!
      state_ps = hmmdecode(conceptSequence + 1, trans_probs{i}, emit_probs{i});
      for j = 2:length(conceptSequence)
        cur_state_ps = state_ps(:,j-1);
        emit_posterior = emit_probs{i}' * cur_state_ps;
        predictions(conceptIndices(j)) = emit_posterior(2);
      end
    end
  end

  %return the predictor function
  f = @predictor;

end