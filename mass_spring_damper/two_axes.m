%this this a trest of using two axes
clear all
clc

f = figure;

% ax1 = axes('Parent',f);
ax1 = axes('Parent',f,'Units','normalized','Position',[.2 .2 .6 .3]);

ax2 = axes('Parent',f,'Units','normalized','Position',[.2 .6 .6 .3]);
grid(ax2,'on')
