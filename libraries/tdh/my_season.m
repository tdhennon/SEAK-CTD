function [season] = my_season(time,lat,win2sum,sum2win)

% Time should be in days since 1-Jan-0000 0:00:00
% Summer = 1
% Winter = 0

% sum2win - [month, day] when summer turns to winter

years = 1950:2020;

for i = 1:length(years)
    t1 = datenum(years(i),win2sum(1),win2sum(2));
    t2 = datenum(years(i),sum2win(1),sum2win(2));
    
    if datenum(years(i),1,1) < time & time <= t1
        season = 0;
    elseif t2 < time & time <= datenum(years(i)+1,1,1);
        season = 0;
    elseif t1 < time & time <= t2
        season = 1;
    end
end

if lat < 0 & season == 1
    season == 0;
elseif lat < 0 & season == 0
    season == 1;
end

