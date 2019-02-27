function uuid_query=data_query(db_info, export_path, query_choice)
    %% Get list of processes
    conn = database(db_info.datasource,db_info.username,db_info.password,db_info.driver,db_info.url);

    %% First, the user can choose the signal
    [title_line2, signal_filter_string, signal_type]=choose_signal(conn);
    
    %% Then, User Predefined SQL Queries are parameterized based on user input.
    %User chooses Filter-results in list of all drilling processes that have 
    %measurements for defined signal and according to the defined filters
    [uuids, title_line_3, uuid_query]=call_query_creation(query_choice, conn, signal_filter_string);
    
    %% For the selected boreholes, retrieve measurements for defined signal
    % in the defined windows and visualise results.
    write_measurements(conn, export_path, uuids, signal_type, signal_filter_string) 
    
    %% Close connection to database
    close(conn)