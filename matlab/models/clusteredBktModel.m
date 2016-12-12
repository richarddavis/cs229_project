function f = clusteredBktModel( answers, concepts )
%CLUSTEREDBKTMODEL Run BKT after clustering students by concepts seen

  if ~isequal(size(answers), size(concepts))
      error('Must provide concept labels array of same shape as answers array');
  end

  numStudents = size(answers,1);

  %this structure assumes the concepts are sequential 1...numConcepts
  %this must change if that assumption isn't valid for non-synthetic data!
  numConcepts = length(unique(concepts(~isnan(concepts))));


  avgScore = zeros(numStudents, 1);
  %Generate indicator vectors for if student i has seen concept j (1 or 0)
  for i = 1:numStudents
    row = answers(i,:);
    score = mean(row(~isnan(row)));
    avgScore(i) = score;
  end

  %Cluster the students into 2 groups by concepts seen
  %Could try to expand this to divide them into more than 2 clusters
  %if the data supports it
  
  numClusters = 2;

  %Replicates=10 means rerun 10 times and take the best to avoid local
  %minima; Display=off means don't print the intermediate runs.
  %Display=funal means do print the intermediate runs
  %opts = statset('Display','final');
  %opts = statset('Display','off');
  %[idx,C] = kmeans(avgScore,numClusters,'Replicates',10,'Options',opts);
  
  clusterCutoff = median(avgScore);
  %screw k means, let's just split by median
  idx = (avgScore > clusterCutoff) + 1;

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
    
    clusterPredictions = {};
    for i = 1:numClusters
      predictorFn = predictors{i};
      clusterPredictions{i} = predictorFn(answers, concepts);
    end
    predictionsLow  = clusterPredictions{1};
    predictionsHigh = clusterPredictions{2};

    %start numerator and denominator of %correct at 1/2 for smoothing
    numCorrect = 1;
    numAnswered = 2;
    predictionSequence = zeros(l);
    for j = 1:l
      curAnswer = answers(j);
      if isnan(curAnswer)
        break
      end
      curScore = numCorrect / numAnswered;
      
      if curScore > clusterCutoff
        predictionSequence(j) = predictionsHigh(j);
      else
        predictionSequence(j) = predictionsLow(j);
      end
      
      
      numCorrect = numCorrect + curAnswer;
      numAnswered = numAnswered + 1;
    end
    
    predictions = predictionSequence;
  end

  %return the predictor function
  f = @predictor;


end
