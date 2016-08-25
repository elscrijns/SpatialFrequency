%% Read in the data per rat and organize per measure: 1 datapoint for each SF
Dir = 'E:\  ';
fileNames = dir([Dir 'Results_*.csv ']);
n = size(fileNames,1)

for i =  1:12
    fileName = fileNames(i).name
    formatSpec = '%f%d%f%f%f%f%f%f%f%f%s';
    DATA = readtable([Dir fileName],'Delimiter',',','Format',formatSpec, 'ReadVariableNames', true);
    DATA.Properties.VariableNames = {'Condition' , 'GroupCount' , 'Response' , 'RT', 'RewardTime', 'Time', 'ScreenPokes', 'FrontBeam', 'BackBeam' , 'RewardPokes', 'Date'};

    Results(i).name = fileName;
    Results(i).All = DATA;           % All training days
end

clear Dir fileNames n C Loc formatSpec fileName i DATA

%% Read in the data per rat and organize per measure: 1 datapoint for each SF
% Animals is a structure containing 'data' and 'All' with fillowing columns
% {'Condition' , 'GroupCount' , 'Response' , 'RT', 'RewardTime', 'Time', 'ScreenPokes', 'FrontBeam', 'BackBeam' , 'RewardPokes', 'Date'}

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
