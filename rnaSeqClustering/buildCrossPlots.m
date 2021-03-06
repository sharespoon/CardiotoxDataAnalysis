% function buildCrossPlots()

set(0,'DefaultFigureVisible','on');
set(0,'defaultfigurecolor',[1 1 1])

%Load datasets
load('differentialExpressionData/erl_de.mat')
load('differentialExpressionData/lap_de.mat')
load('differentialExpressionData/sun_de.mat')
load('differentialExpressionData/sor_de.mat')
load('differentialExpressionData/ensembleids_de.mat')

%Combine datasets into single array
%Contains expression information for all differentially expressed genes,
%all condiditions
data = [erl_de,lap_de,sor_de,sun_de];

%load indices for ensemble ids for genes of interest
%These need to be generated for every dataset being plotted
load('clusterGeneIndex.mat')


%Cluster indices to plot
%Already have clusters identified from previous g-means run
clusters = 1:13;

%Pull gene expression using saved index
%Separate out dose and time conditions
clusteredData = data(clusterGeneIndex,:)';

%Create cell aray with one array for each cluster,
%containing top 20 genes at all 24 conditions
% Now using all data, not creating separte cell arrays for dose and time

data_cell = cell(1,13);
j = 1;
for i = 1:13
    data_cell{i} = clusteredData(:,j:j+19);
    j = j+20;
end

%Combine Clusters 2 and 7 because both are enriched for the same GO Term:
%Mitotic Cell Cycle
combinedCell = [data_cell{2}(:,1:10) data_cell{7}(:,1:10)];
data_cell{2} = combinedCell;
data_cell = [data_cell(1:6) data_cell(8:end)];

j=1;
%loop through all identified clusters 
for i = 1:12%length(clusters)

    %Split out data columns relevant to each drug for individual plotting
    erl = data_cell{clusters(i)}(1:6,:);
    lap = data_cell{clusters(i)}(7:12,:);
    sor = data_cell{clusters(i)}(13:18,:);
    sun = data_cell{clusters(i)}(19:24,:);
    
    %For plotting
    %Create new custom heatmap (blue - beige - orange, 9 colors)
