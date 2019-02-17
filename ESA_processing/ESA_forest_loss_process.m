%Script to read in the ESA CCI landcover data files for 2000 to 2014 and put together a 1 degree array of
%annual forest loss.
%
%Note that this script is very memory intensive. Probably needs to be run on a cluster node.
%
%T. Pugh
%05.07.18

years=[2000 2014]; %Set the two years to compare between
nyears=length(years);

esa_forloss_1deg=NaN(180,360,nyears-1);

for yy=1:nyears-1
    
    fprintf('Year %d\n',years(yy));
    
    file1=['ESACCI-LC-L4-LCCS-Map-300m-P1Y-',mat2str(years(yy)),'-v2.0.7.tif'];
    file2=['ESACCI-LC-L4-LCCS-Map-300m-P1Y-',mat2str(years(yy+1)),'-v2.0.7.tif'];
    
    ESAin1=geotiffread(file1);
    fprintf('Read %s\n',file1);
    
    %Simplify to forest or non-forest landcover
    ESAin1(ESAin1==50 | ESAin1==60 | ESAin1==61 | ESAin1==62 | ESAin1==70 | ESAin1==71 | ESAin1==72 | ESAin1==80 | ESAin1==81 | ESAin1==82 | ESAin1==90 | ESAin1==100 | ESAin1==160 | ESAin1==170)=2;
    ESAin1(ESAin1==10 | ESAin1==11 | ESAin1==20 | ESAin1==30 | ESAin1==110 | ESAin1==130 | ESAin1==190)=3; %Croplands, grasslands and urban only
    fprintf('Simplified %s\n',file1);
    
    ESAin2=geotiffread(file2);
    fprintf('Read %s\n',file2);
    
    %Simplify to forest or non-forest landcover
    ESAin2(ESAin2==50 | ESAin2==60 | ESAin2==61 | ESAin2==62 | ESAin2==70 | ESAin2==71 | ESAin2==72 | ESAin2==80 | ESAin2==81 | ESAin2==82 | ESAin2==90 | ESAin2==100 | ESAin2==160 | ESAin2==170)=2;
    ESAin2(ESAin2==10 | ESAin2==11 | ESAin2==20 | ESAin2==30 | ESAin2==110 | ESAin2==130 | ESAin2==190)=3; %Croplands, grasslands and urban only
    fprintf('Simplified %s\n',file2);
    
    %For each pair of years identify cells where forest became non-forest
    
    ESAin1(ESAin1==2 & ESAin2==3)=1;
    fprintf('Identified forest loss cells\n');
    
    clear ESAin2
    
    %Sum up to areas at 1 degree resolution and store values
    
    rad_earth=6.371e6; %m2
    circ_earth=2*pi*rad_earth;
    areag=NaN(64800,1);
    grid=1/360;
    offset=grid/2;
    lat_map=-90+offset:grid:90-offset;
    basedist=circ_earth/(360/grid);
    for y=1:length(lat_map)
        areag(y)=basedist*basedist*cosd(lat_map(y)+offset); %m2
    end
    clear y basedist offset
    
    nlatcell=360;
    nloncell=360;
    for ii=1:360
        for jj=1:180
            indlat_s=(jj*nlatcell)-nlatcell+1;
            indlat_e=jj*nlatcell;
            indlon_s=(ii*nloncell)-nloncell+1;
            indlon_e=ii*nloncell;
            areag_ext=repmat(areag(indlat_s:indlat_e)',nloncell,1);
            
            temp=ESAin1(indlat_s:indlat_e,indlon_s:indlon_e);
            temp(temp>1)=0;
            temp_area=double(temp).*areag_ext;
            
            esa_forloss_1deg(jj,ii,yy)=sum(temp_area(:));
            clear temp temp_area
        end
        fprintf('%d\n',ii)
    end
    clear ii jj
    
end
clear yy

save('esa_forloss_1deg_cropgrassurb.mat','esa_forloss_1deg');

