function result=outlier(target, condition)
%%Outlier Filter

[n0, m0]=size(target);

for j=1:m0
    filter_matrix = isnan(target(:,j));
    % remove
    target(filter_matrix,:) = [] ;
end

if strcmp(condition,'zeros')
    for j=1:m0
        col_mean=mean(target(:,j));
        col_std=std(target(:,j));
        if col_mean~=0
            filter_matrix = abs(target(:,j))==0;
            % remove
            target(filter_matrix,:) = [] ;
        end
    end
    result=target;
end

if strcmp(condition,'outlier')
    for j=1:m0
        col_mean=mean(target(:,j));
        col_std=std(target(:,j));
        if col_mean~=0 && col_std>col_mean*0.5
            filter_matrix = abs(target(:,j))>=col_mean+3*col_std;
            % remove
            target(filter_matrix,:) = [] ;
        end
    end
    result=target;
end

if strcmp(condition,'temperatures')
    for j=1:m0
        col_mean=mean(target(:,j));
        col_std=std(target(:,j));
        if col_mean~=0 && col_std>col_mean*0.5
            filter_matrix = abs(target(:,j))>=col_mean+3*col_std;
            % remove
            target(filter_matrix,:) = [] ;
        end
    end
    result=target;
end


end
