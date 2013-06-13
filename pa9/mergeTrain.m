# Merge two train datasets
function dataset = mergeTrain(a, b)
  for i = 1:length(a)
    dataset(i).InitialClassProb = [a(i).InitialClassProb; b(i).InitialClassProb];
    dataset(i).InitialPairProb = [a(i).InitialPairProb; b(i).InitialPairProb];
    dataset(i).poseData = [a(i).poseData; b(i).poseData];
    dataset(i).actionData = [a(i).actionData; b(i).actionData];
    poseOffset = size(a(i).poseData, 1);
    pairOffset = size(a(i).InitialPairProb, 1);

    for bi = (length(a(i).actionData) + 1):length(dataset(i).actionData)
      dataset(i).actionData(bi).marg_ind .+= poseOffset;
      dataset(i).actionData(bi).pair_ind .+= pairOffset;
    end
  end
end
