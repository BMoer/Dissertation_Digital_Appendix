function raw_data_struct=create_subplots(conn, signal_type, signal_filter_string, uuids_to_plot, height, subplot_rows, subplot_columns, Signal_Processing_choice, title_line2, title_line3)
    windowsize=1000;

    figure('units','normalized','outerposition',[0 0 1 1])
    raw_data_struct=struct();
    
    tic
    for i=1:size(uuids_to_plot)
        subplot(subplot_rows,subplot_columns,i);
        raw_data_struct(i).data = query_timeseries(conn, signal_type, signal_filter_string, string(uuids_to_plot(i)));
        ts_raw=raw_data_struct(i).data.ts;
        values_raw=raw_data_struct(i).data.value;
        if Signal_Processing_choice==1
            [ts, values]=average_filter(ts_raw, values_raw, windowsize);
        elseif Signal_Processing_choice==2
            [ts, values]=average_filter_undelayed(ts_raw, values_raw, windowsize);
        elseif Signal_Processing_choice==3
            [ts, values]=envelope_filter(ts_raw, values_raw, windowsize);
        else
            ts=ts_raw;
            values=values_raw;
        end
        plot(ts, values);
        raw_data_struct(i).uuids = uuids_to_plot(i);
        xlabel(string(i));
    end
    toc
    
    %% Create and format subplot window.
    a = axes;
    TitleformatSpec ='Random Samples (n_{total}=%d)';
    title_line1=sprintf(TitleformatSpec, height);
    t1 = title({title_line1, title_line2, title_line3});
    a.Visible = 'off'; % set(a,'Visible','off');
    t1.Visible = 'on'; % set(t1,'Visible','on');
    