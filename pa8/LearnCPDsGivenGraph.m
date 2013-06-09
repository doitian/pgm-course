function [P loglikelihood] = LearnCPDsGivenGraph(dataset, G, labels)
%
% Inputs:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% G: graph parameterization as explained in PA description
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j and 0 elsewhere        
%
% Outputs:
% P: struct array parameters (explained in PA description)
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
K = size(labels,2);

loglikelihood = 0;
P.c = zeros(1,K);

% estimate parameters
% fill in P.c, MLE for class probabilities
% fill in P.clg for each body part and each class
% choose the right parameterization based on G(i,1)
% compute the likelihood - you may want to use ComputeLogLikelihood.m
% you just implemented.
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ndims(G) == 2
  G = repmat(G, [1, 1, K]);
end

numParts = size(G, 1);
P.c = mean(labels);
P.clg = repmat(struct(), 1, numParts);

for p = 1:numParts
  for k = 1:K
    exampleIndex = find(labels(:, k));
    classDataset = squeeze(dataset(exampleIndex, p, :));

    if G(p, 1, k) == 0 # Gaussian
      [P.clg(p).mu_y(k), P.clg(p).sigma_y(k)] = FitGaussianParameters(classDataset(:, 1));
      [P.clg(p).mu_x(k), P.clg(p).sigma_x(k)] = FitGaussianParameters(classDataset(:, 2));
      [P.clg(p).mu_angle(k), P.clg(p).sigma_angle(k)] = FitGaussianParameters(classDataset(:, 3));
    else # CLG
      parent = squeeze(dataset(exampleIndex, G(p, 2, k), :));

      [Beta1, P.clg(p).sigma_y(k)] = FitLinearGaussianParameters(classDataset(:, 1), parent);
      [Beta2, P.clg(p).sigma_x(k)] = FitLinearGaussianParameters(classDataset(:, 2), parent);
      [Beta3, P.clg(p).sigma_angle(k)] = FitLinearGaussianParameters(classDataset(:, 3), parent);

      P.clg(p).theta(k, :) = [Beta1(end), Beta1(1:3)', Beta2(end), Beta2(1:3)', Beta3(end), Beta3(1:3)'];
    end
  end
end

loglikelihood = ComputeLogLikelihood(P, G, dataset);
fprintf('log likelihood: %f\n', loglikelihood);
