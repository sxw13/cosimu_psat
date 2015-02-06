close all;
[m,n] = size(statTable);
ActionNum = length(statTable{2,5});
for jj = 5
    x = zeros(1,1:m-1);
    y = zeros(ActionNum,1:m-1);
    AA = [];
    for ii = 2:m
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_Branch_%d_errorRatio_%f_.mat');
%         A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_.mat');
        A = sscanf(statTable{ii,1},'LoadShapeRatio_%f_toBus_%d_errorRatio_%f_duplicate_%d_.mat');
        x(ii-1) = A(2);
        y(:,ii-1) = statTable{ii,jj}';
        AA = [AA A];
    end
    figure('Color',[1 1 1]);
    xx = 1:9;
    M = [];
    for x_value = xx
        idx = find(x==x_value & AA(1,:)==0.5 & AA(3,:)==0.5 & AA(4,:)==1);
        M = [M y(:,idx)];
    end
    imagesc(M);
    title(statTable{1,jj});
end