clear all; close all; 

addpath('../libraries/rbr-rsktools/');
addpath('../libraries/tdh/')
addpath('../libraries/m_map2/');
addpath('../libraries/plotting/colormap/')
addpath('../libraries/plotting/')

%%
T = readtable('../data/SE_Trolling_Log.xlsx');


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

dirs = genpath('../data/raw/'); %gets all the paths in the raw data directory
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



save(['../data/proc/merged_cast_data_' datestr(now,'yyyy-mm-dd')],'cast')



%%


%%





