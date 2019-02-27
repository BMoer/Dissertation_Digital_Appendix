function [training, validation]=split_dataset(dataset, ratio)

[n,m]=size(dataset);

training=dataset(randsample(length(dataset),n*ratio),:);
validation=setdiff(dataset, training, 'rows','stable');