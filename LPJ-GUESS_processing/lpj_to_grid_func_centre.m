function map=lpj_to_grid_func_centre(file_in,nyear,yearcolumn)
%Function to read in a LPJ-GUESS output file and reformat it into a
%multi-dimensional array suitable for making Matlab plots with.
%
% file_in - input file, either as raw LPJ-GUESS output file, or a tslice
% nyear - number of years in input file (1 for tslice)
% yearcolumn - =1 if there is a year column in file, =0 otherwise.
%
%T. Pugh
%07.05.13

minlat=-89.75;
maxlat=89.75;
minlon=-179.75;
maxlon=179.75;
grid=0.5;

data_in=dlmread(file_in,'',1,0);
a=size(data_in);
ndata=a(1);
ncol=a(2);
clear a

nsites=ndata/nyear; %number of sites

data=NaN(nsites,nyear,ncol);
for c=1:ncol
    for i=1:nsites
        nstart=(i*nyear)-nyear+1;
        nend=i*nyear;
        data(i,:,c)=data_in(nstart:nend,c);
    end
end
lon=data(:,1,1);
lat=data(:,1,2);
if yearcolumn==1
    data(:,:,1:3)=[];
    ncol=ncol-3;
else
    data(:,:,1:2)=[];
    ncol=ncol-2;
end
clear c i

lon_map=minlon:grid:maxlon;
lat_map=minlat:grid:maxlat;
map=zeros(length(lat_map),length(lon_map),nyear,ncol);
for c=1:ncol
    fprintf('column: %d\n',c);
        for i=1:nsites
            x=find(lon_map==lon(i));
            y=find(lat_map==lat(i));
            map(y,x,:,c)=data(i,:,c);
        end
end