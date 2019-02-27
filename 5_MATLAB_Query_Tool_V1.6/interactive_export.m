function collection=interactive_export(max_plots, export_path, raw_data)
    %%
    %data export, if user selected subplots
    %Default Location for Exports: (pwd/data_exports)  
    %%
    %Subplot selection dialog
    tf=1;
    collection=struct;
    while tf==1
        A = 1:1:max_plots;
        List = sprintfc('%g',A);
        [indx,tf] = listdlg('ListString',List);
        if tf==1
            choices=indx;
            collection=data_export(choices, export_path, raw_data);
        end
    end