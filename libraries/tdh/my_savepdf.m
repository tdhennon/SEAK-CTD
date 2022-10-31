function my_savepdf(fig_hand,FigDirAndName)

set(fig_hand,'Units','Inches');
pos = get(fig_hand,'Position');
set(fig_hand,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
saveas(gcf,FigDirAndName,'pdf')
