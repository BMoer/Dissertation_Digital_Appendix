function [uuids, title_line3, uuid_query]=Query_Creation3(conn, signal_filter_string)
    
    choice_list={ '2018-03-01 00:00:00', '2018-04-01 00:00:00', '2018-05-01 00:00:00',...
        '2018-06-01 00:00:00', '2018-07-01 00:00:00', '2018-08-01 00:00:00', '2018-09-01 00:00:00', ...
        '2018-10-01 00:00:00', '2018-11-01 00:00:00'};
    [indx,tf] = listdlg('ListString',choice_list,'SelectionMode','single', 'PromptString','Select lower boundary for processes:');
    choice_start=string(choice_list(indx));
    [indx,tf] = listdlg('ListString',choice_list,'SelectionMode','single', 'PromptString','Select upper boundary for processes:');
    choice_stop=string(choice_list(indx));
%     if tf==0
%         %nothing was selected. so no filters are applied.
%         uuid_query=['select distinct borehole_id from boeing_db_structure.boreholes '...
%         'join boeing_db_structure.sensor_deployments on boeing_db_structure.boreholes.experiment=sensor_deployments.experiment '...
%         'join boeing_db_structure.sensors on sensor=sensor_id '... 
%         signal_filter_string...
%         ')'];
%         uuids = table2cell(fetch(conn,uuid_query));
%         title_line3='No Filters Specified';
%         return
%     end
%     
    %filter is applied.
    uuid_query_formatSpec = ['select distinct borehole_id from boeing_db_structure.boreholes '...
    'join boeing_db_structure.sensor_deployments on boeing_db_structure.boreholes.experiment=sensor_deployments.experiment '... 
    'join boeing_db_structure.qualitycards on qualitycards.borehole=borehole_id '... 
    'join boeing_db_structure.tools on tool=tools.tool_id '...
    'join boeing_db_structure.sensors on sensor=sensor_id '... 
    signal_filter_string...
    ') and process_start>''%s'' and process_stop<''%s'''];
    uuid_query=sprintf(uuid_query_formatSpec, choice_start, choice_stop);
    title_line3=sprintf('only processes between %s and %s', choice_start, choice_stop);

    uuids = table2cell(fetch(conn,uuid_query));