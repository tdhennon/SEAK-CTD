function [ID0 IDF] = my_longseg(test);

%test = [9 15 17 18 19 20 21 22 24 25 26 28 29 30 32 34 36];
if length(test) > 1 
i = 1;
    for L = 1:1000   
        id0(L) = i;
       while test(i)+1 == test(i+1) 
            i = i+1;
            if i+1 > length(test)
                idf(L) = i;
                break
            end
       end
       idf(L) = i;
        i = i+1;
        if i+1 > length(test)
            break
        end
        
    end
    
    [c id] = max(idf-id0);
    
    ID0 = id0(id);
    IDF = idf(id);
    
else
    ID0 = [];
    IDF = [];
end