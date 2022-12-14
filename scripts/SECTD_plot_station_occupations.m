clear all; close all; 

addpath('../libraries/tdh/')
addpath('../libraries/m_map2/');
addpath('../libraries/plotting/colormap/')
addpath('../libraries/plotting/')

datadir = '../data/proc/';
fnames = dir([datadir '*.mat']);

load([datadir fnames(1).name])


%%
MONTH = 10;     
YEAR = 2022;


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



