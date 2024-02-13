function field = readnetcdf(field,filename,fieldname,subdim)
% function field = readnetcdf(field,filename,fieldname,subdim)

%
% $Id: readnetcdf.m,v 1.2 2015/06/11 18:07:33 patrick Exp $
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

ncid = netcdf.open(filename,'NOWRITE');

varid = netcdf.inqVarID(ncid,fieldname);

[name,xtype,dimids,natts] = netcdf.inqVar(ncid,varid);
if field.verbose,
  fprintf(1,'Variable `%s'' has %d dimensions\n', name, length(dimids));
end;

for i=dimids,
  [dname{i+1}, dlen(i+1)] = netcdf.inqDim(ncid,i);
	if field.verbose>1,
	  fprintf(1,'var %15s dimid %d length %d\n',dname{i+1},i,dlen(i+1));
	end
end

if ~exist('subdim') | isempty(subdim),
  start  = zeros(size(dimids));
  stride = ones(size(dimids));
  edge   = dlen(dimids+1);
else
  for i=1:length(subdim),
    if isempty(subdim{i})
      start(i)  = 0;
      stride(i) = 1;
      edge(i)   = dlen(dimids(i)); %dimsizes(i);
    else, 
      start(i) = subdim{i}(1)-1;
      if length(subdim{i})>1,
        stride(i) = subdim{i}(2)-subdim{i}(1);
      else
        stride(i) = 1;
      end
      edge(i) = length(subdim{i});
    end
  end
end

if field.verbose > 1,
  fprintf(1,'start = %4d, stride = %4d, edge = %4d\n',...
          [start;stride;edge])
end

var = netcdf.getVar(ncid,varid,start,edge,stride);
field.var = double(var);
field.varname = name2label(name);

for dim_number=1:length(dimids),
  name = dname{dimids(dim_number)+1};
	varid = netcdf.inqVarID(ncid,name);
  vardim = netcdf.getVar(ncid,varid);
  field.dims{dim_number} = double(vardim);
  if exist('subdim') & ~isempty(subdim) & ~isempty(subdim{dim_number}),
    field.dims{dim_number} = field.dims{dim_number}(subdim{dim_number});
  end
  count = length(vardim);
  if field.verbose,
    fprintf(1,'--> %4.d elements in dimension `%s''\n',count,name);
  end
  field.dimsname{dim_number} = name2label(name);
end

netcdf.close(ncid);

end % function
