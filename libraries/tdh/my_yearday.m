function [yearday] = my_yearday(julday,startmonth,startday)


years = 1850:2050;

for i = 1:length(years)-1
    t1 = datenum(years(i),startmonth,startday);
    t2 = datenum(years(i+1),startmonth,startday);
    
    id = find(t1 <= julday & julday < t2);
    
    yearday(id) = julday(id)-t1+1;
    
    
end

