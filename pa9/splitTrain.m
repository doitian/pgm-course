# Split train dataset into train set and validation set
function [train, cv] = splitTrain(dataset)
  train = dataset;
  cv.labels = [];
  cvClassOffset = 0;
  cvPairOffset = 0;

  for i = 1:length(train)
    numActions = length(train(i).actionData);
    actionOffset = ceil(numActions / 2);
    classOffset = max([train(i).actionData(1:actionOffset).marg_ind]);
    pairOffset = max([train(i).actionData(1:actionOffset).pair_ind]);
    numPosesInCV = length(train(i).poseData) - classOffset;

    for j = actionOffset+1:numActions
      cv.actionData(end + 1) = train(i).actionData(j);
      cv.actionData(end).marg_ind += cvClassOffset - classOffset;
      cv.actionData(end).pair_ind += cvPairOffset - pairOffset;
      cv.labels(end + 1) = i;
    end
    cv.poseData(end + 1:end + numPosesInCV, :, :) = train(i).poseData(classOffset + 1:end, :, :);
    cvClassOffset = length(cv.poseData);
    cvPairOffset += length(train(i).InitialPairProb) - pairOffset;

    train(i).actionData = train(i).actionData(1:actionOffset);
    train(i).poseData = train(i).poseData(1:classOffset, :, :);
    train(i).InitialClassProb = train(i).InitialClassProb(1:classOffset, :);
    train(i).InitialPairProb = train(i).InitialPairProb(1:pairOffset, :);
  end

  cv.labels = cv.labels';
end
