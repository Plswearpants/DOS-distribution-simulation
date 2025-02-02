% Simplest tight-binding model for 3D material with 2 atoms per unit cell
% Parameters
t = 1.0;          % Nearest-neighbor hopping
epsilon = [0, 0]; % On-site energies (same for both atoms)
gridSize = 50;    % k-space resolution

% Define k-space grid
kx = linspace(-2*pi, 2*pi, gridSize);
ky = linspace(-2*pi, 2*pi, gridSize);
kz = linspace(-2*pi, 2*pi, gridSize);

% Initialize energy bands (2 bands for 2 atoms)
energyBands = zeros(gridSize, gridSize, gridSize, 2);

% Loop over k-space
for ix = 1:gridSize
    for iy = 1:gridSize
        for iz = 1:gridSize
            % Current k-point
            kx_i = kx(ix);
            ky_i = ky(iy);
            kz_i = kz(iz);
            
            % Off-diagonal term (phase factor from neighboring atoms)
            phi = t * (exp(1i*kx_i) + exp(1i*ky_i) + exp(1i*kz_i));
            
            % 2x2 Hamiltonian
            H = [epsilon(1),    phi;
                 conj(phi), epsilon(2)];
            
            % Get eigenvalues
            eigenvals = eig(H);
             energyBands(ix, iy, iz, :) = real(eigenvals);
        end
    end
end

% Save results
save('simple_3d_bands.mat', 'energyBands', 'kx', 'ky', 'kz'); 