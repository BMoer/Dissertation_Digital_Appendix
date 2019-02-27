function [time_constant, time_constant_std]=system_Identification(db_info, n_sample)

    %% Get list of processes
    conn = database(db_info.datasource,db_info.username,db_info.password,db_info.driver,db_info.url);

    %% First, the user can choose the signal
    [title_line2, signal_filter_string, signal_type]=choose_signal(conn);
    
    %% Then, User Predefined SQL Queries are parameterized based on user input.
    %User chooses Filter-results in list of all drilling processes that have 
    %measurements for defined signal and according to the defined filters
    [uuids, title_line3]=call_query_creation(query_choice, conn, signal_filter_string);
    
    %% Number of Processes is reduced according to chosen sample size
    [uuids_for_identification, height]=random_selection(uuids, n_sample, fix_seed_flag);
    
    %% For the selected boreholes, retrieve measurements for defined signal
    % in the defined windows and calculate a common time constant
    [time_constant, time_constant_std]=estimate_timeconstant(conn, signal_type, signal_filter_string,...
        uuids_for_identification, height, Signal_Processing_choice);
    
    %% Close connection to database
    close(conn)
