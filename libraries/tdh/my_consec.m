%clear all; close all; 

function [id1 idf] = my_consec(ID)

%ID = [149 179 180 181 182 183 184 217];

d0 = 1;
 d = 1;
 
for L = 1:1000
    if d0 < length(ID)
        while ID(d+1)-ID(d) == 1
            d = d+1;
            if d+1 > length(ID)
                break
            end
        end
        id1(L) = d0;
        idf(L) = d;
    
    d0 = d+1;
     d = d+1;
     
    if d > length(ID)
        break
    end
    else
        id1(L) = d0;
        idf(L) = d;
        break
    end
    
end



