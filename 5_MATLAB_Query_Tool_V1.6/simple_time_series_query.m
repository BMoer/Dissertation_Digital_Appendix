function Time_series_data=simple_time_series_query(conn, signal_filter_string, borehole_id)

    %% For the defined Borehole and signaltype, get start, stop and datatables
    Process_data_querySpec = ['select process_start, process_stop, data_table from boeing_db_structure.boreholes ' ...
        'join boeing_db_structure.sensor_deployments on boeing_db_structure.boreholes.experiment=sensor_deployments.experiment ' ...
        'join boeing_db_structure.sensors on sensor=sensor_id ' ...
        signal_filter_string...
        ' and borehole_id=''%s'')'];
    Process_data_query=sprintf(Process_data_querySpec,borehole_id);
    Process_data = fetch(conn,Process_data_query);

    start=datetime(Process_data.process_start(1,1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    stop=datetime(Process_data.process_stop(1,1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');
    data_table=Process_data.data_table(1,1);

    %% Query Time Series Data

    Time_series_dataSpec ='SELECT * FROM postgres.monitoring_data."%s" WHERE ts > ''%s''AND ts < ''%s''';
    Time_series_query=sprintf(Time_series_dataSpec, string(data_table), string(start), string(stop));
    Time_series_data = fetch(conn,Time_series_query);
    
    Time_series_data.ts=datetime(Time_series_data.ts ,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS');

    