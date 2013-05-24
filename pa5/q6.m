function q6(tran, N)

## trans = {"Gibbs", "MHUniform", "MHSwendsenWang1", "MHSwendsenWang2"};

[G, F] = ConstructToyNetwork(0.5, 0.5);
ExM = ComputeExactMarginalsBP(F, [], 0);

randi('seed', 1)

for i = 1:2
  [M all_samples] = MCMCInference(G, F, [], tran, 1, N, 1, repmat(i, 1, 16));
  samples_list{i} = all_samples;
end

window_size = floor(N / 8);
if mod(window_size, 2) == 1
  window_size -= 1;
end

VisualizeMCMCMarginals(samples_list, 1:length(G.names), G.card, F, window_size, ExM, tran)
