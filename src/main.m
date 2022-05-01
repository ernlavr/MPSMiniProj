%% Variables
path_bridgeWithTruss = '../res/simpleBridge/bridge.stl';
path_bridgeNoTruss = '../res/simpleBridgeNoSupports/bridgeNoSupports.stl';
E = 190e9
nu = 0.28
weight = 9806 % 10 tons
solvers = []

%% Create objects
withTruss = FeaWrapper(path_bridgeWithTruss, [76, 78], [80]);
withoutTruss= FeaWrapper(path_bridgeNoTruss, [69, 60], [73]);

%% Visualize
withTruss.visGeo('With Truss');
withoutTruss.visGeo('Without Truss');

%% Perform Computing With Truss
withTruss = withTruss.solve(E, nu, weight);
withTruss.visualizeOutput();

%% Compute Without Truss
withoutTruss = withoutTruss.solve(E, nu, weight);
withoutTruss.visualizeOutput();