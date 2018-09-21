function [] = ploterror(mean_error,std)

% Create the 3D bar plot
% The width of the bars are set to 0.5 and the style to detached
% This can be adapted to the personal preferences
bar3_h = bar3(mean_error, 0.5, 'detached');

    % Set hold to on to be able to add the error bars without overwriting the image
    hold on;

    % Traverse the y values, or rows
    for i = 1:size(mean_error, 1)

        % Traverse the x values, or columns
        for j = 1:size(mean_error, 2)

            % Check if the standard deviation is larger than 0
            if std(i, j) > 0

                % First, draw a line 
                % If you use a different coordinate system, this has to be adapted 

                % Set the x coordinates for the line
                X = [j, j];

                % Set the y coordinates for the line
                Y = [i, i];

                % The endpoint of the line
                z_end = mean_error(i, j) + std(i, j);


                % Set the z coordinates for the line
                 Z = [mean_error(i,j), z_end];

                % Draw a solid black line according to its coordinates
                plot3(X, Y, Z, 'r-');

                % Optionally you can also draw an end marker
                % In our case it has a width of 0.4
                X = [j - 0.2, j + 0.2];

                % Finally, the Z coordinates (Y does not change)
                Z = [z_end, z_end];

                % Plot the end marker
                plot3(X,Y,Z,'r-');

            end % end if
        end % end for j
    end % end for i
end % end function
