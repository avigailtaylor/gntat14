%Author: Michael Wu
%Version: --
%Date: --
%Description: Sets the current figure to print on full page in LANDSCAPE mode.
%Implementation: DOWNLOADED FROM MATLAB CENTRAL.
%Keywords: current figure print full page LANDSCAPE.
%Example: This is an auxiliary function. IT HAS BEEN DOWNLOADED FROM MATLAB CENTRAL. Not intended for direct calling by the user.

function H=prh(H)
%function H=prh(H)
%
% sets the current figure to print on full page in LANDSCAPE mode.
%
% By Michael Wu  --  waftingpetal@yahoo.com (Oct 2001)
%
% ====================

if ~exist('H','var');
  H = gcf;
end;

papMarg=0.1;
set(H,'PaperOrientation','landscape','PaperPosition',[0+papMarg, 0+papMarg, 11-2*papMarg, 8.5-2*papMarg]);


