%% Add src to path
addpath('src/');

%% Paths
path_bridgeWithTruss = 'res/simpleBridge/model/bridge.stl';
path_bridgeNoTruss = 'res/simpleBridgeNoSupports/model/bridgeNoSupports.stl';
resultsNoTruss = 'results/noTruss';
resultsWithTruss = 'results/noTruss';
resultsNoTrussFigures = 'results/noTruss/figures';
resultsWithTrussFigures = 'results/noTruss/figures';

%% Create results folders
Utils.createFolderIfDoesntExist(resultsNoTruss)
Utils.createFolderIfDoesntExist(resultsWithTruss)
Utils.createFolderIfDoesntExist(resultsNoTrussFigures)
Utils.createFolderIfDoesntExist(resultsWithTrussFigures)

%% Create objects
withTruss = FeaWrapper(path_bridgeWithTruss, [76, 78], [80]);
withoutTruss= FeaWrapper(path_bridgeNoTruss, [69, 60], [73]);

%% Boundary Conditionss
E           = 200e9;    % Youngs modulus
nu          = 0.33;     % Poissons ratio
weight      = 0;        % Approx. 98k is 100 tons
md          = 7750;     % mass-density (steel)
yieldLimit  = 3e8       % permanent deformation
maxLimit    = 5e8       % neck forming

weightStep  = 980      % 100kg
allConds    = [E nu weight md yieldLimit maxLimit];
condNames   = ["E", "nu", "weight", "md", "yieldLimit", "maxLimit"]

%% Visualize
% withTruss.visGeo('With Truss');
% withoutTruss.visGeo('Without Truss');

%% Perform Computing With Truss
% withTruss = withTruss.solve(E, nu, weight, md);
% maxStress = max(withTruss.Rs.VonMisesStress)
% withTruss.visualizeOutput(weight, maxStress, yieldLimit, maxLimit);

%% Perform With-Truss Simulation
% Prep log
logLocation = append(resultsWithTrussFigures, '/withTruss', datestr(now,'_HH-MM-SS'));
Utils.createLogFile(logLocation, allConds, condNames);

% Run simulation
startingWeight = 0
Utils.runSimulation(withTruss, E, nu, startingWeight, weightStep, ...
    md, yieldLimit, maxLimit, resultsNoTrussFigures, logLocation)

%% Perform Without-Truss Simulation
% Prep log
logLocation = append(resultsNoTruss, '/noTruss', datestr(now,'_HH-MM-SS'));
Utils.createLogFile(logLocation, allConds, condNames);

% Run simulation
startingWeight = 0
Utils.runSimulation(withoutTruss, E, nu, startingWeight, weightStep, ...
    md, yieldLimit, maxLimit, resultsNoTrussFigures, logLocation)