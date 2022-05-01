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

            importGeometry(obj.model, obj.geoPath)
            obj.mesh = generateMesh(obj.model, 'Hmax', 1);
        end

        % Visualize Geometry
        function visGeo(obj, tit)
            figure
            pdegplot(obj.model,'FaceLabels','on')
            view(30,30);
            title(tit)
        end

        % Set boundary conditions
        %   E   -> Youngs modulus in Newtons
        %   nu  -> Poissons ratio
        %   weight -> Force on the object
        function obj = solve(obj, E, nu, weight)
            structuralProperties(obj.model, ...
                'YoungsModulus', E, ...
                'PoissonsRatio', nu);
            structuralBC(obj.model, ... 
                'Face', obj.fixedFaces, ...
                'Constraint', 'fixed');
            structuralBoundaryLoad(obj.model, ...
                'Face', obj.facesWithPressure, ...
                'Pressure', weight);
        
            obj.Rs = solve(obj.model);
        end

        function visualizeOutput(obj)
            pdeplot3D(obj.model, ...
                'ColorMapData', obj.Rs.VonMisesStress, ...
                'Deformation', obj.Rs.Displacement, ...
                'DeformationScaleFactor', 1)
        end
        
    end
end

