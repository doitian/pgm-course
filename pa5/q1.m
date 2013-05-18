[G, F] = ConstructRandNetwork(.3, .7);
clusterGraph = CreateClusterGraph(F, []);
[P M D] = ClusterGraphCalibrate2(clusterGraph);

figure; hold on;

plot(log(D(19,3).hist), "-r;19->3;")
plot(log(D(15,40).hist), "-g;15->40;")
plot(log(D(17,2).hist), "-b;17->2;")

hold off
