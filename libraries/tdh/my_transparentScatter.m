function scatterPoints = my_transparentScatter(x,y,sizeOfCircle,opacity,circle_color)
% usage example:
% scatterPoints = transparentScatter(randn(5000,1),randn(5000,1),0.1,0.05,[1 0 1]);
% set(scatterPoints,'FaceColor',[1,0,0]);


    defaultColors = get(0,'DefaultAxesColorOrder');
    assert(size(x,2)  == 1 && size(y,2)  == 1 , 'x and y should be column vectors');
    t= 0:pi/10:2*pi;

    rep_x = repmat(x',[size(t,2),1]);
    rep_y = repmat(y',[size(t,2),1]);
    rep_t = repmat(t',[ 1, size(x,1)]);

    scatterPoints = patch((sizeOfCircle*sin(rep_t)+ rep_x),(sizeOfCircle*cos(rep_t)+rep_y),defaultColors(1,:),'edgecolor','none','facecolor',circle_color);
    %alpha(scatterPoints,opacity);