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

sigma = permute(reshape([P.clg.sigma_y, P.clg.sigma_x, P.clg.sigma_angle], 2, 10, 3), [2, 3, 1]);

# Only parts only having class variable as parent have predefined mu. Other
# parts must calculate based on there parent parts.
mu = zeros(size(sigma));
[I, J] = find(~squeeze(G(:, 1, :)));
for u = 1:length(I)
  mu(I(u), 1, J(u)) = P.clg(I(u)).mu_y(J(u));
  mu(I(u), 2, J(u)) = P.clg(I(u)).mu_x(J(u));
  mu(I(u), 3, J(u)) = P.clg(I(u)).mu_angle(J(u));
end

[I, J] = find(squeeze(G(:, 1, :)));

for i = 1:N
  example = repmat(squeeze(dataset(i, :, :)), [1, 1, K]);

  for u = 1:length(I)
    theta = reshape(P.clg(I(u)).theta(J(u), :), 4, 3);
    parentIndex = G(I(u), 2, J(u));
    parent = example(parentIndex, :, J(u));
    mu(I(u), :, J(u)) = [1, parent] * theta;
  end

  logP = arrayfun(@lognormpdf, example, mu, sigma);
  logP = squeeze(sum(sum(logP, 1), 2));

  loglikelihood += log(P.c * exp(logP));
end
