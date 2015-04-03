set(gca,'XTick',[0 1:length(xx) length(xx)+1]);
xlabels = {''};
for idx = 1:length(xx)
    xlabels{1+idx} = num2str(xx(idx)); 
end
xlabels{2+length(xx)} = '';
set(gca,'XTickLabel',xlabels);
xlim(gca,[0 length(xx)+1]);
grid on;