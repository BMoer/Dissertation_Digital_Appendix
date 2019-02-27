function [x,y]=manual_data(samplingrate)

x=linspace(0,6,6*samplingrate);

y1=linspace(0,0,2.2*samplingrate);
y2=linspace(0,650,0.6*samplingrate);
y3=linspace(650,650, 2.35*samplingrate);
y4=linspace(650,0, 0.6*samplingrate);
y5=linspace(0,0, 0.25*samplingrate);
y=[y1 y2 y3 y4 y5];