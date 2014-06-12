function r=action2Ratio(a,Naction,step,offset)
    M = length(Naction);
    if nargin<4 offset=ones(1,M); end
    actions = zeros(1,M);
    a = a-1;
    for i = 1:M
        actions(i) = mod(a,Naction(i));
        a = floor(a/Naction(i));
    end
    actions = actions + 1;
    r = floor(actions - Naction/2) .* step + offset;
end