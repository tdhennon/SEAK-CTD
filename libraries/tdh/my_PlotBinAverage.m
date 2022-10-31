function my_PlotBinAverage(xnew,ynew,bins)


%xnew = myfit; ynew = b1;
%        bins = prctile(xnew,[0:100/5:100]);
        
        clear xfill yfillmean yfillCI
        for i = 1:length(bins)-1
            id = find(bins(i) < xnew & xnew < bins(i+1));
            
            xfill(i) = mean([bins(i) bins(i+1)]);
            [yfillmean(i) x yfillCI(i,:) y] = normfit(ynew(id),.05);
            
            plot([xfill(i) xfill(i)],yfillCI(i,:),'color',[1 1 1]*.3,'linewidth',3)
            
             %Use bars to represent the confidence intervals (better
             %represents x-range of averaging windows.
                 %fill([xper(i) xper(i+1) xper(i+1) xper(i)],...
                 %[yfillCI(i,1) yfillCI(i,1) yfillCI(i,2),yfillCI(i,2)],...
                 %'k','edgecolor','none','facealpha',.35)
             
        end
            
        fill([xfill fliplr(xfill)],[yfillCI(:,1); flipud(yfillCI(:,2))],'m',...
        'edgecolor','none','facealpha',.35)     