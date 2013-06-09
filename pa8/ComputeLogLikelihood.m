function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes

loglikelihood = 0;

% You should compute the log likelihood of data as in eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(size(G)) == 2
  G = repmat(G, [1, 1, K]);
end

numParts = size(G, 1);

for i = 1:N
  exampleP = 0;
  example = squeeze(dataset(i, :, :));

  for k = 1:K
    logP = 0;

    for o = 1:numParts;
      O = example(o, :);
      clg = P.clg(o);

      if G(o, 1, k) == 0
        logP += lognormpdf(O(1), clg.mu_y(k), clg.sigma_y(k));
        logP += lognormpdf(O(2), clg.mu_x(k), clg.sigma_x(k));
        logP += lognormpdf(O(3), clg.mu_angle(k), clg.sigma_angle(k));
      else
        parent = [1, example(G(o, 2, k), :)];
        theta = reshape(clg.theta(k, :), 4, 3);
        logP += lognormpdf(O(1), parent * theta(:, 1), clg.sigma_y(k));
        logP += lognormpdf(O(2), parent * theta(:, 2), clg.sigma_x(k));
        logP += lognormpdf(O(3), parent * theta(:, 3), clg.sigma_angle(k));
      end
    end

    exampleP += P.c(k) * exp(logP);
  end

  loglikelihood += log(exampleP);
end
