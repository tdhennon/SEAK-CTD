clear all; close all; 

addpath('../libraries/tdh/')
addpath('../libraries/m_map2/');
addpath('../libraries/plotting/colormap/')
addpath('../libraries/plotting/')

datadir = '../data/proc/';
fnames = dir([datadir '*.mat']);

load([datadir fnames(1).name])

%% Station time series

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