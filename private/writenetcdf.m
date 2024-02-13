function writenetcdf(filename,varargin)
% function writenetcdf(filename,varargin) 

%
% $Id: writenetcdf.m,v 1.3 2017/03/16 15:59:13 patrick Exp $
%
% Copyright (c) 2014 Patrick Guio <patrick.guio@gmail.com>
% All Rights Reserved.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

if ~exist(filename,'file'), % 
  ncid = netcdf.create(filename,'NOCLOBBER');
else
  ncid = netcdf.create(filename,'CLOBBER');
end

s = varargin{1};

varid = netcdf.getConstant('GLOBAL');
netcdf.putAtt(ncid,varid,'Version',s.ver{1});

for i=1:length(varargin)
  s = varargin{i};
  % type = 'double';
	type = 'float';
	rank = ndims(s.var);
	dimsizes = size(s.var);
	for j=1:rank,
	  if strcmp(lower(s.dimsname{j}),'time') | strcmp(s.dimsname{j},'\tau'),
	    dimid(j) = netcdf.defDim(ncid,'time',netcdf.getConstant('UNLIMITED'));
			varid = netcdf.defVar(ncid,'time',type,dimid(j));
		else
	    try,
	      dimid(j) = netcdf.defDim(ncid,s.dimsname{j},dimsizes(j));
	      varid = netcdf.defVar(ncid,s.dimsname{j},type,dimid(j));
	    catch exception, % catch exception when dim already defined
	      if strcmp(exception.identifier,'MATLAB:imagesci:netcdf:libraryFailure'),
	        dimid(j) = netcdf.inqDimID(ncid,s.dimsname{j});
	      end
	    end
		end
  end
	varid = netcdf.defVar(ncid,s.varname,type,dimid);

end

netcdf.close(ncid);

ncid = netcdf.open(filename,'WRITE');

for i=1:length(varargin)
  s = varargin{i};
	type = 'float';
	rank = ndims(s.var);
	dimsizes = size(s.var);
	for j=1:rank,
	  s.dimsname{j};
		if strcmp(lower(s.dimsname{j}),'time') | strcmp(s.dimsname{j},'\tau'),
		  varid = netcdf.inqVarID(ncid,'time');
		else
		  varid = netcdf.inqVarID(ncid,s.dimsname{j});
		end
		data = single(s.dims{j});
		netcdf.putVar(ncid,varid,0,dimsizes(j),data);
	end
	varid = netcdf.inqVarID(ncid,s.varname);
	data = single(s.var);
	start = zeros(1,rank);
	netcdf.putVar(ncid,varid,start,dimsizes,data);
end

netcdf.close(ncid);

end % function
