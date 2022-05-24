classdef Utils
methods (Static)
% Static utility functions %
% ------------------------ %
    function createFolderIfDoesntExist(folder)
        % create a folder
        if ~exist(folder, 'dir')
            mkdir(folder)
        end
    end

    function createLogFile(name, allConds, condNames)
        % Create a log file and add boundary conditions as initial entries
        fid = fopen(name, 'wt' );
        for k=1:length(allConds)
            entry = append(condNames(k), ": ", string(allConds(k)), '\n')
            fprintf(fid, entry);
        end
        fprintf(fid, '\n');
        fclose(fid);
    end

    function writeToLogFile(name, msg)
        % Write the msg to the log file
        fid = fopen(name, 'a+' );
        fprintf(fid, msg + '\n');
        fclose(fid);
    end

    function runSimulation(pde, E, nu, weight, weightStep, ...
            md, yieldLimit, maxLimit, figLoc, logLoc)
        % Wrapper function to run the simulation and save the results
        % pde       -> pde to solve
        % E         -> Youngs modulus
        % nu        -> Poissons ratio
        % weight    -> weight applied to the structure (N)
        % weightStep-> step size for the parameter sweep (N)
        % md        -> mass density
        % yieldLimit-> yield point of a material (Pa)
        % maxLimit  -> ultimate strength of a material (Pa)
        % figLoc    -> path to figure output
        % logLoc    -> path to log file

        maxStress = 0;
        while(maxStress < maxLimit)
            % Delete all annotations
            delete(findall(gcf,'type','annotation'))
        
            % Perform FEA and visualize output
            solvedPde = pde.solve(E, nu, weight, md);
            maxStress = max(solvedPde.Rs.VonMisesStress)
            solvedPde.visualizeOutput(weight, maxStress, yieldLimit, maxLimit);
        
            % Save img
            imgNameSide = append(figLoc, '/noTruss_Side', ...
                string(weight), '.png');
            imgNamePersp = append(figLoc, '/noTruss_Persp', ...
                string(weight), '.png');
            saveas(gcf, imgNameSide)
            
            % Rotate for perspective view
            view(30,30);
            saveas(gcf, imgNamePersp)
            
            % Write log
            logEntry = append("weight:", string(weight), ", stress:", string(maxStress))
            Utils.writeToLogFile(logLoc, logEntry)
            weight = weight + weightStep
        end
    end


%%%%%
end
end