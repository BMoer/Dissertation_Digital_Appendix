function collection=data_export(choices, export_path, raw_data_struct)

choices_size=size(choices);
height=choices_size(2);

%%Choose only relevant data

for i=1:height
    data=raw_data_struct(choices(i)).data;
    data.ts=posixtime(data.ts);
    uuid=raw_data_struct(choices(i)).uuids;
    collection(i).data = data;
    collection(i).uuids=uuid;
    filename=string(uuid)+'.csv';
    filepath=fullfile(export_path,filename);
    writetable(data,filepath);
end
