%% Import data: .csv files created by SF2_calculateeResults.m

Dir = 'E:\Spatial_Frequency_Range 18-08-2016\Data Extracted\Results\';


% filenames = dir([Dir '*.xlsx']);
% filenames.name;
% Animals = struct('Name', [],'SF',[], 'New', [], 'Old', []);
% 
% for j = 1:12
%    % Read in the data
%    Name = filenames(j).name;
%    Animals(j).SF  = xlsread([Dir Name], 'New', 'B:B');
%    Animals(j).New = xlsread([Dir Name], 'New', 'E:E');
%    Animals(j).Old = xlsread([Dir Name], 'Old', 'E:E');
%    Animals(j).Name = Name;
% end

% or

load('Animals.mat')
      
%% Determine performance on last day of SF
rep  = zeros(4,12);
SF   = zeros(4,12);
Perf = zeros(4,12);
edges = [0 0.0700 0.1300 0.2500 0.50];

for i = 1:12
    %[C, Loc1, ]  = unique(Animals(i).SF, 'first');
    [C, Loc2, ]  = unique(Animals(i).SF(1:end-1), 'last');
    n = length(Loc2);
    %rep(1:n,i)  = Loc2-Loc1 + 1
    SF(1:n,i)    = C;
    Perf(1:n,i)  = Animals(i).New(Loc2);
    rep(1:4,i)   = histcounts(Animals(i).SF(1:end-1),edges)';
end
index = find(rep == 6 | rep == 0);
rep(index) = nan;
rep(2,12) = 6;
rep(2,9) = 6;
rep(4,8) = 6;

index = find(Perf == 0);
Perf(index) = nan;

clear Loc2 C index edges i n
%% Mean performance per SF
fig = figure();
set(fig, 'Position', [ -1000 200 400 350] )

    y = [mean(Perf,2, 'omitnan') std(Perf,[],2, 'omitnan')];
    b = bar(y, 'stacked');
   
    b(1).FaceColor = [0.6 0.6 0.6];
    b(1).EdgeColor = 'none';
    b(2).FaceColor = [0.8 0.8 0.8];
    b(2).EdgeColor = 'none';
    legend('Mean', 'StDev', 'Location', 'Southeast');
    text( [0.75 1.75 2.75 3.75] ,y(:,1) - 5 ,num2str(y(:,1) , 4));
    
    ax = gca;
    ax.XTickLabel = {'0.06' '0.12' '0.24' '0.48*'}; 
    ax.YLim = [0 100];
    ax.FontSize = 12.0;
    ax.FontName = 'Helvetica';
    ax. LineWidth = 1.0;
    
    
    title('Group performance');
    ylabel('Performance (%)');
    xlabel('Spatial frequency (cpd)');
    
    clear b y ax
    
[p, anova, stats] = anova1(Perf' ,['0.06'  '0.12' '0.24' '0.48'], 'off' )
c = multcompare(stats, 'Display','off')
% 
%% Mean training days per SF
fig = figure();
set(fig, 'Position', [ -1000 200 400 350] )

    y = mean(rep,2, 'omitnan');
    b = bar(y);
    
    % bar properties
    b.FaceColor = [0.6 0.6 0.6];
    b.EdgeColor = 'none';
    
    % axis properties
    ax = gca;
        ax.XTick = 1:4;
        ax.XTickLabel = {'0.06' '0.12' '0.24' '0.48'}; 
        ax.FontSize = 12.0;
        ax.FontName = 'Helvetica';
        ax. LineWidth = 1.0;
    
    title('Training sessions');
    ylabel('n sessions');
    xlabel('Spatial frequency (cpd)');
    legend('Mean', 'Location', 'Southeast');
    
    text([0.9 1.9 2.9 3.9], y(:)-0.2 ,num2str(y(:) , 2));

    clear y b ax 
    
%     [p, anova, stats] = anova1(rep' ,[], 'off' )
%     [c,m] = multcompare(stats, 'Display','on')
    %%
% Animals that reach criterion in a certain SF
    for i = 1:4
        criterion(i) = sum(Perf(i,:) >= 75);
    end
        
   fig = figure();
    set(fig, 'Position', [ -1000 200 400 350] )
    
    b1 = bar(1:4,criterion);
    
    % bar properties
    b1.FaceColor = [0.6 0.6 0.6];
    b1.EdgeColor = 'none';
    
    % axis properties
    ax = gca;
        ax.XTick = 1:4;
        ax.XTickLabel = {'0.06' '0.12' '0.24' '0.48'}; 
        ax.YLim = [0 13];
        ax.FontSize = 12.0;
        ax.FontName = 'Helvetica';
        ax. LineWidth = 1.0;
    title('performance >= 75% ');
    ylabel('n animals');
    xlabel('Spatial frequency (cpd)');
    text([0.9 1.9 2.9 3.9], criterion(:) + 0.5 ,num2str(criterion(:) , 2));
    
    %clear b1 ax criterion i
  %%
  SF 
  Perf
  rep
  
  clear C Dir filenames  Name index j
    
    