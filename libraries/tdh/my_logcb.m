function my_logcb(hC,l,lab)

%pcolor(lon,lat,d); shading flat

%d = log10(D);
%hC = colorbar;
caxis([log10(min(l))-.001 log10(max(l))+.001])

%l = [1 2 3 4];
for i = 1:length(l)
    L{i} = num2str(l(i));
end    
set(hC,'Ytick',log10(l),'YTicklabel',L);
set(get(hC,'ylabel'),'string',lab,'fontsize',16)
