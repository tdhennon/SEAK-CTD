function [dzdt dzdt_CI,tmask] = my_dzdt(tvector,yvector,zgrid,xids,p_or_d) 

tmask = NaN(length(yvector),length(xids)-1,2);

    for i = 1:length(xids)-1
        %Initialize vectors
              dzdt(1:length(yvector),i)     = NaN;
           dzdt_CI(1:length(yvector),i,1:2) = NaN;
           
       % Now go along each pressure surface to find o2 consumption
       for j = 1:length(yvector) 
             
           % find concentration and time along each pressure surface
             zsurf = zgrid(j,xids(i):xids(i+1));
             xsurf = tvector(xids(i):xids(i+1)); 

           % Find NaNs in o2 record (most nans are due to being above MLD)
             iduse = find(isnan(zsurf) == 0);
           
           % Find uninterupted segments of O2 under mixed layer
           if isempty(iduse) == 1
               tlen = NaN;
           elseif isempty(iduse) == 0
              [id0 idf] = my_consec(iduse);
                     lengths = idf-id0;
                  [x idlong] = max(lengths);
                         id0 = id0(idlong);
                         idf = idf(idlong);   
                        tlen = xsurf(iduse(idf)) - xsurf(iduse(id0));
           end
                       
           if tlen > 100
              % Use time & o2 of longest uninteruped segment
                  tuse =  xsurf(iduse(id0):iduse(idf)); 
                  zuse =  zsurf(iduse(id0):iduse(idf)); 
                  if length(tuse) < 4
                      continue
                  end
                  
              % Chop off ends to make sure mixed layer water is not included
                     cut = 2; 
                    tuse = tuse(1+cut:end-cut);
                    zuse = zuse(1+cut:end-cut);
              % Calculate oxygen time gradient by taking slope
                  [coef,coef_CI] = regress(zuse',[ones(size(tuse')) tuse']);
                       dzdt(j,i)     = coef(2);
                      dzdt_CI(j,i,:) = coef_CI(2,:);

                
              % Plot for visualizing pressure surfaces Used (i.e. not in mixed layer)

             %     if strcmp(p_or_d,'pres')==1
             %       if rem(j,10) == 0
             %         plot([tuse(1) tuse(end)],[yvector(j) yvector(j)],'k')
             %       end
             %       if j == 300
             %         cmap = jet(length(xids));
             %         plot([tuse(1) tuse(end)],[yvector(j) yvector(j)], ...
             %              'm','linewidth',10,'color',cmap(i+1,:))
             %         text([tuse(1)+50],[475],['YEAR ',num2str(i)],'fontsize',20)
             %       end
             %     elseif strcmp(p_or_d,'dens')==1
             %       if rem(j,20)==0
             %         plot([tuse(1) tuse(end)],[yvector(j),yvector(j)],'k')
             %       end
             %       if j == 600
             %         cmap = jet(length(xids));
             %         plot([tuse(1) tuse(end)],[30 30], ...
             %             'm','linewidth',10,'color',cmap(i+1,:))
             %         text([tuse(1)+50],[30.18],['YEAR ',num2str(i)],'fontsize',20)
             %       end
             %     end
                  
                  tmask(j,i,1) = tuse(1);
                  tmask(j,i,2) = tuse(end); 
           
           end     
       end           
    end