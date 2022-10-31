function [zero half integral] = my_autolength(tlag,coef)
%tlag should start at zero



     j = 1;
     while coef(j) > 0
         j = j+1;
     end
     zero = tlag(j);
     j = 1;
     while coef(j) > 0.5
         j = j+1;
     end
     half = tlag(j);
     
        id = find(tlag == zero);
     area1 = ceil(sum(coef(1:id)));
     
     integral = tlag(area1);
     %integral = 0;
     
     
     
     
     