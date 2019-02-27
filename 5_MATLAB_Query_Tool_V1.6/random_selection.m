function [uuids_to_plot, height]=random_selection(uuids, max_plots, fix_seed_flag)
    
    uuids_size=size(uuids);
    height=uuids_size(1);

    %If necessary, take random sample
    if fix_seed_flag==1
        rng(42) %ONLY for debugging
    end

    if height>max_plots
        uuids_to_plot = datasample(uuids,max_plots);
    else
        uuids_to_plot=uuids;
    end
