function [ts, values]=envelope_filter(ts_raw, values_raw, windowsize)

[envHigh, envLow] = envelope(values_raw,windowsize,'peak');
envMean = (envHigh+envLow)/2;

ts=ts_raw;
values=envMean;
