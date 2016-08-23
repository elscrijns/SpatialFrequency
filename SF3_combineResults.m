% Combine Performnace and SF data of all animals in 1 matrix.
%
% Edited by Els Crijns
%
% Last edited on 23-08-2016

%%

SF = load('SF_SpatialFrequency.csv');

SF1 = [repmat([0.015; 0.03],1,12); SF];
SF1(find(SF1 == 0)) = 0.48;

%SF1 = [repmat(0,1,12); SF1; repmat(0.7,1,12)];

%%
Perf = load('SF_Performance.csv');

Perf1 = [ 93.9, 78.8, 82.4, 81.8, 97.1, 90.9, 76.5, 87.9, 84.8, 82.4, 97.0, 75.8; ...
    88.2, 88.2, 81.8, 93.9, 97.0, 94.1, 93.9, 97.0, 97.0, 87.9, 100, 82.4; Perf ];
Perf1(find(isnan(Perf1))) = 50;

%Perf1 = [repmat(50,1,12); Perf1; repmat(50,1,12)];
%%
Rep = load('SF_Repetitions.csv');
