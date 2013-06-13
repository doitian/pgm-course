% File: RecognizeActions.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [accuracy, predicted_labels] = RecognizeActions(datasetTrain, datasetTest, G, maxIter)

% INPUTS
% datasetTrain: dataset for training models, see PA for details
% datasetTest: dataset for testing models, see PA for details
% G: graph parameterization as explained in PA decription
% maxIter: max number of iterations to run for EM

% OUTPUTS
% accuracy: recognition accuracy, defined as (#correctly classified examples / #total examples)
% predicted_labels: N x 1 vector with the predicted labels for each of the instances in datasetTest, with N being the number of unknown test instances


% Train a model for each action
% Note that all actions share the same graph parameterization and number of max iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numActionTypes = length(datasetTrain);
for i = 1:numActionTypes
  P(i) = EM_HMM(datasetTrain(i).actionData, ...
                datasetTrain(i).poseData, ...
                G, ...
                datasetTrain(i).InitialClassProb, ...
                datasetTrain(i).InitialPairProb, ...
                maxIter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Classify each of the instances in datasetTrain
% Compute and return the predicted labels and accuracy
% Accuracy is defined as (#correctly classified examples / #total examples)
% Note that all actions share the same graph parameterization

accuracy = 0;
predicted_labels = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = size(datasetTest.poseData, 1);
L = size(datasetTest.actionData, 2); % number of actions
K = length(P(1).c);
loglikelihoods = zeros(L, numActionTypes);

for ka = 1:numActionTypes
  sigma = permute(reshape([P(ka).clg.sigma_y, P(ka).clg.sigma_x, P(ka).clg.sigma_angle], K, size(G, 1), 3), [2, 3, 1]);
  mu = zeros(size(sigma));
  for p = find(~G(:, 1))'
    mu(p, 1, :) = P(ka).clg(p).mu_y;
    mu(p, 2, :) = P(ka).clg(p).mu_x;
    mu(p, 3, :) = P(ka).clg(p).mu_angle;
  end

  partsWithParent = find(G(:, 1));

  logEmissionProb = zeros(N,K);

  for i = 1:N
    example = repmat(squeeze(datasetTest.poseData(i, :, :)), [1, 1, K]);

    for p = partsWithParent'
      for k = 1:K
        theta = reshape(P(ka).clg(p).theta(k, :), 4, 3);
        parentIndex = G(p, 2);
        parent = example(parentIndex, :, k);
        mu(p, :, k) = [1, parent] * theta;
      end
    end

    logP = arrayfun(@lognormpdf, example, mu, sigma);
    logP = squeeze(sum(sum(logP, 1), 2));

    logEmissionProb(i, :) = logP';
  end

  for l = 1:L
    a = datasetTest.actionData(l);
    F = repmat(struct("var", [], "card", [], "val", []), length(a.marg_ind) + length(a.pair_ind) + 1, 1);

    # Prior
    F(1) = struct("var", [1], "card", [K], "val", log(P(ka).c));

    # Emission
    for i = 1:length(a.marg_ind)
      F(i + 1) = struct("var", [i], "card", [K], "val", logEmissionProb(a.marg_ind(i), :));
    end

    for i = 1:length(a.pair_ind)
      F(i + 1 + length(a.marg_ind)) = struct("var", [i, i + 1], "card", [K, K], "val", log(P(ka).transMatrix(:)'));
    end

    [~, PCalibrated] = ComputeExactMarginalsHMM(F);

    loglikelihoods(l, ka) = logsumexp(PCalibrated.cliqueList(1).val);
  end
end

[~, predicted_labels] = max(loglikelihoods, [], 2);
accuracy = mean(double(datasetTest.labels == predicted_labels));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
