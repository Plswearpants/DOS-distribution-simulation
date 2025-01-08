function slices = area_at_kz(energyBands, E)
    % Generate slices of constant energy contours across all kz
    %
    % Inputs:
    %   energyBands - 4D array of energy values [nx,ny,nz,nbands]
    %   E - target energy value
    %
    % Output:
    %   slices - 3D array containing CEC areas for each kz [nx,ny,nz]
    
    [nx, ny, nz, nbands] = size(energyBands);
    slices = zeros(nx, ny, nz);
    
    % For each band, find the closest isosurface to energy E
    for band = 1:nbands
        band_data = energyBands(:,:,:,band);
        
        % Create mask for points near the energy E
        energy_diff = abs(band_data - E);
        is_closer = energy_diff < abs(slices - E);
        
        % Update slices where this band is closer to target energy
        slices(is_closer) = band_data(is_closer);
    end
    
    % Create mask for points inside first BZ
    [KX, KY] = meshgrid(linspace(-pi, pi, nx), linspace(-pi, pi, ny));
    bz_mask = (abs(KX) <= pi) & (abs(KY) <= pi);
    
    % Apply BZ mask to all slices
    for k = 1:nz
        slices(:,:,k) = slices(:,:,k) .* bz_mask;
    end
    
    % Display the slices using d3gridDisplay
    d3gridDisplay(slices, 'dynamic');
end 