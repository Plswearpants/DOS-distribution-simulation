function [area_map, E_range, kz_range] = generate_area_map(energyBands, kx, ky, kz, band_index, num_E_points)
    % Generate a 2D map of areas as a function of energy and kz
    %
    % Inputs:
    %   energyBands - 4D array of energy values [nx,ny,nz,nbands]
    %   kx, ky, kz - vectors defining the k-space grid
    %   band_index - which band to analyze (1 or 2)
    %   num_E_points - number of energy points to sample (optional)
    %
    % Outputs:
    %   area_map - 2D array of areas [num_E_points × num_kz_points]
    %   E_range - vector of energy values used
    %   kz_range - vector of kz values used
    
    if nargin < 6
        num_E_points = 100;  % default number of energy points
    end
    
    % Define energy range
    E_min = min(energyBands(:,:,:,band_index),[],'all');
    E_max = max(energyBands(:,:,:,band_index),[],'all');
    E_range = linspace(E_min, E_max, num_E_points);
    
    % Use existing kz points
    kz_range = kz;
    num_kz_points = length(kz);
    
    % Initialize area map
    area_map = zeros(num_E_points, num_kz_points);
    
    % Calculate areas for each combination of E and kz
    for i = 1:num_E_points
        for j = 1:num_kz_points
            area_map(i,j) = area_at_kz(energyBands, kx, ky, kz, E_range(i), j, band_index);
        end
    end
end 