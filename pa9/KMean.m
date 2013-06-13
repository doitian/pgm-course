function [Similarities, Cost] = KMean(dataset, K, maxIter, window)
  N = size(dataset, 1);

  #normalize
  numFeatures = prod(size(dataset)(2:end));
  dataset = reshape(dataset, N, numFeatures);
  dataset .-= repmat(mean(dataset), N, 1);
  dataset ./= repmat(std(dataset), N, 1);

  Centroids = zeros(K, numFeatures);
  Similarities = zeros(N, K);
  Assignments = floor(rand(N, 1) * K) + 1;

  for iter = 1:maxIter
    for k = 1:K
      Centroids(k, :) = mean(dataset(find(Assignments == k), :));
    end

    for i = 1:length(dataset)
      for k = 1:K
        a = dataset(i, :);
        c = Centroids(k, :);
        Similarities(i, k) = norm(a - c);
        ## Similarities(i, k) = Similarities(i, k) * Similarities(i, k);
      end
    end

    [minSim, Assignments] = min(Similarities, [], 2);
    Cost(iter) = sum(minSim);
    if iter > window && Cost(iter) == Cost(iter - window)
      break
    end
  end
end
