function [raw_data_struct]=data_exploration(db_info, query_choice, max_plots,...
    subplot_rows, subplot_columns, Signal_Processing_choice, fix_seed_flag)
    %% Get list of processes
    conn = database(db_info.datasource,db_info.username,db_info.password,db_info.driver,db_info.url);

    %% First, the user can choose the signal
    [title_line2, signal_filter_string, signal_type]=choose_signal(conn);
    
    %% Then, User Predefined SQL Queries are parameterized based on user input.
    %User chooses Filter-results in list of all drilling processes that have 
    %measurements for defined signal and according to the defined filters
    if query_choice~=4
    [uuids, title_line3]=call_query_creation(query_choice, conn, signal_filter_string);
    else
        uuids="186e3b79-f48c-493f-93a8-558e3b16055d";
        title_line2="";
        title_line3="";
    end
    
    %% For plotting, the total number of measurements is reduced if necessary
    [uuids_to_plot, height]=random_selection(uuids, max_plots, fix_seed_flag);
    
    %% For the selected boreholes, retrieve measurements for defined signal
    % in the defined windows and visualise results.
    raw_data_struct=create_subplots(conn, signal_type, signal_filter_string, uuids_to_plot, height, subplot_rows, subplot_columns, Signal_Processing_choice, ...
        title_line2, title_line3);
    
    %% Close connection to database
    close(conn)