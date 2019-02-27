function [ts, values]=average_filter(ts_raw, values_raw, windowsize)

ts=ts_raw;
coeff24hMA = ones(1, windowsize)/windowsize;

values = filter(coeff24hMA, 1, values_raw);


