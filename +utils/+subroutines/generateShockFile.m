function generateShockFile(fileName, endShockSize, numYears)
    % Generate a shock file with linearly increasing values
    % 
    % Inputs:
    %   fileName - name of the output file (string)
    %   endShockSize - final shock value (scalar)
    %   numPeriods - number of periods over which shock linearly increases (scalar)
    
    % Translating years into quarters
    numQuarters = numYears * 4;

    % Open file for writing
    fid = fopen(fileName, 'w');
    
    % Write the periods line
    fprintf(fid, 'periods ');
    for i = 1:numQuarters
        fprintf(fid, '%d ', i);
    end
    fprintf(fid, '%d:1000 ;\n', numQuarters+1);
    
    % Write the values header
    fprintf(fid, 'values\n');
    
    % Calculate the increment per period
    increment = endShockSize / numQuarters;
    
    % Write the linearly increasing values for the first numPeriods
    for i = 1:numQuarters
        fprintf(fid, '    %g\n', i * increment);
    end
    
    % Write the final constant value
    fprintf(fid, '    %g\n', endShockSize);
    
    % Close the values section
    fprintf(fid, ';\n');
    
    % Close file
    fclose(fid);
    
    fprintf('Shock file "%s" generated successfully.\n', fileName);
end