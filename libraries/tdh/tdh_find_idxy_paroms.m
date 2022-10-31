function [idx idy] = tdh_find_idxy_paroms(lon,lat,lon0,lat0)

    xd = abs(lon(:)-lon0);
    yd = abs(lat(:)-lat0);


    [k id] = min(xd+yd);

    idx = floor(id/size(lon,1));
    idy = rem(id,size(lon,1));
end
