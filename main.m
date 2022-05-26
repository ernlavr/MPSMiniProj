%% Add src to path
addpath('src/');

%% Paths
path_bridgeWithTruss = 'res/simpleBridge/model/bridge.stl';
path_bridgeNoTruss = 'res/simpleBridgeNoSupports/model/bridgeNoSupports.stl';
resultsNoTruss = 'results/noTruss';
resultsWithTruss = 'results/withTruss';
resultsNoTrussFigures = append(resultsNoTruss, '/figures');
resultsWithTrussFigures = append(resultsWithTruss, '/figures');

%% Create results folders
Utils.createFolderIfDoesntExist(resultsNoTruss)
Utils.createFolderIfDoesntExist(resultsWithTruss)
Utils.createFolderIfDoesntExist(resultsNoTrussFigures)
Utils.createFolderIfDoesntExist(resultsWithTrussFigures)

%% Create objects
withTruss = FeaWrapper(path_bridgeWithTruss, [76, 78], [80]);
withoutTruss= FeaWrapper(path_bridgeNoTruss, [69, 60], [73]);

%% Boundary Conditionss
% For AISI 1020 Steel, cold rolled
% https://www.matweb.com/search/DataSheet.aspx?MatGUID=10b74ebc27344380ab16b1b69f1cffbb
E           = 186e9;    % Youngs modulus
nu          = 0.29;     % Poissons ratio
md          = 7870;     % mass-density kg/m3
yieldLimit  = 3.5e8     % permanent deformation
maxLimit    = 5e8       % neck forming

weight      = 0;        % Approx. 98k is 100 tons
weightStep  = 980       % 100kg
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
logLocation = append(resultsWithTruss, '/withTruss', datestr(now,'_HH-MM-SS'), '.txt');
Utils.createLogFile(logLocation, allConds, condNames);

% Run simulation
startingWeight = 0
Utils.runSimulation(withTruss, E, nu, startingWeight, weightStep, ...
    md, yieldLimit, maxLimit, resultsWithTrussFigures, logLocation)

%% Perform Without-Truss Simulation
% Prep log
logLocation = append(resultsNoTruss, '/noTruss', datestr(now,'_HH-MM-SS'), '.txt');
Utils.createLogFile(logLocation, allConds, condNames);

% Run simulation
startingWeight = 0
Utils.runSimulation(withoutTruss, E, nu, startingWeight, weightStep, ...
    md, yieldLimit, maxLimit, resultsNoTrussFigures, logLocation)

%% Perform Single Computation
woTruss = Utils.solvePde(withoutTruss, E, nu, 107800, md)
wTruss = Utils.solvePde(withTruss, E, nu, 639940, md)

%% Plot histograms wo truss
histogram(woTruss.Rs.VonMisesStress)
ylim([0 6000]);
xlim([0, 3.6e8])
title('Histogram overview of von Mises stress for the non-truss model')
ylabel('Number of Occurences')
xlabel('Stress (Pa)')
%% Plot histogram w truss
histogram(wTruss.Rs.VonMisesStress)
ylim([0 6000]);
xlim([0, 3.6e8])
title('Histogram overview of von Mises stress for the truss model')
ylabel('Number of Occurences')
xlabel('Stress (Pa)')