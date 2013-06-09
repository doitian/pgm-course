function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
accuracy = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = size(labels, 2);
if ndims(G) == 2
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

predications = zeros(size(labels));

for i = 1:N
  prob = zeros(K, 1);

  example = repmat(squeeze(dataset(i, :, :)), [1, 1, K]);

  for u = 1:length(I)
    theta = reshape(P.clg(I(u)).theta(J(u), :), 4, 3);
    parentIndex = G(I(u), 2, J(u));
    parent = example(parentIndex, :, J(u));
    mu(I(u), :, J(u)) = [1, parent] * theta;
  end

  logP = arrayfun(@lognormpdf, example, mu, sigma);
  logP = squeeze(sum(sum(logP, 1), 2));

  [~, label] = max(logP);
  predications(i, label) = 1;
end

accuracy = mean(double(all(predications == labels, 2)))

fprintf('Accuracy: %.2f\n', accuracy);
