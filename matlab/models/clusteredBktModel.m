function f = clusteredBktModel( answers, concepts )
%CLUSTEREDBKTMODEL Run BKT after clustering students by concepts seen

  if ~isequal(size(answers), size(concepts))
      error('Must provide concept labels array of same shape as answers array');
  end
  
  numStudents = size(answers,1);
  
  %this structure assumes the concepts are sequential 1...numConcepts
  %this must change if that assumption isn't valid for non-synthetic data!
  numConcepts = length(unique(concepts(~isnan(concepts))));
  
  
  conceptSeen = zeros(numStudents, numConcepts);
  %Generate indicator vectors for if student i has seen concept j (1 or 0)
  for i = 1:numStudents
    row = concepts(i,:);
    seenConcepts = unique(row(~isnan(row)));
    conceptSeen(i,seenConcepts) = 1;
  end
  
  %Cluster the students into 2 groups by concepts seen 
  %Could try to expand this to divide them into more than 2 clusters
  %if the data supports it
  
  %Replicates=10 means rerun 10 times and take the best to avoid local
  %minima; Display=off means don't print the intermediate runs.
  %Display=funal means do print the intermediate runs
  %opts = statset('Display','final');
  opts = statset('Display','off');
  numClusters = 2;
  [idx,C] = kmeans(conceptSeen,numClusters,'Replicates',10,'Options',opts);
  
  predictors = {};
  for i = 1:numClusters
    curAnswers = answers(idx == i,:);
    curConcepts = concepts(idx == i,:);
    predictors{end+1} = bktModel(curAnswers, curConcepts);
  end

  
  %make the predictor function that takes a test/validation vector each
  %of answers and concepts, and returns a vector of the same length
  %of predicted response probabilities
  function predictions = predictor(answers, concepts)
    l = length(answers);
    if length(concepts) ~= l
      error('Answer and concept lengths must match');
    end
    
    conceptsPresent = zeros(1,numConcepts);
    conceptIndicator = unique(concepts(~isnan(concepts)));
    conceptsPresent(conceptIndicator) = 1;
    clusterDists = pdist2(conceptsPresent,C);
    [m, i] = min(clusterDists);
    predictorFn = predictors{i};
    predictions = predictorFn(answers, concepts);
    
  end

  %return the predictor function
  f = @predictor;


end