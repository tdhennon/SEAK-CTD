function [month] = my_findmonth(date1)
    for i = 1:length(date1)
        if isnan(date1(i)) == 0
            month(i) = str2double(datestr(date1(i),'mm'));
        else
            month(i) = NaN;
        end
    end
    
    
    

