%Script to read the shapefile for FAO Ecological zones from http://www.fao.org/geonetwork/srv/en/main.home
%and convert it into a raster regridded to 1 degrees
%
%T. Pugh
%07.02.19

iffigs=false; %plot figures?
ecozone_shapefile='eco_zone/eco_zone.shp';

%---
%First map shapefile to 0.1 degree grid

S_raw=shaperead(ecozone_shapefile,'UseGeoCoords',true);
nS=length(S_raw);

[glon,glat]=meshgrid(-181:0.1:180.9,-91:0.1:90.9); %Allow a 1 degree buffer on either side because of some overflow in the domain edges (trim out later)
global_master=NaN(size(glon));

for ss=1:nS
    S=S_raw(ss);
    fprintf('ss is %d\n',ss)
    
    [inGrid, inRefVec] = vec2mtx(S.Lat, S.Lon, 10,'filled');
    
    if iffigs
        figure
        axesm eqdcyl
        meshm(inGrid, inRefVec)
    end
    
    if iffigs
        figure
        axesm eqdcyl
        meshm(inGrid3, inRefVec)
        
        plotm(S.Lat, S.Lon,'k')
    end
    inGrid3=inGrid;
    
    %Clean up numbering
    inGrid3(inGrid3>1)=NaN;
    inGrid3(inGrid3==0 | inGrid3==1)=S.GEZ_CODE;
    
    dimGrid=size(inGrid3);
    
    %Assign to global master array
    inte=1/inRefVec(1);
    slat=inRefVec(2)-dimGrid(1)/inRefVec(1);
    elat=inRefVec(2);
    slon=inRefVec(3);
    elon=inRefVec(3)+dimGrid(2)/inRefVec(1);
    
    slatind=int32((slat*10)+900+10); %+10 because of 1 degree buffer
    elatind=int32((elat*10)+900+10);
    slonind=int32((slon*10)+1800+10);
    elonind=int32((elon*10)+1800+10);
    [tlon,tlat]=meshgrid(slonind:elonind-1,slatind:elatind-1);
    
    [tlond,tlatd]=meshgrid(slon:inte:elon-inte,slat:inte:elat-inte);
    
    aa=find(inGrid3==S.GEZ_CODE);
    for nn=1:length(aa)
        global_master(tlat(aa(nn)),tlon(aa(nn)))=inGrid3(aa(nn));
    end
    clear nn aa
    
end
clear ss

%Aggregate to 1 degree
lats_1deg=-90:89;
lons_1deg=-180:179;

inGrid3_out=NaN(180,360);
for yy=1:180
    for xx=1:360
        aa=find(glon>=lons_1deg(xx) & glon<lons_1deg(xx)+1 & glat>=lats_1deg(yy) & glat<lats_1deg(yy)+1);
        if ~isempty(aa)
            inGrid3_out(yy,xx)=mode(global_master(aa));
        end
    end
    yy
end
clear xx yy aa

%Find what the ecozone numbers relate to in terms of code
for ss=1:nS
    S=S_raw(ss);
    Scode(ss)=S.GEZ_CODE;
    Sname{ss}=S.GEZ_CLASS;
end
Codes=unique(Scode,'stable');
Names=unique(Sname,'stable');

%Aggregate groups into ecozones
polar=50;
boreal=[42 41 43];
temperate=[31 35 32 33 34];
subtropical=[22 25 21 23 24];
tropical=[15 12 14 13 16 11];

ecozones=NaN(size(inGrid3_out));
ecozones(inGrid3_out==polar)=1;
ecozones(inGrid3_out==42 | inGrid3_out==41 | inGrid3_out==43)=2;
ecozones(inGrid3_out==31 | inGrid3_out==35 | inGrid3_out==32 | inGrid3_out==33 | inGrid3_out==34)=3;
ecozones(inGrid3_out==22 | inGrid3_out==25 | inGrid3_out==21 | inGrid3_out==23 | inGrid3_out==24)=4;
ecozones(inGrid3_out==15 | inGrid3_out==12 | inGrid3_out==14 | inGrid3_out==13 | inGrid3_out==16 | inGrid3_out==11)=5;

save ecozones_1deg.mat ecozones
save -v7.3 ecozones_raw_arrays.mat ecozones global_master inGrid3_out