%     newmap = [69,117,180;88,140,191;128,183,214;174,218,233;239, 233, 195;249,151,86;238,98,62;226,73,50;215,48,39];
%     newmap = newmap./255;
    
    %New darker version
    newmap = [45,90,210;69,117,180;88,140,191;128,183,214;239, 233, 195;238,98,62;226,73,50;215,48,39;240,30,25];
    newmap = newmap./255;

    %%%%%%%%%%%%%%%%%
    %%% Erlotinib %%%
    %%%%%%%%%%%%%%%%%
    
    %This can be left alone if number of genes (20) and conditions (6)
    %remains consistent. Must customize if these change 
    
    %Build array for plotting drug. Inf values will appear as white,
    %matching background. Cross of actual data will be colored
    erl_cross_array = inf(4,60);
    erl_cross_array(2,1:20) = erl(6,:);
    erl_cross_array(:,21:40) = erl(2:5,:);
    erl_cross_array(2,41:60) = erl(1,:);
    erl_cross_array(3,1:20) = 0;
    erl_cross_array(3,40:60) = 0;    
     
   %Create new figure object at first cluster. Will be reused for each additional cluster subplots 
   if j == 1
        figure('Units','centimeters', 'Position', [100, 100, 15.325, 100.031]);
   end
   
   %Add row and column of zeros for account for surf bug cutting off a row
   erl_cross_array(end+1,:) = 0;
   erl_cross_array(:,end+1) = 0;
   
   %Create a subplot for each cross with 4 columns and 13 rows (7 clusters x 4 drugx = 52 subplots)
   %This is figure-specific and can be altered for a different layout
   %Removing subplot calls and instead using 'figure' call for every plot
   %will generate a separate plot for each cross
   
   subplot(12,4,j);
   
   %Plot cross
   h=surf(erl_cross_array');
   %remove black mesh from plot
   set(h,'edgecolor','none')
   %remove x and y axis
   axis off
   %choose which colormap to use
   colormap(newmap)
   %convert 3d plot to 2d
   view(2)
   %set color scale
   caxis([-5.265 5.265]); 
   grid off
   
   %For first cluster (first row) add name of drug as title
%    if i == 1
%        title('Erlotinib','Fontname','Arial','FontWeight','Bold','Fontsize',7)
%    end
   
   %Plot axes labels
   %Only plot y labels on first column
   %Only plot x labels on bottom row
   xticklabels={'6 h','24 h','72 h','168 h'};
   yticklabels={'10 \muM','3 \muM','1 \muM'};
   if any(j==25:28)
       set(gca,'XLim',[1 5],'XTick',1.5:2:4.5,'XTickLabel',xticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
   else
       set(gca,'XLim',[1 5],'XTick',1.5:4.5,'XTickLabel','')
   end
   
   if any(j==1:4:28)
       set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel',yticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
   else
       set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel','')
   end
   j=j+1;
    

    %%%%%%%%%%%%%%%%%
    %%% Lapatinib %%%
    %%%%%%%%%%%%%%%%%
    
    %Build array for plotting drug. Inf values will appear as white,
    %matching background. Cross of actual data will be colored
        lap_cross_array = inf(4,60);
        lap_cross_array(2,1:20) = lap(6,:);
        lap_cross_array(:,21:40) = lap(2:5,:);
        lap_cross_array(2,41:60) = lap(1,:);
        lap_cross_array(3,1:20) = 0;
        lap_cross_array(3,40:60) = 0;    
     
    %Add row and column of zeros for account for surf bug cutting off a row
    lap_cross_array(end+1,:) = 0;
    lap_cross_array(:,end+1) = 0;
    
    %Create a subplot for each cross (7 clusters x 4 drugx = 28 subplots)
    subplot(12,4,j);
        
    %Plot cross
    h=surf(lap_cross_array');
    set(h,'edgecolor','none')
    axis off
    colormap(newmap) %Can choose default or custom colormap
    view(2)
    caxis([-5.265 5.265]); 
    grid off
    
    %For first cluster (first row) add name of drug as title
%     if i == 1
%         title('Lapatinib','Fontname','Arial','FontWeight','Bold','Fontsize',7)
%     end
    
    %Plot axes labels
    %Only plot y labels on first column
    %Only plot x labels on bottom row
    xticklabels={'6 h','24 h','72 h','168 h'};
    yticklabels={'10 \muM','3 \muM','1 \muM'};
    if any(j==25:28)
        set(gca,'XLim',[1 5],'XTick',1.5:4.5,'XTickLabel',xticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
    else
        set(gca,'XLim',[1 5],'XTick',1.5:4.5,'XTickLabel','')
    end
    
    if any(j==1:4:28)
        set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel',yticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
    else
        set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel','')
    end
     j=j+1;
    

    %%%%%%%%%%%%%%%%%
    %%% Sorafenib %%%
    %%%%%%%%%%%%%%%%%

    %Build array for plotting drug. Inf values will appear as white,
    %matching background. Cross of actual data will be colored    
        sor_cross_array = inf(4,60);
        sor_cross_array(2,1:20) = sor(6,:);
        sor_cross_array(:,21:40) = sor(2:5,:);
        sor_cross_array(2,41:60) = sor(1,:);
        sor_cross_array(3,1:20) = 0;
        sor_cross_array(3,40:60) = 0;    

    
    %Add row and column of zeros for account for surf bug cutting off a row
    sor_cross_array(end+1,:) = 0;
    sor_cross_array(:,end+1) = 0;
    
    %Create a subplot for each cross (7 clusters x 4 drugx = 28 subplots)
    subplot(12,4,j);

    %Plot Cross
    h=surf(sor_cross_array');
    set(h,'edgecolor','none')
    axis off
    colormap(newmap) %Choose default or new colormap
    view(2)
    caxis([-5.265 5.265]); 
    grid off
    
    %For first cluster (first row) add name of drug as title
%     if i == 1
%         title('Sorafenib','Fontname','Arial','FontWeight','Bold','Fontsize',7)
%     end

    %Plot axes labels
    %Only plot y labels on first column
    %Only plot x labels on bottom row
    xticklabels={'6 h','24 h','72 h','168 h'};
    yticklabels={'10 \muM','3 \muM','1 \muM'};
    
    if any(j==25:28)
        set(gca,'XLim',[1 5],'XTick',1.5:4.5,'XTickLabel',xticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
    else
        set(gca,'XLim',[1 5],'XTick',1.5:4.5,'XTickLabel','')
    end
    
    if any(j==1:4:28)
        set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel',yticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
    else
        set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel','')
    end
    j=j+1;
    
    
    %%%%%%%%%%%%%%%%%
    %%% Sunitinib %%%
    %%%%%%%%%%%%%%%%%

    %Build array for plotting drug. Inf values will appear as white,
    %matching background. Cross of actual data will be colored 
        sun_cross_array = inf(4,60);
        sun_cross_array(2,1:20) = sun(6,:);
        sun_cross_array(:,21:40) = sun(2:5,:);
        sun_cross_array(2,41:60) = sun(1,:);
        sun_cross_array(3,1:20) = 0;
        sun_cross_array(3,40:60) = 0;    

     
    %Add row and column of zeros for account for surf bug cutting off a row
    %and col
    sun_cross_array(end+1,:) = 0;
    sun_cross_array(:,end+1) = 0;
    
    %Create a subplot for each cross (7 clusters x 4 drugx = 28 subplots)
    subplot(12,4,j);
 
    %Plot cross
    h=surf(sun_cross_array');
    set(h,'edgecolor','none')
    axis off
    colormap(newmap) %Choose default or custom colormap
    view(2)
    caxis([-5.265 5.265]); 
    grid off
    
    %For first cluster (first row) add name of drug as title
%     if i == 1
%         title('Sunitinib','Fontname','Arial','FontWeight','Bold','Fontsize',7)
%     end
    
    %Plot axes labels
    %Only plot y labels on first column
    %Only plot x labels on bottom row
    xticklabels={'6 h','24 h','72 h','168 h'};
    yticklabels={'10 \muM','3 \muM','1 \muM'};
    
    if any(j==25:28)
        set(gca,'XLim',[1 5],'XTick',1.5:4.5,'XTickLabel',xticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
    else
        set(gca,'XLim',[1 5],'XTick',1.5:4.5,'XTickLabel','')
    end
    
    if any(j==1:4:28)
        set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel',yticklabels,'Fontname','Arial','FontWeight','Bold','Fontsize',7)
    else
        set(gca,'YLim',[1 61],'YTick',10:20:50,'YTickLabel','')
    end
    j=j+1


    %Position color bar for final figure
    hp4 = get(subplot(12,4,30),'Position');
    h=colorbar('Position', [hp4(1)+hp4(3)+0.015  hp4(2)-.175  0.0275  hp4(2)+hp4(3)*2.1]);
    set(h,'Fontname','Arial','FontWeight','Bold','Fontsize',7);
   
end

%Save final figure with all 28 crosses
%Uncomment print command to write to file, will overwrite if there's
%another file already present with same name
%Can change file format from svg to png, etc
fn1 = 'crossPlot12.svg';
print(fn1, '-Painters', '-dsvg','-r600')

    