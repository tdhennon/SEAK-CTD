
function [X2 Y2] = my_uniq(X1,Y1)
    X2 = unique(X1);
    Y2 = nan(size(X2));
    for ix = 1:length(X2)
        i2 = find(X2(ix) == X1);
        Y2(ix) = nanmean(Y1(i2));
        %if mod(ix,1000)==0
          %  disp([num2str(ix) '/' num2str(length(X2))])
        %end
    end
    clear ix
    
    