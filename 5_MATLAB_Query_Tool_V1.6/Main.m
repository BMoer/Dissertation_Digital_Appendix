db_info.datasource = 'postgres';
db_info.username = 'read_only_external';
db_info.password = 'H6LSMMj7FKFH9UwKAnQf';
db_info.driver = 'org.postgresql.Driver';
db_info.url = 'jdbc:postgresql://128.130.104.12:5901/postgres';

%% User Input Starts Here
% Choose Mode
%Option 1: Exploration Mode
%Option 2: Export Mode
%Option 3: System Identification Mode
mode_choice=1;

%Parameters for Data Exploration
%Define maximum number of plots (only relevant, if plot_data_flag==1)
plot_data_flag=1;
max_plots=12;
subplot_rows=3;
subplot_columns=4;

%Choose Predefined Query 
%Option 1: Tooltype (coated vs. uncoated drills);
%Option 2: Material AND Tooltypes;
%Option 3: Time Window;
%Option 4: particular uuid
query_choice=4;
fix_seed_flag=0;

%Data export parameters
export_path=fullfile(pwd,'data_export_folder');

%Signal Procesing choices
%Option 0: No Signal Processing
%Option 1: Moving average
%Option 2: Moving average (Filtered)
%Option 3: Peak Envelope

Signal_Processing_choice=0;

%User Input ENDS Here
%%
if mode_choice==1
    % Exploration Mode
    raw_data=data_exploration(db_info, query_choice, max_plots, subplot_rows, subplot_columns, Signal_Processing_choice, fix_seed_flag);
    collection=interactive_export(max_plots, export_path, raw_data);
elseif mode_choice==2
    %Export Mode
    uuid_query=data_query(db_info, export_path, query_choice);
elseif mode_choice==3
    %Identification Mode
    system_Identification(db_info, db_info, n_sample);    
end


