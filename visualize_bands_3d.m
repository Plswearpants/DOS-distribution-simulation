function visualize_bands_3d()
    % Load the data
    data = load('simple_3d_bands.mat');
    
    % Create figure
    fig = figure('Position', [100 100 800 600]);
    
    % Create slider
    slider = uicontrol('Style', 'slider', ...
        'Position', [100 20 600 20], ...
        'Min', min(data.energyBands(:)), ...
        'Max', max(data.energyBands(:)), ...
        'Value', 0, ...
        'Callback', @updatePlot);
    
    % Create text display for current energy
    energyText = uicontrol('Style', 'text', ...
        'Position', [350 45 100 20], ...
        'String', 'Energy: 0');
    
    % Create 3D grid for visualization
    [X, Y, Z] = meshgrid(data.kx, data.ky, data.kz);
    
    % Store data in figure
    setappdata(fig, 'plotData', struct('X', X, 'Y', Y, 'Z', Z, ...
        'energyBands', data.energyBands, 'energyText', energyText));
    
    % Initial plot
    updatePlot(slider, []);
    
    function updatePlot(source, ~)
        % Get current energy value
        energy = source.Value;
        
        % Get stored data
        data = getappdata(gcf, 'plotData');
        
        % Create new axes instead of clearing figure
        delete(findobj(gcf, 'Type', 'axes'));
        axes('Parent', gcf);
        
        % Update energy text
        set(data.energyText, 'String', sprintf('Energy: %.2f', energy));
        
        % Create isosurfaces for both bands
        hold on;
        for band = 1:2
            bandData = squeeze(data.energyBands(:,:,:,band));
            p = patch(isosurface(data.X, data.Y, data.Z, bandData, energy));
            isonormals(data.X, data.Y, data.Z, bandData, p);
            if band == 1
                color = 'blue';
            else
                color = 'red';
            end
            set(p, 'FaceColor', color, ...
                'EdgeColor', 'none', ...
                'FaceAlpha', 0.3);
        end
        hold off;
        
        % Set plot properties
        xlabel('k_x');
        ylabel('k_y');
        zlabel('k_z');
        title(sprintf('Energy Bands at E = %.2f', energy));
        grid on;
        axis equal;
        view(3);
        camlight;
        lighting gouraud;
        
        % Keep slider and text visible
        uistack(source, 'top');
        uistack(data.energyText, 'top');
        
        % After the plot properties section, add:
        xlim([-2*pi 2*pi]);
        ylim([-2*pi 2*pi]);
        zlim([-2*pi 2*pi]);
        
        % Update tick marks to show 2nd BZ boundaries
        set(gca, 'XTick', [-2*pi -pi 0 pi 2*pi], 'XTickLabel', {'-2π', '-π', '0', 'π', '2π'});
        set(gca, 'YTick', [-2*pi -pi 0 pi 2*pi], 'YTickLabel', {'-2π', '-π', '0', 'π', '2π'});
        set(gca, 'ZTick', [-2*pi -pi 0 pi 2*pi], 'ZTickLabel', {'-2π', '-π', '0', 'π', '2π'});
    end
end

function out = conditional(condition, true_value, false_value)
    if condition
        out = true_value;
    else
        out = false_value;
    end
end 