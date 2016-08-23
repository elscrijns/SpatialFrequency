% Import the data from each session and calculate the summary of performance stored in Results
%
% Created by Christophe Bossens
% Edited by Els Crijns
%
% Last edited on 23-08-2016

clc;clear all;

%% Import data: .csv files created by SF1_extractData.m

Dir = 'E:\Spatial_Frequency_Range 18-08-2016\Data Extracted\';
filenames = dir([Dir '*.csv']);
filenames.name;

%% for every file a results table is created containing Performance and significance
% The results are saved as ...\Results\Results_fileName.csv
n = size(filenames,1) % Number of files

for i = 1:n
    clear DATA Response Results CorrectionTrials
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read in the CSV file into a Table named DATA

    fileName = filenames(i).name
    formatSpec = '%f%s%d%f%d%d';
        DATA = readtable([Dir fileName],'Delimiter',',','Format',formatSpec, 'ReadVariableNames', false);
        DATA.Properties.VariableNames =  {'Time' 'Schedule' 'Trial' 'SpatialFrequency' 'Response' 'Correction' };
        DATA.Properties.Description = fileName;
    
    % Split the data into correction trials and actual response trials
    CorrectionTrials = DATA((DATA.Correction == 1),:);
    Response         = DATA((DATA.Correction == 0),:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sometimes one event is exported several times from ABET.
    % To remove these excess rows we check if the time between events is
    % smaller than the ITI, The duplicate rows are deleted
  
    deleteRow = find(diff(Response.Time)<20) + 1
    Response(deleteRow,:) = [] ;
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the sum of Response per 'Spatial Frequency'
    
    Results = grpstats(Response, 'SpatialFrequency', {'sum'}, 'DataVars' , ...
        'Response', 'VarNames', {'SpatialFrequency','nTrials','nCorrect'});

    % Removes the events that are recorded > 1 if there are too many trials 
    %     if sum(Results.nTrials) > 100
    %         Response = unique(Response(:,2:6));
    %         Results = grpstats(Response, 'SpatialFrequency', {'sum'}, 'DataVars' , ...
    %     'Response', 'VarNames', {'SpatialFrequency','nTrials','nCorrect'});
    %         disp('Amount of trials was corrected');
    %     end

    % Calculate the performance based on a Binomial distribution
    [Results.Performance,Results.CI] = binofit(Results.nCorrect, Results.nTrials);

    Results.Performance = 100*round(Results.Performance,3);
    Results.CI = 100*round(Results.CI,3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add the Spatial Frequencies in cpd based on schedule name
   
    if strcmp(DATA.Schedule(1), 'Generalization Training 2') || strcmp(DATA.Schedule(1), 'Generalization Training 1')
        Results.SpatialFrequency(3) = 0.06;
        Results.SpatialFrequency(2) = 0.03;
        Results.SpatialFrequency(1) = 0.015;
        Results.Schedule = DATA.Schedule(1:3);
    elseif ~isempty(strfind(DATA.Schedule(1), 'SF range 06-12'))
        Results.SpatialFrequency(1) = 0.06;
        Results.SpatialFrequency(2) = 0.12;
        Results.Schedule = DATA.Schedule(1:2);
    elseif ~isempty(strfind(DATA.Schedule(1), 'SF range 12-24'))
        Results.SpatialFrequency(1) = 0.12;
        Results.SpatialFrequency(2) = 0.24;
        Results.Schedule = DATA.Schedule(1:2);
    elseif ~isempty(strfind(DATA.Schedule(1), 'SF range 24-48'))
        Results.SpatialFrequency(1) = 0.24;
        Results.SpatialFrequency(2) = 0.48;
        Results.Schedule = DATA.Schedule(1:2);
    else
        disp('no spatial frequency found!')
    end

    Results
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % export the results table to an CSV file
    
    outFile = [Dir  'Results\Results_' fileName];
    writetable(Results,outFile,'WriteRowNames',false, 'Delimiter', ',')
    
    outFile = [Dir 'Results\Results_' fileName(1:3) '.csv'];
    try    
         T = readtable(outFile);
         C = table2cell(Results);
         Results2 = [T ; C];   
         writetable(Results2, outFile,'WriteRowNames',false, 'Delimiter', ',')
    catch
         writetable(Results, outFile,'WriteRowNames',false, 'Delimiter', ',')
    end
    
    % a separate file can be created for each condition if required
    
    %     outFile_SF1 = [Dir 'Results_old_' fileName(1:7) '.csv'];
    %     try
    %          T = readtable(outFile_SF1);
    %          C = table2cell(Results([1:end-1],:));
    %          Results2 = [T ; C]; 
    %          writetable(Results2, outFile_SF1,'WriteRowNames',false, 'Delimiter', ',')
    %     catch
    %          writetable(Results([1:end-1],:), outFile_SF1,'WriteRowNames',false, 'Delimiter', ',')
    %     end
    %   
    %     outFile_SF2 = [Dir 'Results_new_' fileName(1:7) '.csv'];
    %     try
    %          T = readtable(outFile_SF2);
    %          C = table2cell(Results(end,:));
    %          Results2 = [T ; C];
    %          writetable(Results2, outFile_SF2,'WriteRowNames',false, 'Delimiter', ',')
    %     catch
    %         writetable(Results(end,:), outFile_SF2,'WriteRowNames',false, 'Delimiter', ',')
    %     end
    %     
     fclose('all');
    % export the correction table to an CSV file
    outFile2 = [Dir  'CorrectionTrials\Correction_' fileName];
    writetable(CorrectionTrials,outFile2,'WriteRowNames',false, 'Delimiter', ',')
    
    clear DATA Response Results Correction Trial
end 

clear all
