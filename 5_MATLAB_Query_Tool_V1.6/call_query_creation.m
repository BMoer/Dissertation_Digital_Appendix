function [uuids, title_line3, uuid_query]=call_query_creation(query_choice, conn, signal_filter_string)
    if query_choice==1
        [uuids, title_line3, uuid_query]=Query_Creation1(conn, signal_filter_string);
    elseif query_choice==2
        [uuids, title_line3, uuid_query]=Query_Creation2(conn, signal_filter_string);
    elseif query_choice==3
        [uuids, title_line3, uuid_query]=Query_Creation3(conn, signal_filter_string);
    end