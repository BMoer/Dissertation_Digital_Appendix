clear, clc
% %
% Signal Procesing choices
% Option 0: No Signal Processing
% Option 1: Moving average
% Option 2: Moving average (Filtered)
% Option 3: Peak Envelope
Signal_Processing_choice=1;

time_constant_1=0.2; %manually determined duration of the target phenomenon
time_constant_2=0.33; %manually determined duration of the target phenomenon
sensor_samplingrate=2000;
minimum_samling_frequency_1=1/(time_constant_1)*2;
windowsize_1=round(sensor_samplingrate/minimum_samling_frequency_1,0);
minimum_samling_frequency_2=1/(time_constant_2)*2*pi*2;
windowsize_2=round(sensor_samplingrate/minimum_samling_frequency_2,0);

output_path=struct();
%specify output data source path
folder_name='data_export_folder\Sample_data';

%% User Input ENDS Here
%read data

files=dir(fullfile(folder_name,'6dad4491-f4e2-41b5-b9d4-95ffe3caab70.csv'));

no_of_signals=size(files);
height=no_of_signals(1);
figure

for i=1:height
    data(i).path=fullfile(folder_name,files(i).name);
    data(i).data= csvread(data(i).path, 2,0) ;
    data(i).data(:,1)=data(i).data(:,1)-data(i).data(1,1);
    %% apply filter
    %windowsize=2^i;
    if Signal_Processing_choice==1
        [ts_filtered_1, values_filtered_1]=average_filter(data(i).data(:,1), data(i).data(:,2),windowsize_1);
        [ts_filtered_2, values_filtered_2]=average_filter(data(i).data(:,1), data(i).data(:,2),windowsize_2);
    elseif Signal_Processing_choice==2
        [ts_filtered_1, values_filtered_1]=average_filter_undelayed(data(i).data(:,1), data(i).data(:,2),windowsize_1);
        [ts_filtered_2, values_filtered_2]=average_filter_undelayed(data(i).data(:,1), data(i).data(:,2),windowsize_2);
    elseif Signal_Processing_choice==3
        [ts_filtered_1, values_filtered_1]=envelope_filter(data(i).data(:,1), data(i).data(:,2),windowsize_1);
        [ts_filtered_2, values_filtered_2]=envelope_filter(data(i).data(:,1), data(i).data(:,2),windowsize_2);
    else
        ts_filtered_1=data(i).data(:,1);
        values_filtered_1= data(i).data(:,2);
        ts_filtered_2=data(i).data(:,1);
        values_filtered_2= data(i).data(:,2);
    end
    data(i).data_filtered_1(:,1)=ts_filtered_1;
    data(i).data_filtered_1(:,2)=values_filtered_1;
    data(i).data_filtered_2(:,1)=ts_filtered_2;
    data(i).data_filtered_2(:,2)=values_filtered_2;
    %% plot data
    
    subplot(1,1,i);
    plot(data(i).data(:,1), data(i).data(:,2),'','DisplayName','Measured Values',...
    'Color',[0 0.498039215803146 0]);
    hold on 
    [x_exp, y_exp]=manual_data(sensor_samplingrate);
    plot(x_exp, y_exp,'DisplayName','Expected Shape','LineWidth',4,'Color',[1 0 0]); % expected values
    plot(data(i).data_filtered_1(:,1), data(i).data_filtered_1(:,2),...
        'DisplayName','Fildered Measurements 1','LineWidth',4,'Color',[0 0 0]); % filtered values
    plot(data(i).data_filtered_1(:,1), data(i).data_filtered_2(:,2),...
        'DisplayName','Fildered Measurements 2','LineWidth',4,'Color',[0.5 0.5 0.5]); % filtered values
    hold off
    fontize=32;
    set(gca,...
    'Units','normalized',...
    'Position',[.15 .2 .75 .7],...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',fontize,...
    'FontName','Times')
    
    % Create axis labels 
    ylabel({'Force [N]'},...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',fontize,...
    'FontName','Times')
    xlabel({'Time [s]'},...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',fontize,...
    'FontName','Times')
    % set axis limits
    ylim([-50 1300])
    xlim([0 6])
    % set legend
%     legend({'Measurements','Expected Shape'},'FontUnits','points',...
%     'interpreter','latex',...
%     'FontSize',fontize,...
%     'FontName','Times',...
%     'Location','NorthWest')
    legend({'Measurements','Expected Shape','Filtered Values ($T_{g}=0.2$)','Filtered Values ($T_{g}=0.33$)'},'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',fontize-4,...
    'FontName','Times',...
    'Location','NorthWest')
end



