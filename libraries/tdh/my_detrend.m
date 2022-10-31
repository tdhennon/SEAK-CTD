function y = my_detrend(x0,y0)
    id = find(isnan(y0) == 0);
    
    coef = polyfit(x0(id),y0(id),1);
    
    y = y0 - (x0*coef(1)+coef(2));
    