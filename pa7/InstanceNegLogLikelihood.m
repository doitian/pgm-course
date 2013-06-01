% function [nll, grad] = InstanceNegLogLikelihood(X, y, theta, modelParams)
% returns the negative log-likelihood and its gradient, given a CRF with parameters theta,
% on data (X, y). 
%
% Inputs:
% X            Data.                           (numCharacters x numImageFeatures matrix)
%              X(:,1) is all ones, i.e., it encodes the intercept/bias term.
% y            Data labels.                    (numCharacters x 1 vector)
% theta        CRF weights/parameters.         (numParams x 1 vector)
%              These are shared among the various singleton / pairwise features.
% modelParams  Struct with three fields:
%   .numHiddenStates     in our case, set to 26 (26 possible characters)
%   .numObservedStates   in our case, set to 2  (each pixel is either on or off)
%   .lambda              the regularization parameter lambda
%
% Outputs:
% nll          Negative log-likelihood of the data.    (scalar)
% grad         Gradient of nll with respect to theta   (numParams x 1 vector)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [nll, grad] = InstanceNegLogLikelihood(X, y, theta, modelParams)

    % featureSet is a struct with two fields:
    %    .numParams - the number of parameters in the CRF (this is not numImageFeatures
    %                 nor numFeatures, because of parameter sharing)
    %    .features  - an array comprising the features in the CRF.
    %
    % Each feature is a binary indicator variable, represented by a struct 
    % with three fields:
    %    .var          - a vector containing the variables in the scope of this feature
    %    .assignment   - the assignment that this indicator variable corresponds to
    %    .paramIdx     - the index in theta that this feature corresponds to
    %
    % For example, if we have:
    %   
    %   feature = struct('var', [2 3], 'assignment', [5 6], 'paramIdx', 8);
    %
    % then feature is an indicator function over X_2 and X_3, which takes on a value of 1
    % if X_2 = 5 and X_3 = 6 (which would be 'e' and 'f'), and 0 otherwise. 
    % Its contribution to the log-likelihood would be theta(8) if it's 1, and 0 otherwise.
    %
    % If you're interested in the implementation details of CRFs, 
    % feel free to read through GenerateAllFeatures.m and the functions it calls!
    % For the purposes of this assignment, though, you don't
    % have to understand how this code works. (It's complicated.)
    
    featureSet = GenerateAllFeatures(X, modelParams);

    % Use the featureSet to calculate nll and grad.
    % This is the main part of the assignment, and it is very tricky - be careful!
    % You might want to code up your own numerical gradient checker to make sure
    % your answers are correct.
    %
    % Hint: you can use CliqueTreeCalibrate to calculate logZ effectively. 
    %       We have halfway-modified CliqueTreeCalibrate; complete our implementation 
    %       if you want to use it to compute logZ.
    
    nll = 0;
    grad = zeros(size(theta));
    %%%
    % Your code here:

    numFeatures = length(featureSet.features);
    numVar = size(X, 1);

    # - singleton factor first 1:M
    singletonFactors = repmat(EmptyFactorStruct(), 1, numVar);
    for i = 1:numVar
      singletonFactors(i).var = [i];
      singletonFactors(i).card = [modelParams.numHiddenStates];
      singletonFactors(i).val = ones(1, modelParams.numHiddenStates);
    end

    # - then pair factor: (1,2), (2,3), ..., (M-1, M)
    pairFactors = repmat(EmptyFactorStruct(), 1, numVar - 1);
    for i = 1:(numVar - 1)
      pairFactors(i).var = [i, i + 1];
      pairFactors(i).card = [modelParams.numHiddenStates, modelParams.numHiddenStates];
      pairFactors(i).val = ones(1, modelParams.numHiddenStates * modelParams.numHiddenStates);
    end

    for i = 1:length(featureSet.features)
      feature = featureSet.features(i);
      if length(feature.var) == 1
        factorIdx = feature.var(1);
        singletonFactors(factorIdx).val(feature.assignment(1)) *= exp(theta(feature.paramIdx));
      else
        [sorted, sortedIdx] = sort(feature.var);
        factorIdx = sorted(1);
        assignment = feature.assignment(sortedIdx);

        assert(length(feature.var), 2)
        assert(sorted(2) - sorted(1), 1)

        valIdx = sub2ind(pairFactors(factorIdx).card, ...
                         assignment(1), assignment(2));
        pairFactors(factorIdx).val(valIdx) *= exp(theta(feature.paramIdx));
      end
    end

    factors = [singletonFactors, pairFactors];

    CliqueTree = CreateCliqueTree(factors);
    [CliqueTree, logZ] = CliqueTreeCalibrate(CliqueTree, 0);

    weightedFeatureCounts = zeros(1, length(theta));
    for i = 1:numFeatures
      feature = featureSet.features(i);
      if feature.assignment == y(feature.var)
        weightedFeatureCounts(feature.paramIdx) += theta(feature.paramIdx);
      end
    end

    theta = theta(:);
    regularization = 0.5 * modelParams.lambda * (theta' * theta);

    nll = logZ - sum(weightedFeatureCounts) + regularization;
end
