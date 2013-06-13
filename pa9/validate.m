load("PA9Data.mat")

[train, cv] = splitTrain(datasetTrain1);

for i = 1:length(train)
  Similarities = KMean(train(i).poseData, 3, 50, 5);
  [~, Assignments] = min(Similarities, [], 2);

  K = size(Similarities, 2);
  train(i).InitialClassProb = 1 ./ (Similarities .+ 0.00001);
  train(i).InitialClassProb ./= repmat(sum(train(i).InitialClassProb, 2), 1, K);

  train(i).InitialPairProb = zeros(size(train(i).InitialPairProb, 1), K * K);
  # Init pair class prob from sufficient statistics
  for l = 1:length(train(i).actionData)
    for p = 1:length(train(i).actionData(l).pair_ind)
      from = train(i).InitialClassProb(train(i).actionData(l).marg_ind(p), :);
      to = train(i).InitialClassProb(train(i).actionData(l).marg_ind(p + 1), :);
      train(i).InitialPairProb(train(i).actionData(l).pair_ind(p), :) = (from' * to)(:);
    end
  end
end

accuracy = RecognizeActions(train, cv, G, 10);

# 0.93333
# 0.95556

disp(sprintf('accuracy: %f', accuracy))
