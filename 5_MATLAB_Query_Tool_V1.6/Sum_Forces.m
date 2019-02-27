function total_force=Sum_Forces(conn, signal_filter_string, borehole_id)
    %Function that adds force measurements to result in a total force
    %equivalent at a given position
    Process_data_querySpec = ['select data_table, process_start, process_stop ' ...
    'from boeing_db_structure.boreholes join boeing_db_structure.sensor_deployments ' ...
    'on boeing_db_structure.boreholes.experiment=sensor_deployments.experiment ' ...
    'join boeing_db_structure.sensors on sensor=sensor_id ' ...
    signal_filter_string ...
    ') and borehole_id=''%s'''];

    Process_data_query=sprintf(Process_data_querySpec, borehole_id);
    Process_data = fetch(conn, Process_data_query);

    start=datetime(Process_data.process_start(1,1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    stop=datetime(Process_data.process_stop(1,1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    data_tables = table2cell(Process_data(:,{'data_table'}));

    %% Execute query and fetch results (could be improved)
    formatSpec ='SELECT * FROM postgres.monitoring_data."%s" WHERE ts > ''%s''AND ts < ''%s''';

    queryW1=sprintf(formatSpec,string(data_tables(1)), string(start), string(stop));
    queryW2=sprintf(formatSpec,string(data_tables(2)), string(start), string(stop));
    queryW3=sprintf(formatSpec,string(data_tables(3)), string(start), string(stop));
    queryW4=sprintf(formatSpec,string(data_tables(4)), string(start), string(stop));
    dataW1 = fetch(conn,queryW1);
    dataW2 = fetch(conn,queryW2);
    dataW3 = fetch(conn,queryW3);
    dataW4 = fetch(conn,queryW4);
    dataW1.ts=datetime(dataW1.ts ,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    dataW1.Properties.VariableNames={'ts','value1'};
    dataW2.ts=datetime(dataW2.ts ,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    dataW2.Properties.VariableNames={'ts','value2'};
    dataW3.ts=datetime(dataW3.ts ,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    dataW3.Properties.VariableNames={'ts','value3'};
    dataW4.ts=datetime(dataW4.ts ,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    dataW4.Properties.VariableNames={'ts','value4'};
    data_all=join(dataW1, dataW2);
    data_all=join(data_all, dataW3);
    data_all=join(data_all, dataW4);
    data_all.sum=data_all.value1+data_all.value2+data_all.value3+data_all.value4; %NAIVE APPROACH!
%     data_all.Properties.VariableNames = {'ts' 'value1' 'value2' 'value3' 'value4' 'value'};
    total_force=data_all(:,{'ts','value'});
%     total_force=data_all;