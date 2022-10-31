clear all; close all; 

addpath('../libraries/tdh/')
addpath('../libraries/m_map2/');
addpath('../libraries/plotting/colormap/')
addpath('../libraries/plotting/')

datadir = '../data/proc/';
fnames = dir([datadir '*.mat']);

load([datadir fnames(1).name])

%%

figure(23);clf

ids = find(cast.statid == 6);
%ids = find(isnan(cast.statid)==1);

idt = find(datenum(2022,9,1) <= cast.time & cast.time <= datenum(2022,10,1));


ax1 = subplot(131);

plot(cast.temp(:,ids),cast.pgrid,'linewidth',2); axis ij 

ax2 = subplot(132);
plot(cast.salt(:,ids),cast.pgrid,'linewidth',2);axis ij

ax3 = subplot(133);
plot(cast.chlr(:,ids),cast.pgrid,'linewidth',2);axis ij

linkaxes([ax1 ax2 ax3],'y')





%%
statxy = [-134.79   57.62; ...
          -134.3158 56.9418; ...
          -133.1847 57.0551; ...
          -134.6142 56.2958; ...
          -133.9797 57.1141; ...
          -135.4954 56.9742; ...
          -136.47   58.24; ...
          -135.00   58.13]; 

statnam = {'S1','S2','S3','S4','S5','S6','S7','S8'}; 



figure(4);clf
    m_proj('mercator','lon',[-137 -131.],'lat',[55. 59.2])
    m_gshhs_h('patch',[1 1 1]*.7,'edgecolor',[1 1 1]*.8); hold on
            m_grid('box','fancy','tickdir','in','fontsize',16)

    hold on
    for ii = 1:length(statxy)
        m_plot(statxy(ii,1),statxy(ii,2),'ko','linewidth',1.5,'markersize',10)
        m_text(statxy(ii,1)+.05,statxy(ii,2)-0.05,statnam{ii},'fontsize',12,'fontweight','bold')

    end


MONTH = 10;     
YEAR = 2022;
idt = find(datenum(YEAR,MONTH,1) <= cast.time & cast.time <= datenum(YEAR,MONTH+1,1));

scols = [1 0 0; 0 1 0; 1 0 1];
sns = [210673 210674 210675];

    for ii = 1:length(idt)
        idsn = find(cast.SN(idt(ii))==sns);
        m_plot(cast.lon(idt(ii)),cast.lat(idt(ii)),'mx','linewidth',2,'markersize',8,'color',scols(idsn,:))

    end

    title([datestr(datenum(YEAR,MONTH,1),'mmmm'),', ' num2str(YEAR)],'fontsize',20)

saveas(gcf,['../figs/station_occupations/' num2str(YEAR) '_' pad(num2str(MONTH),2,'left','0')],'jpg')


%%


F = figure(7);clf
set(F,'position',[50 50 1000 600])

scols = [1 0 0; 0 1 0; 1 0 1];
sns = [210673 210674 210675];

plot(-1,-1,'kx','linewidth',3,'markersize',20,'color',scols(1,:)); hold on
plot(-1,-1,'kx','linewidth',3,'markersize',20,'color',scols(2,:)); hold on
plot(-1,-1,'kx','linewidth',3,'markersize',20,'color',scols(3,:)); hold on
text(datenum(2022,5,1),10,['Total Count (' num2str(length(cast.time)) ')'],'horizontalalignment','center','fontsize',16,'fontweight','bold')

for ii = 1:8
    ids = find(cast.statid==ii);
    for jj = 1:length(ids)
        idsn = find(cast.SN(ids(jj)) == sns);
    end
    plot(cast.time(ids),ii*ones(size(ids)),'kx','linewidth',3,'markersize',20,'color',scols(idsn,:)); hold on
    text(datenum(2022,5,1),ii, ['(' num2str(length(ids)) ')'],'fontsize',16,'fontweight','bold');
end

