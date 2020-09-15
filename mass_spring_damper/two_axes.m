%this this a trest of using two axes
clear all
clc

f = figure;

ax1 = axes('Parent',f,'Units','normalized','Position',[.2 .6 .6 .3]);
grid(ax1,'on')
set(ax1,'XLim',[0,10],'YLim',[0,2],'YMinorGrid','on','XMinorGrid','on')

ax2 = axes('Parent',f,'Units','normalized','Position',[.1 .2 .6 .3]);
set(ax2,'XLim',[-1,1],'YLim',[-1,1],'DataAspectRatio',[1 1 1])
grid(ax2,'on')