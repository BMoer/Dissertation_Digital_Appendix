function Time_series_data=query_timeseries(conn, signal_type, signal_filter_string, borehole_id)

    %% Execute query and fetch results for chosen time series data.
    if signal_type=='ForceTotal'
        %in the case of Total Force Measurements, several Measurements need to
        %be combined.
        Time_series_data=Sum_Forces(conn, signal_filter_string, borehole_id);
    else
        %for the simple case, that just "normal" Sensor readings are of interest,
        %simply the respective datatable is queried for the specified period.
        Time_series_data=simple_time_series_query(conn, signal_filter_string, borehole_id);
    end
    