%% Data can be loaded from a pre-generated matlab variables, containing the Results and Correction structures
% These structures contain all relevant information per animal
load('SFnew_CollectAll.mat')
load('TC_CollectAll.mat')

%% Read in the data per rat and organize per measure: 1 datapoint for each SF
Dir = 'E:\Temporal_Contiguity 01_06_2016\Collect_All\';
fileNames = dir([Dir 'Results_*.csv ']);
n = size(fileNames,1)

for i =  1:12
    fileName = fileNames(i).name
    formatSpec = '%f%d%f%f%f%f%f%f%f%f%s';
    DATA = readtable([Dir fileName],'Delimiter',',','Format',formatSpec, 'ReadVariableNames', true);
    DATA.Properties.VariableNames = {'Condition' , 'GroupCount' , 'Response' , 'RT', 'RewardTime', 'Time', 'ScreenPokes', 'FrontBeam', 'BackBeam' , 'RewardPokes', 'Date'};

%    [C, Loc, ]  = unique(DATA.Condition, 'last');
    Results(i).name = fileName;
    Results(i).All = DATA;           % All training days
%    Results(i).data = DATA(1:6,:);   % Only part of the data is included
%     Results(i).PD1 = DATA(1:6,:);
%     Results(i).PD2 = DATA(7:12,:);
end

clear Dir fileNames n C Loc formatSpec fileName i DATA

%% Read in the data per rat and organize per measure: 1 datapoint for each SF
% Animals is a structure containing 'data' and 'All' with fillowing columns
% {'Condition' , 'GroupCount' , 'Response' , 'RT', 'RewardTime', 'Time', 'ScreenPokes', 'FrontBeam', 'BackBeam' , 'RewardPokes', 'Date'}

% Animals are devided into 3 groups based on their performance
% group1 = [8,11];
% group2 = [4,6,7];
% group3 = [1,2,3,5,9,10,12];

% Combining the data per SF for different measures 
Response     = nan(6,12);
RT           = nan(6,12);
RewardTime   = nan(6,12);
ScreenPokes  = nan(6,12);
FrontBeam    = nan(6,12);
BackBeam     = nan(6,12);
Time         = nan(6,12);
Count        = nan(6,12);

for i = 1:12
    
    l = size(Results(i).All.Response,1);
    
    Response(1:l,i)     = Results(i).All.Response;
    RT(1:l,i)           = Results(i).All.RT;
    RewardTime(1:l,i)   = Results(i).All.RewardTime;
    Time(1:l,i)         = Results(i).All.Time;
    ScreenPokes(1:l,i)  = Results(i).All.ScreenPokes;
    FrontBeam(1:l,i)    = Results(i).All.FrontBeam;
    BackBeam(1:l,i)     = Results(i).All.BackBeam;
    Count(1:l,i)        = double(Results(i).All.GroupCount);
    
end

clear i l 
