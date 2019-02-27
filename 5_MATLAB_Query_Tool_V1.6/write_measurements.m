function write_measurements(conn, export_path, uuids, signal_type, signal_filter_string)    
    tic    
    uuids_size=size(uuids);
    height=uuids_size(1);
    
    for i=1:height
        uuid=uuids(i);  
        try
            data = query_timeseries(conn, signal_type, signal_filter_string, string(uuid));
            data.ts=posixtime(data.ts);
            filename=string(uuid)+'.csv';
            filepath=fullfile(export_path,filename);
            writetable(data,filepath);    
        catch
            warning_text=sprintf('problem appeare for UUID %s', string(uuid));
            warning(warning_text);
        end
        if mod(i, 10)==0
            progress=i/height*100; 
            disp(progress)
        end
    end
    toc