ids = find(isnan(cast.statid)==1);
    for jj = 1:length(ids)
        idsn = find(cast.SN(ids(jj)) == sns);
    end
    plot(cast.time(ids),9*ones(size(ids)),'kx','linewidth',3,'markersize',20,'color',scols(idsn,:)); hold on
    text(datenum(2022,5,1),9, ['(' num2str(length(ids)) ')'],'fontsize',16,'fontweight','bold');

hold on

ylim([0 10.5])
xlim([datenum(2022,1,1) datenum(2023,1,1)])
xticks(datenum(2022,1:12,1))
yticks(1:9)
yticklabels({'1','2','3','4','5','6','7','8','Other'})
datetick('x','mmm','keeplimits','keepticks')
grid on

set(gca,'fontsize',20)
ylabel('Station #','fontweight','bold')
xlabel('Month (2022)','fontweight','bold')
title('Station Occupations')

legend('210673','210674','210675')



%%

STATION = 6;
ids = find(cast.statid == STATION);

F = figure(3);clf
set(F,'position',[50 50 1200 600])

timelim = [datenum(2022,8,1) datenum(2024,2,1)];

ax1 = axes('position',[.07 .56 .55 .37]);
    tmp = cast.temp(:,ids);
    tmp(isnan(tmp))=-99;
    tmpv = tmp(:);
    
    imagesc(cast.time(ids),cast.pgrid-10,tmp); shading flat; axis ij
    hold on
    plot(cast.time(ids),cast.H(ids),'k','linewidth',3)
    
    xlim(timelim)
    
    %set('ydir','reverse')
    
    c = parula;
    caxis([min(tmpv(tmpv>-10))-.1 max(tmpv)])
    cnew = [1 1 1;c];
    colormap(ax1,cnew)
    
    set(gca,'fontsize',16)
    datetick('x','keeplimits')
    ylabel('Depth [meters]','fontsize',20,'fontweight','bold')
    title(['Station ' num2str(STATION)],'fontsize',30)
    
    hc = colorbar;
    ylabel(hc,'Temperature [Celcius]','fontweight','bold')
    ylim([0 250])
    grid on
    %xticklabels('')

ax2 = axes('position',[.75 .56 .2 .37]);
    
    plot(cast.temp(:,ids),cast.pgrid,'linewidth',3); axis ij
    set(gca,'fontsize',14)
    ylabel('Depth [meters]','fontweight','bold')
    ylim([0 250])
    xlabel('Temperature [Celcius]','fontweight','bold')
    grid on
    title('Individual Casts','fontsize',20)
    text(6.5,20,'TEMPERATURE','fontsize',20,'fontsize',16,'fontweight','bold')


ax3 = axes('position',[.07 .1 .55 .37]);
    tmp = cast.salt(:,ids);
    tmp(isnan(tmp))=-99;
    tmpv = tmp(:);
    
    imagesc(cast.time(ids),cast.pgrid-10,tmp); shading flat; 
    hold on
    plot(cast.time(ids),cast.H(ids),'k','linewidth',3)
    
    xlim(timelim)
    
    
    
    c = flipud(cbrewer('seq','YlGnBu',100))*.97;
    caxis([min(tmpv(tmpv>-10))-.1 max(tmpv)])
    caxis([29.5 32.5])
    cnew = [1 1 1;c];
    colormap(ax3,cnew)

    
    
    set(gca,'fontsize',16)
    datetick('x','keeplimits')
    ylabel('Depth [meters]','fontsize',20,'fontweight','bold')
    
    hc = colorbar;
    ylabel(hc,'Salinity [PSU]','fontweight','bold')
    ylim([0 250])
    grid on


ax2 = axes('position',[.75 .1 .2 .37]);
    
    plot(cast.salt(:,ids),cast.pgrid,'linewidth',3); axis ij
    set(gca,'fontsize',14)
    ylabel('Depth [meters]','fontweight','bold')
    ylim([0 250])
    xlabel('Salinity [PSU]','fontweight','bold')
    grid on    
    text(27,30,'SALINITY','fontsize',20,'fontsize',16,'fontweight','bold')