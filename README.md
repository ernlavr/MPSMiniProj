# MPSMiniProj
Evaluate the structural integrity of an object using finite-element analysis

### To run the main simulation
1. Add 'src/' to MatLab path and. (Matlab should do it automatically from main.m); Add Partial Differential Equation Toolbox from Matlab 
https://se.mathworks.com/products/pde.html
2. Run the main.m script
3. Modify any boundry conditions or material properties in main.m
'src/Utils.m' contains generic utility functions for saving/logging and running the simulation
'src/FeaWrapper.m' contains utility functions for the PDE framework
4. Function-specific documentation is available as in-file comments

### Folder description
#### 'res/'
- Contains resources such as bridge models, descriptions and illustrations of them
#### 'results/'
- 'results' will be populated with the results of the simulation
#### 'resultsAnalysis/'
- Contains Python scripts for plotting weight-stress simulation data of both bridges and deriving max stress values at which both structures yield
- Requires `matplotlib` python dependency. Run by command 'python plotResults.py' without any command-line arguments
- 'resultsAnalysis' is used to plot the weight-stress simulation data for both bridges