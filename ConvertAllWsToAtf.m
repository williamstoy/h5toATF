function ConvertAllWsToAtf(overwriteIfExists, openWhenConverted)
    disp('-----------------');
    disp('BEGINNING CONVERSION');
    folder = '';
    h5Files = dir([folder '*.h5']);
    for i = 1:length(h5Files)
        % check to see if a file named FileName.atf already exists
        % so, don't convert
        if(isempty(dir([folder h5Files(i).name(1:end-3) '.atf'])) || overwriteIfExists)
            disp('CONVERTING')
            disp(h5Files(i).name);
            ConvertWsToAtf(h5Files(i).name);
            
            if(openWhenConverted)
                disp(h5Files(i).name(1:end-3))
                winopen([h5Files(i).name(1:end-3) '.atf']);
            end
        else
            disp('SKIPPING (FILE ALREADY CONVERTED)');
            disp(h5Files(i).name);
        end
    end
    disp('FINISHED CONVERSION');
    disp('-----------------');
end