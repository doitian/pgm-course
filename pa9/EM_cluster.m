% File: EM_cluster.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb] = EM_cluster(poseData, G, InitialClassProb, maxIter)

% INPUTS
% poseData: N x 10 x 3 matrix, where N is number of poses;
%   poseData(i,:,:) yields the 10x3 matrix for pose i.
% G: graph parameterization as explained in PA8
% InitialClassProb: N x K, initial allocation of the N poses to the K
%   classes. InitialClassProb(i,j) is the probability that example i belongs
%   to class j
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K, conditional class probability of the N examples to the
%   K classes in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to class j

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);

ClassProb = InitialClassProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  %
  % Fill in P.c with the estimates for prior class probabilities
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  %
  % Hint: This part should be similar to your work from PA8
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  P.c = mean(ClassProb);
  for p = 1:size(G, 1)
    for k = 1:K
      weights = ClassProb(:, k);
      if G(p, 1) == 0 # Gaussian
        [P.clg(p).mu_y(k), P.clg(p).sigma_y(k)] = FitG(poseData(:, p, 1), weights);
        [P.clg(p).mu_x(k), P.clg(p).sigma_x(k)] = FitG(poseData(:, p, 2), weights);
        [P.clg(p).mu_angle(k), P.clg(p).sigma_angle(k)] = FitG(poseData(:, p, 3), weights);
      else # CLG
        parent = squeeze(poseData(:, G(p, 2), :));
        [Beta1, P.clg(p).sigma_y(k)] = FitLG(poseData(:, p, 1), parent, weights);
        [Beta2, P.clg(p).sigma_x(k)] = FitLG(poseData(:, p, 2), parent, weights);
        [Beta3, P.clg(p).sigma_angle(k)] = FitLG(poseData(:, p, 3), parent, weights);

        P.clg(p).theta(k, :) = [Beta1(end), Beta1(1:3)', Beta2(end), Beta2(1:3)', Beta3(end), Beta3(1:3)'];
      end
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % E-STEP to re-estimate ClassProb using the new parameters
  %
  % Update ClassProb with the new conditional class probabilities.
  % Recall that ClassProb(i,j) is the probability that example i belongs to
  % class j.
  %
  % You should compute everything in log space, and only convert to
  % probability space at the end.
  %
  % Tip: To make things faster, try to reduce the number of calls to
  % lognormpdf, and inline the function (i.e., copy the lognormpdf code
  % into this file)
  %
  % Hint: You should use the logsumexp() function here to do
  % probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  sigma = permute(reshape([P.clg.sigma_y, P.clg.sigma_x, P.clg.sigma_angle], K, size(G, 1), 3), [2, 3, 1]);
  mu = zeros(size(sigma));
  for p = find(~G(:, 1))'
    mu(p, 1, :) = P.clg(p).mu_y;
    mu(p, 2, :) = P.clg(p).mu_x;
    mu(p, 3, :) = P.clg(p).mu_angle;
  end

  partsWithParent = find(G(:, 1));

  loglikelihood(iter) = 0;

  for i = 1:N
    example = repmat(squeeze(poseData(i, :, :)), [1, 1, K]);

    for p = partsWithParent'
      for k = 1:K
        theta = reshape(P.clg(p).theta(k, :), 4, 3);
        parentIndex = G(p, 2);
        parent = example(parentIndex, :, k);
        mu(p, :, k) = [1, parent] * theta;
      end
    end

    logP = arrayfun(@lognormpdf, example, mu, sigma);
    logP = squeeze(sum(sum(logP, 1), 2));

    ClassProb(i, :) = logP' + log(P.c);
  end

  # Convert from log space
  sumClassProb = logsumexp(ClassProb);
  ClassProb = exp(ClassProb - repmat(sumClassProb, 1, K));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Compute log likelihood of dataset for this iteration
  % Hint: You should use the logsumexp() function here
  % loglikelihood(iter) = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  loglikelihood(iter) = sum(sumClassProb');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting: when loglikelihood decreases
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
