% Convert data from ABET to a csv file with one variable per column
%
% Created by Christophe Bossens
% Edited by Els Crijns
%
% Last edited on 23-08-2016
%% Takes csv data from
clc;clear all;

filepath = 'E:\Spatial_Frequency_Range 18-08-2016\Data ABET\';
filename = 'SF_training_2016-04-14.csv' 
    % File must be tab delimited (L 25) and have a dot as decimal separator (L 29)
outputPath = 'E:\Spatial_Frequency_Range 18-08-2016\Data Extracted\';

useExcel = 0;
saveFile = 1;
if ~exist([filepath filename],'file')
    display('Error, could not find filename');
end

warning off MATLAB:MKDIR:DirectoryExists

%% Read data using excel reader or csv reader
if useExcel ~= 0
    [nData, text, alldata] = xlsread([filepath filename]);
    alldata(1,:) = [];
else
    fid = fopen([filepath filename]);
    fgetl(fid);
    rowIndex = 1;
    while ~feof(fid)
        nextLine = fgetl(fid);
        items = find(nextLine == '	'); % tab delimited file, can also be a ;
        items = [0 items length(nextLine)+1];
        for i = 1:(length(items)-1)
            if i > 4    % strrep to replace the comma with a dot as a decimal separator
                alldata{rowIndex,i} = str2double(nextLine(items(i)+2 : items(i+1)-2));
            else
                alldata{rowIndex,i} = nextLine(items(i)+2 : items(i+1)-2);
            end
        end
        rowIndex = rowIndex + 1;
    end
    fclose(fid);
end
% Find row with maximal number of events, all other rows are 
% aligned to this
maxResponses = max(cell2mat(alldata(1:end,5)));

excludeSchedules = {'Rat Pairwise Must Touch Training v2' 
                    'Rat Pairwise Must Initiate Training v2'
                    'Rat Pairwise Initial Touch Training v2'
                    'Rat Pairwise Punish Incorrect Training v2'
                    'Rat Pairwise Habituation 1'};

%% For each row the data is reorganised
for rowIndex = 1:size(alldata,1)
   rowIndex
   schedule = alldata{rowIndex,1};
   runtime = alldata{rowIndex,2};
   animalID = cell2mat(alldata(rowIndex,3));
   groupID = cell2mat(alldata(rowIndex,4));
       if (isempty(groupID))
           groupID = '99';
       end
       if (isempty(animalID))
           animalID = '99';
       end
       if (sum(strncmp(schedule,excludeSchedules,length(schedule))) > 0)
           continue
       end

   % Get the number of data points
   % The standard shaping protocols contain different parameters so they
   % should not be analysed using this script
   nResponses = cell2mat(alldata(rowIndex,5));
   
   if (isnan(nResponses))
       nResponses = 0;
   end
  
   % Parse the date
   separators = find(runtime == '/');
   day = runtime(1:separators(1)-1);
   month = runtime(separators(1)+1:separators(2)-1);
   year = runtime(separators(2)+1:separators(2)+4);
       if length(month) == 1
           month = ['0' month];
       end

       if length(day) == 1
           day = ['0' day];
       end
   
   switch groupID
       case '1-473'
           group = 1;
       case '2-437'
           group = 2;
       case '3-549'
           group = 3;
       otherwise
           disp('failed to update groupID')
   end
   
   % Extract response data
    % Reference condition
   Offset = 6;
   timeStamps = cell2mat(alldata(rowIndex,Offset:(Offset+nResponses-1)));
   trialNumber = cell2mat(alldata(rowIndex,(Offset +   maxResponses):(Offset +   maxResponses + nResponses - 1)));
   pairIndex = cell2mat(alldata(rowIndex,(Offset + 2*maxResponses):(Offset + 2*maxResponses + nResponses - 1)));
   Response = cell2mat(alldata(rowIndex,   (Offset + 3*maxResponses):(Offset + 3*maxResponses + nResponses - 1)));
   correctionTrial = cell2mat(alldata(rowIndex,   (Offset + 4*maxResponses):(Offset + 4*maxResponses + nResponses - 1)));
   
   % Save to file
   if saveFile == 1
       fid = fopen([outputPath num2str(group) '_' animalID '_' year '-' month '-' day '.csv'],'w');
       for i = 1:nResponses
           fprintf(fid,[num2str(timeStamps(i)) ','  schedule ',' num2str(trialNumber(i)) ',' ...
               num2str(pairIndex(i)) ',' num2str(Response(i)) ',' num2str(correctionTrial(i)) '\n']);
       end
       fclose(fid);
       
   end
 end

clear all