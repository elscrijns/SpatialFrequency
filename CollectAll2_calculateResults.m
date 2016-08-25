%% Import the data from each session and calculate the summary of performance stored in Results
% The results are saved as a CSV file per animal in Dir
    % filename: Results_Group_animal.csv
    % if the file already exists data is added (different sessions per
    % animal are all saved in the same file)
    % file will contain :    
    % Condition, GroupCount, mean_Response, mean_RT, mean_RewardTime, 
    % mean_TimeDiff, mean_ScreenPokes, mean_FrontBeam, mean_BackBeam, 
    % mean_RewardPokes, Date
    
    
clc;clear all;

% Import data: .csv files created by CollectAl1l_extractData.m containing
% session information

Dir = 'E:\Temporal_Contiguity 01_06_2016\Collect_All\';
subDir = 'Rat PD Generalization High 1\';
filenames = dir([Dir subDir '*.csv']);
filenames.name;
n = size(filenames,1) % Number of files in subDir

%% for every file a results table is created containing performance level and significance
 
    
% Can be used to define the stimulus identity based on the schedule (subDir)

        % if length(subDir) == 41
        %     SF1 = str2num(subDir([36 37])) /100;
        %     SF2 = str2num(subDir([39 40])) /100;
        %     SP3 = 0000;
        % else 
        %     SF1 = 0.015;
        %     SF2 = 0.03;
        %     SF3 = 0.06;
        % end

for i = 1:n
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read in the CSV file into a table named DATA
    
    fileName = filenames(i).name
    %formatSpec = '%d%.3f%d%d%d%d%f%f%f%d%d%d%d';
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f';
    DATA = readtable([Dir subDir fileName],'Delimiter',',','Format',formatSpec, 'ReadVariableNames', false);
    DATA.Properties.VariableNames =  {'Trial' 'Condition' 'Response' 'CorrectP' 'TouchP' 'Correction' 'Time' ...
    'RT' 'RewardTime' 'ScreenPokes' 'FrontBeam' 'BackBeam' 'RewardPokes'};
    DATA.Properties.Description = fileName;
    
    DATA.TimeDiff = [diff(DATA.Time); nan];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sometimes one event is exported several times from ABET.
    % To remove these excess rows we check if the time between events is
    % smaller than the ITI (20s), The duplicate rows are deleted
    
    deleteRow = find(DATA.TimeDiff <20) + 1
    DATA(deleteRow,:) = [];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % Split the data into correction trials and valid response trials
    % Correction trials are not used to asses performance and should be
    % analyzed seperately 
    
    CorrectionTrials = DATA((DATA.Correction == 1),:);
    Response         = DATA((DATA.Correction == 0),:);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Replace condition number with meaningfull names (if defined above)
        for t = 1:size(Response,1)
            if Response.Condition(t) == 1
                Response.Condition(t) = SF1;
            elseif Response.Condition(t) == 2
                Response.Condition(t) = SF2;
            else
                Response.Condition(t) = SF3;
            end
        end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate the summary statistics for this session per condition 
    % (type of stimulus presentation) based on the valid trials
    
    Results = grpstats(Response, {'Condition'} , 'mean' , 'DataVars', ...
        {'Response' , 'RT', 'RewardTime', 'TimeDiff', 'ScreenPokes', ...
        'FrontBeam', 'BackBeam' , 'RewardPokes'});
    
    nRows = size(Results,1);
    Results.Date = repmat(fileName(9:18),nRows,1);
   
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % export the results table to an CSV file
    
    outFile = [Dir 'Results_' fileName(1:7) '.csv'];
    try    
         T = readtable(outFile);
         C = table2cell(Results);
         Results2 = [T ; C];   
         writetable(Results2, outFile,'WriteRowNames',false, 'Delimiter', ',')
    catch
         writetable(Results, outFile,'WriteRowNames',false, 'Delimiter', ',')
    end
    
    % a separate file can be created for each condition if required
    
    %     outFile_SF1 = [Dir 'Results_SF1_' fileName(1:7) '.csv'];
    %     try
    %          T = readtable(outFile_SF1);
    %          C = table2cell(Results([1:end-1],:));
    %          Results2 = [T ; C]; 
    %          writetable(Results2, outFile_SF1,'WriteRowNames',false, 'Delimiter', ',')
    %     catch
    %          writetable(Results([1:end-1],:), outFile_SF1,'WriteRowNames',false, 'Delimiter', ',')
    %     end
    %   
    %     outFile_SF2 = [Dir 'Results_SF2_' fileName(1:7) '.csv'];
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
    
    % export the Correction trials table to an CSV file
    outFile2 = [Dir  'Correction_' fileName(1:7) '.csv'];
    try
        T = readtable(outFile2);
        C = table2cell(CorrectionTrials);
        Results = [T ; C];
        writetable(Results, outFile_SF3,'WriteRowNames',false, 'Delimiter', ',')
    catch
        writetable(CorrectionTrials,outFile2,'WriteRowNames', false , 'Delimiter', ',')
    end
    
    clear DATA Response Results Correction Trial outfile*
end 

clear all
