classdef FeaWrapper
    %FeaWrapper Perform displacement computations using FEA
    %   Detailed explanation goes here
    
    properties
        geoPath             % path to geometry
        fixedFaces          % faces of the object that are fixed
        facesWithPressure   % faces to which pressure will be applied to
        mesh                % Discretized geometry
        model               % PDE
        Rs                  % Solved problem
    end
    
    methods
        % Constructor
        function obj = FeaWrapper(geoPath, fixedFaces, facesWithPressure)
            obj.geoPath = geoPath;
            obj.fixedFaces = fixedFaces;
            obj.facesWithPressure = facesWithPressure;
            obj.model = createpde("structural", "static-solid");

            importGeometry(obj.model, obj.geoPath);
            obj.mesh = generateMesh(obj.model, 'Hmax', 1);
            meshVol = volume(obj.mesh)

        end

        % Visualize Geometry
        function visGeo(obj, tit)
            figure;
            pdegplot(obj.model,'FaceLabels','on');
            view(30,30);
            title(tit);
        end

        % Set boundary conditions
        %   E   -> Youngs modulus in Newtons
        %   nu  -> Poissons ratio
        %   weight -> Force on the object
        function obj = solve(obj, E, nu, weight, massDensity)
            % Material properties (steel)
            structuralProperties(obj.model, ...
                'YoungsModulus', E, ...
                'PoissonsRatio', nu, ...
                'MassDensity', massDensity);
            
            % Fix ends of the bridge..
            structuralBC(obj.model, ... 
                 'Face', obj.fixedFaces, ...
                 'Constraint', 'fixed');
            
            % Specify the weight on the floor of the models
             structuralBoundaryLoad(obj.model, ...
                 'Face', obj.facesWithPressure, ...
                 'Pressure', weight);

            %structuralBodyLoad(obj.model, ...
            %    'GravitationalAcceleration',[0;0;-9.8])
        
            obj.Rs = solve(obj.model);
        end

        function visualizeOutput(obj, weight, ms, yield, us)
            % Visualizes the solved PDE
            pdeplot3D(obj.model, ...
                'ColorMapData', obj.Rs.VonMisesStress, ...
                'Deformation', obj.Rs.Displacement, ...
                'DeformationScaleFactor', 5);

            % Set to sideways view
            az = 180;
            el = 0;
            view(az, el);
            xlabel('Length (m)')
            ylabel('Length (m)')
            zlabel('Length (m)')
            
            % Set x-y-z limits
            xlim([-90 0])
            ylim([0 25])
            zlim([0 25])

            % Set color bar limit
            lowerLimit = 1 * (1.0e+05)
            upperLimit = 3.6 * (1.0e+08)
            caxis([lowerLimit upperLimit]);

            % Add annotations of weight + max stress
            weightStr = append('Weight: ', string(weight), 'N')
            msStr = append('Max Stress: ', num2str(ms,'%.4e'), 'Pa')
            yStr = append('Yield: ', num2str(yield,'%.4e'), 'Pa')
            %uStr = append('Ultimate Str: ',num2str(us,'%.4e'), 'Pa')
            str = {weightStr msStr yStr}
            annotation('textbox', [0.1 0.75 0.4 0.2], 'String', str, 'FitBoxToText','on')
        end
        
    end
end

