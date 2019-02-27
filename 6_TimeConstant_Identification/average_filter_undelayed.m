function [ts, values]=average_filter_undelayed(ts_raw, values_raw, windowsize)


coeff24hMA = ones(1, windowsize)/windowsize;
values = filter(coeff24hMA, 1, values_raw);
fDelay = (length(coeff24hMA)-1)/2;
ts=ts_raw-fDelay/windowsize;