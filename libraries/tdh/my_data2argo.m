function [data_time, data_2_argo] = my_map2argo(data_time,data_lon,data_lat,data,argo_time,argo_lon,argo_lat)


%   the_dir = '/Users/thennon/Desktop/WORK/O2data/OptodeData/';
% 
% load AVISOdata
% 
% 
% filenames = dir([the_dir '*.mat']);
% 
% 
% 
% for II = 21%:length(filenames)
%     
%    load([the_dir filenames(II).name])
%    
%    lat = argo.lat(3:end);
%    lon = argo.lon(3:end);     
%         id = find(lon < 0);
%    lon(id) = lon(id)+360;
%      
%    for i = 3:length(argo.lat)
%        da = argo.date{i}{1};
%        julday(i) = datenum(str2double(da(7:10)),str2double(da(1:2)),str2double(da(4:5)))+argo.time(i)/24;
%    end
%    julday = julday(3:end);
%   
% end
% %%
% data      = aviso.EKE;
% data_lon  = aviso.lon';
% data_lat  = aviso.lat';
% data_time = aviso.time;
% 
% argo_time = julday;
% argo_lon  = lon;
% argo_lat  = lat;
% 
lat_int = interp1(argo_time,argo_lat,data_time);
lon_int = interp1(argo_time,argo_lon,data_time);

for i = 1:length(data_time)
    

    
    idx = dsearchn(data_lon',lon_int(i));
    idy = dsearchn(data_lat',lat_int(i));
    
    data_2_argo(i) = data(idy,idx,i);
    
    
end

