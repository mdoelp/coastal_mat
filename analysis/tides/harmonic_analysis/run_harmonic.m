
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Run Harmonic Analysis
%                                                       Matthew Doelp
%                                                       mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%-----------------------------------------------------

%% DIRECTORY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('\\MORGAN2018\Users\Public\Projects\18-05 Chatham\SMS\tides')
infile = 'boston_2007navdft10min.elv'
outfile = 'data'
sdate = '08-Nov-2003 10:00:00'
edate = '30-Nov-2003 14:00:00'


%% DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [N T R] = xlsread('')

[amp phase] = harmonics(infile,outfile,sdate,edate)