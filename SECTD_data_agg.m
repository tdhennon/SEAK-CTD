clear all; close all; 

addpath('libraries/rbr-rsktools/');
addpath('libraries/tdh/')
addpath('libraries/m_map2/');
addpath('libraries/plotting/colormap/')
addpath('libraries/plotting/')

%%
T = readtable('data/SE_Trolling_Log.xlsx');


logb.date = datenum(table2array(T(:,1))); 
logb.tod = table2array(T(:,3));
logb.statid = table2array(T(:,2));
logb.loc_or_utc = table2array(T(:,4));
logb.lon = -table2array(T(:,6));
logb.lat = table2array(T(:,5));
logb.H_orig = table2array(T(:,7));
logb.H_unit = table2array(T(:,8));
logb.flag = table2array(T(:,9));
logb.SN = table2array(T(:,10));
logb.vessel = table2cell(T(:,11));
logb.note = table2cell(T(:,12));

for ii = 1:length(logb.date)
    if logb.loc_or_utc(ii) == 1
        logb.time(ii) = logb.date(ii)+logb.tod(ii); %currently setting UTC to local time too.... mistake :? 
    elseif logb.loc_or_utc(ii) == 2
        logb.time(ii) = logb.date(ii)+logb.tod(ii);        
    end
    if logb.H_unit(ii) == 1
        logb.H(ii) = logb.H_orig(ii);
    elseif logb.H_unit(ii) == 2
        logb.H(ii) = logb.H_orig(ii)*.3048; %feet to meter
    elseif logb.H_unit(ii) == 3
        logb.H(ii) = logb.H_orig(ii)*1.8288; %fathom to meter
    end
end

%%

dirs = genpath('data/raw/'); %gets all the paths in the raw data directory
dirs = strsplit(dirs,':'); %splits up the single string into many directories

reg_ctd = [210673 210674];
chl_ctd = [210675];

time = [];
salt = [];
temp = [];
chlr = []; 
SN   = [];

pgrid = 0:1:500;
for II = 1:length(dirs)
    fnames = dir([dirs{II} '/*.rsk']); %look for rsk data 
    
    for JJ = 1:length(fnames)
        fstr = fnames(JJ).name;
        sid = findstr(fstr,'_');
        ctd_sn = str2double(fstr(1:sid-1));

        disp(['Downloading ' dirs{II} '/' fnames(JJ).name ' ...'])

        rsk = RSKopen([dirs{II} '/' fnames(JJ).name]); %open the data
        
        abc = RSKreaddata(rsk); % read data
        ghi = RSKtimeseries2profiles(abc); % turn into profiles

        if ismember(ctd_sn,chl_ctd)==1  % TODO!!! MAKE ONE FOR THE OTHER CTD TYPE!

        %1 = cond19, 2 = temp14, 3 = pres24, 4=fluo10, 5 = pres08,
        %6=dpth01,   7 = sal_00, 8 = sos_00, 9=scon00
        
            for KK = 1:length(ghi.data)
                if strcmp(ghi.data(KK).direction,'down')
                    p = ghi.data(KK).values(:,3);
                    t = ghi.data(KK).values(:,2);
                    s = ghi.data(KK).values(:,7);
                    c = ghi.data(KK).values(:,4);

                    tavg = NaN(size(pgrid));
                    savg = NaN(size(pgrid));
                    cavg = NaN(size(pgrid));

                    for LL=1:length(pgrid)-1
                        pid = find(pgrid(LL) <= p & p < pgrid(LL+1));
                        tavg(LL) = nanmean(t(pid));
                        savg(LL) = nanmean(s(pid));
                        cavg(LL) = nanmean(c(pid));
                    end

                    temp = [temp tavg'];
                    salt = [salt savg'];
                    chlr = [chlr cavg'];
                    SN = [SN; ctd_sn];
                    time = [time; ghi.data(KK).tstamp(1)];
                end


                
            end

        elseif ismember(ctd_sn,reg_ctd)==1
                        for KK = 1:length(ghi.data)

            if strcmp(ghi.data(KK).direction,'down')
                    p = ghi.data(KK).values(:,3);
                    t = ghi.data(KK).values(:,2);
                    s = ghi.data(KK).values(:,6);
                    

                    tavg = NaN(size(pgrid));
                    savg = NaN(size(pgrid));
                    cavg = NaN(size(pgrid));

                    for LL=1:length(pgrid)-1
                        pid = find(pgrid(LL) <= p & p < pgrid(LL+1));
                        tavg(LL) = nanmean(t(pid));
                        savg(LL) = nanmean(s(pid));
                    end
                        

                    temp = [temp tavg'];
                    salt = [salt savg'];
                    chlr = [chlr cavg'];
                    SN = [SN; ctd_sn];
                    time = [time; ghi.data(KK).tstamp(1)];
            end

                        end
        end
    end
end

[x uid] = unique(time); %find unique casts (avoiding duplicated data) by searching for unique cast start times...

cast.temp = temp(:,uid);
cast.salt = salt(:,uid);
cast.chlr = chlr(:,uid);
cast.SN  = SN(uid);
cast.time = time(uid);
cast.pgrid = pgrid;

%%
usn = unique(cast.SN);
for ii = 1:length(usn)
    disp('  ')
    disp([num2str(usn(ii))])
    idsn = find(cast.SN == usn(ii));
    dt = cast.time(idsn);
    dt = sort(dt);
    for jj = 1:length(dt)
        disp(datestr(dt(jj)))
    end


end


%%

delta_t = 15/60/24; %search for start times within 15 minutes

for ii = 1:length(logb.time)
    idt = find(logb.time(ii) - delta_t <= cast.time & cast.time < logb.time(ii)+delta_t); 
    if length(idt) == 1
        cast.lon(idt) = logb.lon(ii);
        cast.lat(idt) = logb.lat(ii);
        cast.H(idt) = logb.H(ii);
        cast.statid(idt) = logb.statid(ii);
        
    elseif length(idt) > 1
        disp('LOGBOOOK WARNING: MULTIPLE RBR CASTS FOUND')
    elseif length(idt) == 0
        disp('LOGBOOK WARNING: NO MATCHING RBR CAST FOUND')
        disp([datestr(logb.time(ii)) ])
    end

end

for ii = 1:length(cast.time)
    tcast = cast.time(ii);
    tlog  = logb.time; 
    idt = find(tcast - delta_t <= tlog & tlog <= tcast + delta_t);

    if isempty(idt) == 1
        disp('CTD CAST WARNING: NO MATCHING LOGBOOK ENTRY FOUND')
        disp([datestr(tcast)])
    end

end

%%





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

STATION = 2;
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

%%





