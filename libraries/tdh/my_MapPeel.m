function my_MapPeel(londata,latdata,mcolor,msize,cbins,cval);

    Slongs=[-80 100; 100 280; -80  25;  25 180; 180 280];
    Slats= [   0  90;  0  90; -90  0;-90   0; -90   0];
    
    Slongs = [-180 180];
    Slats = [-90 90];

% Modify longitudes to fit in window
lonmin = min(Slongs(:,1)); 
lonmax = max(Slongs(:,2));
londata(londata<lonmin) = londata(londata<lonmin)+360;
londata(londata>lonmax) = londata(londata>lonmax)-360;

[a b] = size(Slongs);
for l=1:a
 m_proj('mollweide','long',Slongs(l,:),'lat',Slats(l,:));
 m_grid('fontsize',6,'xticklabels',[],'xtick',[-180:45:360],...
        'ytick',[-80:40:80],'yticklabels',[],'linest','-','color','k');
 m_coast('patch',[.6 .6 .6]*0);
 hold on
 
 idx = find(Slongs(l,1) <= londata & londata < Slongs(l,2));
 idy = find(Slats(l,1)  <= latdata & latdata < Slats(l,2));
  id = intersect(idx,idy); 

cmap = parula(length(cbins)-1); %parula colormap?
    if var(cval) ~= 0
        for i = 1:length(cbins)-1
           idb = find(cbins(i) <= cval(id) & cval(id) < cbins(i+1));
           m_plot(londata(id(idb)),latdata(id(idb)),'o','markerfacecolor',cmap(i,:), ...
                  'markersize',msize,'markeredgecolor','none')
           alpha(1)
        end  
         %Plot those outside color bins
           idb = find(cbins(end) <= cval(id));
           m_plot(londata(id(idb)),latdata(id(idb)),'o','markerfacecolor',cmap(end,:),...
                  'markersize',msize,'markeredgecolor','none')
           idb = find(cval(id) < cbins(1));
           m_plot(londata(id(idb)),latdata(id(idb)),'o','markerfacecolor',cmap(1,:),...
                  'markersize',msize,'markeredgecolor','none')      
           alpha(1)
    else
        m_plot(londata(id),latdata(id),'o','markersize',msize,'markerfacecolor',mcolor,'markeredgecolor',mcolor)
    end

end;

%xlabel('Interrupted Mollweide Projection of World Oceans');
set(gca,'xlimmode','auto','ylimmode','auto');