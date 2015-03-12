function plotTimeFigure(t,x,AA)
N = length(t);
tt = interp1(0:N,[0,t],(1:3*N)/3);

M = length(x);

img = ones(3*M,N,3);

%Ìî³äºìÉ«
[idx,idy] = find(AA>0);
fillter = sparse(idx*3,idy,1,3*M,N);
img(:,:,2) = img(:,:,2)-full(fillter);
img(:,:,3) = img(:,:,3)-full(fillter);

%Ìî³äÂÌÉ«
[idx,idy] = find(AA==0);
fillter = sparse(idx*3,idy,1,3*M,N);
img(:,:,1) = img(:,:,1)-full(fillter);
img(:,:,3) = img(:,:,3)-full(fillter);

imagesc(tt,[1/3 x],img);
set(gca,'YDir','normal');

end