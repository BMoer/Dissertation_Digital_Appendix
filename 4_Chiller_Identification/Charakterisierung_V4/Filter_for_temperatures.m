function target=Filter_for_temperatures(data,col,upper_limit,lower_limit)
target=data;
% disp('2')
filter_matrix= target(:,col)<lower_limit;
% disp('4')
target(filter_matrix,:) = [] ;
% disp('6')
filter_matrix= target(:,col)>upper_limit;
% disp('8')
target(filter_matrix,:) = [] ;
