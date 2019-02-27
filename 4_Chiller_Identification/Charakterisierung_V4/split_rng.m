function [training, validation]=split_rng(X, ratio)

[num_points,m] = size(X);
split_point = round(num_points*ratio);
seq = randperm(num_points);
training = X(seq(1:split_point),:);
validation = X(seq(split_point+1:end),:);