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
  [idx,C] = kmeans(conceptSeen,2,'Replicates',10,'Options',opts);

  answers1 = answers(idx == 1,:);
  concepts1 = concepts(idx == 1,:);
  answers2 = answers(idx == 2,:);
  concepts2 = concepts(idx == 2,:);

  %train a BKT predictor function for each cluster
  predictor1 = bktModel(answers1, concepts1);
  predictor2 = bktModel(answers2, concepts2);

  predictors = {predictor1, predictor2};

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


    %predictions = zeros(1,l);
    %for i = 1:l
    %  if isnan(answers(i)) || isnan(concepts(i))
    %    predictions(i) = NaN;
    %  else
    %    predictions(i) = 1.0;
    %  end
    %end
  end

  %return the predictor function
  f = @predictor;


end
