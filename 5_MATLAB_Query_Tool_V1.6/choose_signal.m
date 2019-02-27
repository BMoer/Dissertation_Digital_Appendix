function [title_line2, signal_filter_string, signal_type]=choose_signal(conn)

    %Create Choice List (Based on Sensors in DB and Others that are defined 
    %manually)
    Signal_types_query='SELECT signaltype FROM  boeing_db_structure.sensors';
    Signal_types_data = table2cell(fetch(conn, Signal_types_query));
    Signal_types_data{end+1}='ForceTotal';
    Signal_types_data=sort(Signal_types_data);

    %ask for user Input, do not accept no input.
    tf=0;
    while tf==0
        [indx,tf] = listdlg('ListString',Signal_types_data,'SelectionMode','single',...
        'PromptString','Select Sensor Signal to Display:','InitialValue',15);
    end

    signal_type=string(Signal_types_data(indx));
    title_line2=string(signal_type);

    if signal_type=='ForceTotal'
        signal_filter_string='where (signaltype=''ForceW1'' or signaltype=''ForceW2'' or signaltype=''ForceW3'' or signaltype=''ForceW4''';
    else
        Signal_filter_stringSpec='where (signaltype=''%s''';
        signal_filter_string=sprintf(Signal_filter_stringSpec, signal_type);
    end