function f = avgResponseModel( A, C )
%AVGRESPONSEMODEL ...

  if ~isequal(size(A), size(C))
      error('Must provide concept labels array of same shape as answers array');
  end
  
  %this structure assumes the concepts are sequential 1...numConcepts
  %this must change if that assumption isn't valid for non-synthetic data!
  numConcepts = length(unique(C(~isnan(C))));  

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
      
      numQuestions = length(conceptIndices);
      
      tempRunningAvg = 0;
      for c = 1:numQuestions
        answer = answers(conceptIndices(c));
        tempRunningAvg = tempRunningAvg + (answer/numQuestions);
        predictions(1, conceptIndices(c)) = tempRunningAvg;
      end
    end
  end

  %return the predictor function
  f = @predictor;

end
