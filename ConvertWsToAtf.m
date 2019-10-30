function ConvertWsToAtf(FileName)
Recording = ws.loadDataFile(FileName);

figure;

WaveSurferVersion = Recording.header.VersionString;
Year = int2str(Recording.header.ClockAtRunStart(1,1));
Month = int2str(Recording.header.ClockAtRunStart(1,2));
Day = int2str(Recording.header.ClockAtRunStart(1,3));
Date = strcat(Year, Month, Day);

FieldNames = fieldnames(Recording);
NumberOfChannels = Recording.header.NAIChannels;
ChannelNames = Recording.header.AIChannelNames;
for i = 1:length(ChannelNames)
   ChannelNames{i} = strtrim(ChannelNames{i});
end
ChannelUnits = Recording.header.AIChannelUnits;
SamplingRate = Recording.header.AcquisitionSampleRate;
SweepLength = Recording.header.ExpectedSweepScanCount;
NumberOfSweeps = length(FieldNames)-1;

%find out recording mode from unit of the AI
if strcmp(ChannelUnits{1}, 'pA')
    RecordingMode = 'Voltage Clamp';
elseif strcmp(ChannelUnits{1}, ChannelUnits{2})
    RecordingMode = 'undefined';
    disp('You did not switch the secondary during recording!')
else 
    RecordingMode = 'Current Clamp';
end

% create the time axis using the sampling rate and the length of the scan
TimeStart = 0;
TimeEnd = (SweepLength-1)/SamplingRate;
dt = 1/SamplingRate;
Time = (TimeStart:dt:TimeEnd)'; %time in ms

matrixData = Time;

% plot all channels and overlay the sweeps
% label plot and axes
for i = 2:length(FieldNames)
    for k = 1:NumberOfChannels
        yData = getfield(Recording, FieldNames{i});
        matrixData(:,size(matrixData,2)+1) = yData.analogScans(:,k);

        subplot(NumberOfChannels, 1, k);hold on
        plot(Time, yData.analogScans(:,k))
        xlabel('time [s]')
        ylabel(ChannelUnits{k})
        title(ChannelNames{k})
        annotation('textbox', [0, 0.99, 0, 0], 'string', FileName)
        annotation('textbox', [0, 0.1, 0, 0], 'string', RecordingMode)
    end
end


sweepLengthMS = max(Time)*1000;
filename = strcat(FileName(1:end-3),'.atf');

fid = fopen(filename,'wt');
fprintf(fid, 'ATF\t1.0\n8\t%i\n', size(matrixData,2));
fprintf(fid, '"AcquisitionMode=Episodic Stimulation"\n');
fprintf(fid, '"Comment="\n');
fprintf(fid, '"YTop=10,10"\n');
fprintf(fid, '"YBottom=-10,-10"\n');
fprintf(fid, '"SyncTimeUnits=10"\n');



%put in sweep start times ms
%loop over the number of sweeps
%start at 0, add sweep length add 3 digits of precision
fprintf(fid, '"SweepStartTimesMS=');
for i = 1:NumberOfSweeps
   fprintf(fid, '%.3f', (i-1)*sweepLengthMS);
   if(i ~= NumberOfSweeps)
       fprintf(fid, ',');
   end
end
fprintf(fid, '"\n');



%signals exported header line
fprintf(fid, '"SignalsExported=');
for i = 1:length(ChannelNames)
   fprintf(fid, '%s', ChannelNames{i});
   if(i ~= length(ChannelNames))
       fprintf(fid, ',');
   end
end
fprintf(fid, '"\n');



%Signals header line
fprintf(fid, '"Signals="\t');
for i = 1:NumberOfSweeps
    for k = 1:length(ChannelNames)
       fprintf(fid, '"%s"', ChannelNames{k});
       if(k ~= length(ChannelNames))
           fprintf(fid, '\t');
       end
    end
    if(i ~= NumberOfSweeps)
       fprintf(fid, '\t');
    end
end
fprintf(fid, '\n');



%Units display (?)
fprintf(fid, '"Time (s)"\t');
for i = 1:NumberOfSweeps
    for k = 1:length(ChannelNames)
       fprintf(fid, '"Trace #%i (%s)"', i, ChannelUnits{k});
       if(k ~= length(ChannelNames))
           fprintf(fid, '\t');
       end
    end
    if(i ~= NumberOfSweeps)
       fprintf(fid, '\t');
    end
end
fprintf(fid, '\n');

fclose(fid);

dlmwrite(filename, matrixData,'-append','delimiter', '\t','precision',6,'newline','pc');

fid = fopen(filename,'a');
fprintf(fid, '\n');
fclose(fid);
end