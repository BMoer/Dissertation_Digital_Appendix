function [time_constant, time_constant_std]=estimate_timeconstant(conn, signal_type, signal_filter_string, uuids_for_identification, height, Signal_Processing_choice)

raw_data_struct=struct();

tic
for i=1:size(uuids_for_identification)
    subplot(subplot_rows,subplot_columns,i);
    raw_data_struct(i).data = query_timeseries(conn, signal_type, signal_filter_string, string(uuids_to_plot(i)));
    ts_raw=raw_data_struct(i).data.ts;
    values_raw=raw_data_struct(i).data.value;
    if Signal_Processing_choice==1
        [ts, values]=average_filter(ts_raw, values_raw, windowsize);
    elseif Signal_Processing_choice==2
        [ts, values]=average_filter_undelayed(ts_raw, values_raw, windowsize);
    elseif Signal_Processing_choice==3
        [ts, values]=envelope_filter(ts_raw, values_raw);
    end
    plot(ts, values);
    raw_data_struct(i).uuids = uuids_to_plot(i);
    xlabel(string(i));
end
toc