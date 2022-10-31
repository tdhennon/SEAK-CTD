function [h] = plot_acc(FrontType,varargin)
%PLOT_ACC plots Antarctic Circumpolar Current Fronts as identified byOrsi, A. H., T. Whitworth III and 
%W. D. Nowlin, Jr., 1995: On the meridional extent and fronts of the Antarctic 
%Circumpolar Current, Deep-Sea Res. I, 42, 641-673. 
% 
% Requires Chad Greene's Antarctic Mapping Tools.
% 
%% Syntax
% 
%  plot_acc('FrontType')
%  plot_acc(...,'MarkerProperty',MarkerValue)
%  h = plot_acc(...)
%
%% Description
% 
% plot_acc('FrontType') plots one of the following ACC fronts on a map (they following list
% is ordered from north to south:
% 
%   'stf'   or 'subtropical front' 
%   'saf'   or 'subantarctic front'
%   'pf'    or 'polar front'
%   'saccf' or 'southern antarctic circumpolar current front'
%   'sbdy'  or 'southern boundary'
%   'all'
% 
% plot_acc(...,'MarkerProperty',MarkerValue) specifies marker properties. 
% 
% h = plot_acc(...) returns handle(s) of plottet object(s). 
% 
% 
%% Example
% 
% load coast
% antmap
% patchm(lat,long,[.5 .5 .5])
% plot_acc('stf') 
% plot_acc('sbdy','markersize',12,'color','magenta') 
% 
%% How it works
% 
% If the function does not find data locally, it'll try to download the
% data.  Data files are small, and the download should take less than a
% second. More information can be found here: 
% Downloads front data from World Ocean Circulation Experiment Southern
% Ocean Atlas http://woceatlas.tamu.edu/Sites/html/atlas/SOA_DATABASE_DOWNLOAD.html
% 
%% Author Info
% Written by Chad A. Greene of the University of Texas Institute for
% Geophysics, August 2014. This is a plugin to Antarctic Mapping Tools. 
%
% See also antmap. 

%% Some toolbox and data availability checks: 

% Look for Antarctic Mapping Tools: 
assert(exist('antmap.m','file')==2,'Hmmm...I can''t find some essential tools from the Antarctic Mapping Tools package. Do you have that toolbox installed where someone can find it?') 

% Check if ACC front data are local, download if necessary: 
if exist('pf.txt.','file')~=2
    disp('Cannot find ACC front data. Downloading now...') 
    try
        unzip('http://woceatlas.tamu.edu/Sites/zip/atlas/fronts.zip');
    catch 
        error('Had trouble downloading ACC front data. Try to unzip it manually and put it somewhere Matlab can find it. Data can be found here: http://woceatlas.tamu.edu/Sites/zip/atlas/fronts.zip');
    end
end

% Check if map is current: 
mapinitialized = false;
try % Is a map already initialized? 
    mapinitialized = strcmpi(getm(gca,'MapProjection'),'stereo');
end
if ~mapinitialized 
    antmap('northernlimit',-45)
end

%% Check function inputs: 

switch lower(FrontType) 
    case {'pf','polar front','polar'}
        FrontData = importdata('pf.txt'); 
        h = plotm(FrontData.data(:,2),FrontData.data(:,1),'.',varargin{:}); 
        
    case {'saccf','southern acc front'}
        FrontData = importdata('saccf.txt'); 
        h = plotm(FrontData.data(:,2),FrontData.data(:,1),'.',varargin{:}); 
        
    case {'saf','subantarctic front','subantarctic'}
        h = plotm(FrontData.data(:,2),FrontData.data(:,1),'.',varargin{:}); 
        FrontData = importdata('saf.txt'); 
        
    case {'sbdy','southern boundary'} 
        FrontData = importdata('sbdy.txt'); 
        h = plotm(FrontData.data(:,2),FrontData.data(:,1),'.',varargin{:}); 
        
    case {'stf','subtropical front','subtropical'} 
        FrontData = importdata('stf.txt'); 
        h = plotm(FrontData.data(:,2),FrontData.data(:,1),'.',varargin{:}); 
        
    case {'all'}
        FrontData = importdata('pf.txt'); 
        h(1) = plotm(FrontData.data(:,2),FrontData.data(:,1),'.','color',[0 0 1],varargin{:}); 
        FrontData = importdata('saccf.txt'); 
        h(2) = plotm(FrontData.data(:,2),FrontData.data(:,1),'.','color',[1 0 0],varargin{:}); 
        FrontData = importdata('saf.txt'); 
        h(3) = plotm(FrontData.data(:,2),FrontData.data(:,1),'.','color',[0 1 1],varargin{:}); 
        FrontData = importdata('sbdy.txt'); 
        h(4) = plotm(FrontData.data(:,2),FrontData.data(:,1),'.','color',[0 0 .17],varargin{:});
        FrontData = importdata('stf.txt');
        h(5) = plotm(FrontData.data(:,2),FrontData.data(:,1),'.','color',[.17 .10 .72],varargin{:}); 
    
    otherwise
        error('Unrecognized ACC Front Type.')
end

%% Clean up: 

if nargout==0
    clear h
end

end