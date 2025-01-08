% Define tight-binding parameters for MoS2 (Table VII)
epsilon = [1.0688, -0.7755, -1.2902, -3.1667, 0.0874, -2.8941, -1.9065]; % On-site energies
t12 = [0.0329, -0.5581, -0.7883, 2.1584, -0.8836, -0.9404];             % Hopping integrals (example subset)
t34 = 0.2451; % Example parameter for hopping between specific orbitals

% Define grid resolution and k-space limits
gridSize = 50;               % Number of points in each k-direction
kx = linspace(-pi, pi, gridSize);
ky = linspace(-pi, pi, gridSize);
kz = linspace(-pi, pi, gridSize);

% Initialize 4D array: [Kx x Ky x Kz x Bands]
numBands = 7; % Example: Based on the number of orbitals in the model
energyData = zeros(gridSize, gridSize, gridSize, numBands);

% Loop over the k-space grid and calculate eigenvalues
for ix = 1:gridSize
    for iy = 1:gridSize
        for iz = 1:gridSize
            % Current k-point
            kx_i = kx(ix);
            ky_i = ky(iy);
            kz_i = kz(iz);

            % Construct the Hamiltonian matrix (example 7x7 system)
            H = zeros(numBands, numBands);

            % Fill diagonal with on-site energies
            for i = 1:numBands
                H(i, i) = epsilon(i); 
            end

            % Add hopping terms (example subset)
            H(1, 2) = t12(1) * exp(1i * kx_i);
            H(2, 1) = conj(H(1, 2));
            H(2, 3) = t12(2) * exp(1i * ky_i);
            H(3, 2) = conj(H(2, 3));
            H(1, 4) = t34 * exp(1i * kz_i);
            H(4, 1) = conj(H(1, 4));

            % Diagonalize the Hamiltonian to get eigenvalues
            eigenvalues = eig(H);
            energyData(ix, iy, iz, :) = sort(real(eigenvalues)); % Sort for consistency
        end
    end
end

% Save the 4D energy data array to a .mat file
save('MoS2_4D_Energy_Data.mat', 'energyData', 'kx', 'ky', 'kz');

% Display a success message
disp('4D energy data array has been computed and saved as MoS2_4D_Energy_Data.mat');
