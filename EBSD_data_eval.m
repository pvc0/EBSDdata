%% Import Script for EBSD Data

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [3.7 3.7 3.7], 'mineral', 'Iron fcc', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('m-3m', [2.9 2.9 2.9], 'mineral', 'Iron bcc (old)', 'color', [0.8 0.74 0.12]),...
  crystalSymmetry('m-3m', [2.9 2.9 2.9], 'mineral', 'Fe-BCC', 'color', [0.85 0.65 0.8])};
%specimen symmetries: Iron fcc, Iron bcc, Fe-BCC; 
%fcc (kubisch flächenzentriert), bcc (kubisch raumzentriert)--> ferrit

% plotting convention
setMTEXpref('xAxisDirection','west');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = '\\nas.ads.mwn.de\tumw\utg\Umformer\DFG_Mikro_Elastizität_svi\02_Studenten\05_pleuchtenberger\Auswertung_Phasenanteile';

% which files to be imported
fname = [pname '\EBSD 980 Specimen 1 RD 1200X.ctf'];


%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');
%covertEuler2reference: map coordinates and euler angles refer to the same coordinate system

%% Phase plot and mineral composition

ebsd %command window
plot(ebsd('Fe-BCC'),'DisplayName', 'Ferrit');
hold on
plot(ebsd('notIndexed'), 'FaceColor', 'Gray', 'DisplayName', 'Martensit'); %figure
hold off

RD = vector3d.X; %rolling direction
TD = vector3d.Y; %transversal direction
ND = vector3d.Z; %normal direction


%% Visualising orientations of Fe-BCC/Ferrit

% ipfKey = ipfColorKey(ebsd('Fe-BCC'));
% ipfKey.inversePoleFigureDirection = RD;
% 
% figure
% subplot(2,1,1)
% plot(ipfKey) %see which color refers to which direction
% title('Color - Orientation')
% 
% colors = ipfKey.orientation2color(ebsd('Fe-BCC').orientations);
% subplot(2,1,2)
% plot(ebsd('Fe-BCC'),colors)
% title('Orientations of Austenit')

% calculation of grain lists and plotting them
[grains, ebsd.grainId, ebsd.mis2mean] = calcGrains(ebsd, 'angle', 10*degree); %misorientation threshold of x degrees: MATLAB draws a grain boundary between two points which have this misorientation between them


% reducing noise in EBSD points (i. e. because of the threshold)
ebsd = clean_grains(ebsd, grains, 4);%pixel threshold of x: removing all grains smaller than x pixels


%recalculation of new, cleaned EBSD data
[grains, ebsd.grainId, ebsd.mis2mean] = calcGrains(ebsd, 'angle', 10*degree); 


% create smooth grain boundaries and plotting smoothed grains
grains = smooth(grains ,4);%x: level of smoothing


% plotting orientations
IPF_grains_map(grains, 'Fe-BCC', RD);
%one color represents mean orientation of an individual grain
%to see which orientation refers to which color: ipfKey

%% Visualising orientations of NotIndexed/Martensit

%Probleme weil keine Info zu Index und Symmetrie


%% Pole Figures

setMTEXpref('xAxisDirection', 'east');
setMTEXpref('zAxisDirection', 'outOfPlane');

%Fe-BCC
figure();
ori = ebsd('Fe-BCC').orientations;
x = [Miller(1,0,0,ebsd('Fe-BCC').CS), Miller(1,1,0,ebsd('Fe-BCC').CS), Miller(1,1,1,ebsd('Fe-BCC').CS)];
plotPDF(ori, x, 'antipodal', 'contourf','MarkerSize', 6, 'minmax');
mtexColorbar
CLim(gcm, 'equal');
mtexColorbar

