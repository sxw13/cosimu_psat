function [x_est, x_range] = ksEstimation(x,alpha)
    if nargin<2
        alpha = 0.01;
    end
    n = size(x,1);
    x_est = zeros(n,1);
    x_range = zeros(n,2);
    for i=1:n
        x_range(i,:) = ksdensity(x,[alpha,1-alpha],'function','icdf');
        [f xi] = ksdensity(x);
        x_est(i) = xi(find(f==max(f),1));
    end
end