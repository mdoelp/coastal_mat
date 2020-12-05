
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  D3D Heading
%                                             Written by: Matthew Doelp
%                                             Email: mbdoelp@gmail.com

% clear all, close all
%-----------------------------------------------------
%   11/29/2020
%-----------------------------------------------------

% NOTES

% 

%% Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modify %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Directory


    type = 'integrated\';
    grd = 'grid_02\';
    mname = 'model_061\';
    project = 'Project1';
    
    fname = 'wavm-Waves.nc'
	fdir = ['\\Wahoo\e\19_27\modeling\',type,grd,mname,project];
    ncfile = [fdir,'.Project1.dsproj_data\Wave\',fname];
    
    % indir = ;
    outdir = ['F:\projects\19_27\modeling\delft3d\',type,grd,mname,project,'\solutions\wavesetup'];
    mkdir(outdir);

    %load(['F:\projects\19_27\modeling\delft3d\',type,grd,mname,project,'\d3dout'])

    
% Time




% Variable